# ESSE É O CÓDIGO DE GERAÇÃO DE DUNGEON QUE ESTOU ATUALIZANDO

extends Node2D

@export var ground_layer : TileMapLayer
@export var walls_layer : TileMapLayer
@export var player : CharacterBody2D

enum {FLOOR, WALL}
enum {EMPTY, ROOM, SPAWN_ROOM, END_ROOM}
# Por enquanto, nas minhas ideias, uma END_ROOM pode ser
# - sala de chefe
# - sala do tesouro
# - sala de desafio (Rogue Legacy 2)
# - sala de loja
#   - loja de comida (Dead Cells)
#   - loja de tesouro

const WIDTH = 50 # Tamanho total do mapa EM TILES, E NÃO EM PIXELS
const HEIGHT = 50
const CELL_SIZE = 32 # Se cada tile é 32x32...
const MIN_ROOM_SIZE = 7
const MAX_ROOM_SIZE = 15
const MAX_ROOMS = 17
const ROOM_MATRIX_SIZE = 8 # Tamanho 13 seria a sala void do binding of isaac (muito grande

var grid = [] # matriz: 0 = chão, 1 = parede
var room_matrix = []
var rooms = []

# Preenche com parede inicialmente
func initialize_grid():
	for x in range(WIDTH):
		grid.append([])
		for y in range(HEIGHT):
			grid[x].append(WALL)

func initialize_room_matrix():
	for x in range(ROOM_MATRIX_SIZE):
		room_matrix.append([])
		for y in range(ROOM_MATRIX_SIZE):
			room_matrix[x].append(EMPTY)
			
func adjacent_rooms(pos: Vector2i) -> int:
	if room_matrix[pos.x][pos.y] == EMPTY:
		return 0

	var adjacent_count = 0
	var directions = [
		Vector2i(0,-1),
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 0)
	]

	for dir in directions:
		var neighbor = pos + dir
		if neighbor.x >= 0 and neighbor.x < room_matrix.size() and neighbor.y >= 0 and neighbor.y < room_matrix.size():
			if room_matrix[neighbor.x][neighbor.y] != EMPTY:
				adjacent_count += 1

	return adjacent_count

	
@export var mini_map_node : Node2D # Apenas para debugar a dungeon gerada
	
# TODO As vezes está dando loop infinito, identificar o por que
func create_dungeon_skeleton():
	var initial_room = Vector2i(ROOM_MATRIX_SIZE / 2, ROOM_MATRIX_SIZE / 2)
	var last_room = initial_room
	var queue = [initial_room]
	var visited_rooms = 0
	
	var directions = [
		Vector2i(0,-1),
		Vector2i(1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 0)
	]
	
	var tries = 0 # Essa variavel serve apenas para capturar casos de loop infinito
	
	while visited_rooms < MAX_ROOMS:
		if tries >= 20: # As vezes o tries aumenta de 2 em 2, ou de 3 em 3, etc... por isso não dá pra usar um "==" aqui
			break

		var current_room = last_room
		
		if !queue.is_empty():
			current_room = queue.pop_back() # pega e tira primeiro elemento
			last_room = current_room
			room_matrix[current_room.x][current_room.y] = ROOM # colocando como visitada
			visited_rooms += 1
		
		var shuffled = directions.duplicate()
		shuffled.shuffle()
		
		for dir in shuffled:
			var next_room_vec = current_room + dir
			var can_expand = next_room_vec.x > 0 and next_room_vec.x < room_matrix.size() - 1 and next_room_vec.y > 0 and next_room_vec.y < room_matrix.size() - 1 \
							 and room_matrix[next_room_vec.x][next_room_vec.y] == EMPTY
			# Se o can_expand for falso e a fila for vazia, vai entrar em loop infinito, por que sempre vai tentar achar uma direção mas nunca vai conseguir, ao mesmo tempo que current_room nunca vai mudar
			# TALVEZ RESOLVIDO com o tries
			# TODO aparentemente não resolveu
			# Com a adição do ">=" em vez do "==", talvez tenha resolvido
			
			var adjacent_rooms = int((next_room_vec.x + 1) < (room_matrix.size() - 1) and room_matrix[next_room_vec.x + 1][next_room_vec.y] == ROOM) \
							   + int((next_room_vec.x - 1) > 0                        and room_matrix[next_room_vec.x - 1][next_room_vec.y] == ROOM) \
							   + int((next_room_vec.y + 1) < (room_matrix.size() - 1) and room_matrix[next_room_vec.x][next_room_vec.y + 1] == ROOM) \
							   + int((next_room_vec.y - 1) > 0                        and room_matrix[next_room_vec.x][next_room_vec.y - 1] == ROOM)
							
			var chance = randi() % (adjacent_rooms + 1) == 1
			if chance and can_expand:
				queue.append(next_room_vec)
			elif queue.is_empty():
				tries += 1
				print("Veio pro tries:", tries)
	
	room_matrix[initial_room.x][initial_room.y] = SPAWN_ROOM
	
	for x in range(ROOM_MATRIX_SIZE):
		for y in range(ROOM_MATRIX_SIZE):
			var adjacent_rooms_qtd = adjacent_rooms(Vector2i(x, y))
			if adjacent_rooms_qtd == 1 and room_matrix[x][y] != SPAWN_ROOM:
				room_matrix[x][y] = END_ROOM 
	
	# Aqui é onde eu falo pro mini mapa desenhar a dungeon
	mini_map_node.set_grid(room_matrix)

# TODO: Entender melhor depois
func generate_room() -> Rect2:
	var w = randi() % 11 + 10  # entre 10 e 20
	var h = randi() % 11 + 10
	
	# Posição superior esquerda do quadrado
	var x = randi() % (WIDTH - w - 2) + 1
	var y = randi() % (HEIGHT - h - 2) + 1
	return Rect2(x, y, w, h)
	
func place_room(room: Rect2) -> bool:
	for x in range(room.position.x, room.end.x):
		for y in range(room.position.y, room.end.y):
			# Se já tiver chão no espaço desse quadrado, esquece
			if grid[x][y] == FLOOR:
				return false
				
	for x in range(room.position.x, room.end.x):
		for y in range(room.position.y, room.end.y):
			# Coloca chão
			grid[x][y] = FLOOR
	return true
	
func connect_rooms(room_a: Rect2, room_b: Rect2):
	var passage_width = randi() % 2 + 1
	var start = room_a.position + room_a.size / 2
	var end = room_b.position + room_b.size / 2
	
	var x = int(start.x)
	var y = int(start.y)
	
	# Faz um caminho entre as duas salas, os caminhos podem ser:
	# - um corredor reto entre as salas
	# - um corredor que cria uma curva perpendicular entre as salas
	while x != int(end.x):
		x += 1 if end.x > x else -1
		for i in range(1, passage_width + 1):
			grid[x][y+i] = FLOOR 
			grid[x][y-i] = FLOOR
		grid[x][y]   = FLOOR
		
	while y != int(end.y):
		y += 1 if end.y > y else -1
		for i in range(1, passage_width + 1):
			grid[x+i][y] = FLOOR 
			grid[x-i][y] = FLOOR
		grid[x][y] = FLOOR

	
func generate_dungeon():
	initialize_grid()
	for i in range(MAX_ROOMS):
		var room = generate_room()
		if place_room(room):
			if rooms.size() > 0:
				connect_rooms(rooms[-1], room)
			rooms.append(room)
			
var floor_tile := Vector2i(6,8)
var up_wall_tile := Vector2i(1,6)
var down_wall_tile := Vector2i(1,10)
var right_wall_tile := Vector2i(15,7) # Já serve como diagonal
var left_wall_tile := Vector2i(0,9)   # Já serve como diagonal
var right_down_wall_tile := Vector2i(4,10)
var left_down_wall_tile := Vector2i(0,10)
var inner_wall_tile := Vector2i(7,5)
var left_corner_1 := Vector2i(5,9)
var right_corner_1 := Vector2i(4,9)

func draw_dungeon():
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var tile = Vector2i(x, y)
			# Condições de colocar os tiles
			if grid[x][y] == FLOOR:
				ground_layer.set_cell(tile, 1, floor_tile)
			else:
				
				var left_down_corner_1 = x < WIDTH - 1 and y > 0 and grid[x][y-1] == WALL and grid[x+1][y] == WALL and grid[x+1][y-1] == FLOOR
				var right_down_corner_1 = x > 0 and y > 0 and grid[x][y-1] == WALL and grid[x-1][y] == WALL and grid[x-1][y-1] == FLOOR
				var top_wall = y < HEIGHT - 1 and grid[x][y+1] == FLOOR
				var right_wall = x > 0 and x < WIDTH - 1 and grid[x+1][y] == WALL and grid[x-1][y] == FLOOR and grid[x][y-1] == WALL and grid[x][y+1] == WALL
				var left_wall = x > 0 and x < WIDTH - 1 and y > 0 and y < HEIGHT -1 and grid[x+1][y] == FLOOR and grid[x-1][y] == WALL and grid[x][y-1] == WALL and grid[x][y+1] == WALL
				var bottom_wall = y > 0 and y < HEIGHT - 1 and grid[x][y+1] == WALL and grid[x][y-1] == FLOOR and grid[x-1][y] == WALL and grid[x+1][y] == WALL
				var left_down_corner_2 = x > 0 and y < HEIGHT - 1 and x < WIDTH - 1 and y > 0 and grid[x-1][y] == WALL and grid[x][y+1] == WALL and grid[x+1][y-1] == FLOOR 
				var right_down_corner_2 = x > 0 and y < HEIGHT - 1 and x < WIDTH - 1 and y > 0 and grid[x+1][y] == WALL and grid[x][y+1] == WALL and grid[x-1][y-1] == FLOOR
				var left_top_corner = x < WIDTH - 1 and y < HEIGHT - 1 and grid[x][y+1] == WALL and grid[x+1][y] == WALL and grid[x+1][y+1] == FLOOR
				var right_top_corner = x > 0 and y < HEIGHT - 1 and grid[x][y+1] == WALL and grid[x-1][y] == WALL and grid[x-1][y+1] == FLOOR
				
				if left_down_corner_1:
					walls_layer.set_cell(tile, 0, left_down_wall_tile)
				elif right_down_corner_1:
					walls_layer.set_cell(tile, 0, right_down_wall_tile)
				elif top_wall:
					walls_layer.set_cell(tile, 0, up_wall_tile)
				elif left_wall:
					walls_layer.set_cell(tile, 0, left_wall_tile)
				elif right_wall:
					walls_layer.set_cell(tile, 0, right_wall_tile)
				elif bottom_wall:
					walls_layer.set_cell(tile, 0, down_wall_tile)
				elif left_down_corner_2:
					walls_layer.set_cell(tile, 0, left_corner_1)
				elif right_down_corner_2:
					walls_layer.set_cell(tile, 0, right_corner_1)
				elif left_top_corner:
					walls_layer.set_cell(tile, 0, left_wall_tile)
				elif right_top_corner:
					walls_layer.set_cell(tile, 0, right_wall_tile)
				else:
					walls_layer.set_cell(tile, 0, inner_wall_tile)

func _ready():
	randomize()
	initialize_room_matrix()
	create_dungeon_skeleton()
	generate_dungeon()
	draw_dungeon()
	player.global_position = (rooms[0].position + rooms[0].size / 2) * CELL_SIZE
	
#func _physics_process(delta: float) -> void:
	#print("posição do jogador:", $PlayerOldMan.global_position)
	#print("posição da primeira sala:", (rooms[0].position + rooms[0].size / 2) * CELL_SIZE)
