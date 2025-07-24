extends Node2D

@onready var tile_map_layer = $TileMapLayer

enum {FLOOR, WALL}

var floor_tile := Vector2i(2,7)
var up_wall_tile := Vector2i(1,6)
var down_wall_tile := Vector2i(2,10)
var right_wall_tile := Vector2i(15,7)
var left_wall_tile := Vector2i(0,9)

const WIDTH = 80 # Tamanho total do mapa
const HEIGHT = 80
const CELL_SIZE = 10
const MIN_ROOM_SIZE = 5
const MAX_ROOM_SIZE = 10
const MAX_ROOMS = 10

var grid = [] # matriz: 0 = chão, 1 = parede

var rooms = []

# Preenche com parede inicialmente
func initialize_grid():
	for x in range(WIDTH):
		grid.append([])
		for y in range(HEIGHT):
			grid[x].append(WALL)
			
# TODO: Entender melhor depois
func generate_room() -> Rect2:
	var w = randi() % 6 + 5  # entre 5 e 10
	var h = randi() % 6 + 5
	
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
	var start = room_a.position + room_a.size / 2
	var end = room_b.position + room_b.size / 2
	
	var x = int(start.x)
	var y = int(start.y)
	
	# Faz um caminho entre as duas salas, os caminhos podem ser:
	# - um corredor reto entre as salas
	# - um corredor que cria uma curva perpendicular entre as salas
	while x != int(end.x):
		x += 1 if end.x > x else -1
		grid[x][y] = FLOOR
		
	while y != int(end.y):
		y += 1 if end.y > y else -1
		grid[x][y] = FLOOR

	
func generate_dungeon():
	initialize_grid()
	for i in range(MAX_ROOMS):
		var room = generate_room()
		if place_room(room):
			if rooms.size() > 0:
				connect_rooms(rooms[-1], room)
			rooms.append(room)
			
func draw_dungeon():
	for x in range(WIDTH):
		for y in range(HEIGHT):
			var tile = Vector2i(x, y)
			if grid[x][y] == 0:
				tile_map_layer.set_cell(tile, 0, floor_tile)
			else:
				tile_map_layer.set_cell(tile, 0, up_wall_tile)

func _ready():
	randomize()
	generate_dungeon()
	draw_dungeon()
