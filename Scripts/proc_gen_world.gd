#(0.4314, 0.1647, 0, 1), - marrom
#(0, 0.7765, 0, 1), - verde
#(1, 1, 0, 1), - amarelo
#(0, 0, 1, 1) - azul

extends Node2D

@export var noise_texture : NoiseTexture2D
var noise : FastNoiseLite
var noise_img : Image

# width x height
var world_tiles_representation_matrix = []

var SEED = 2

var width = 400
var height = 400

var source_id = 0
var water = {
	"name": "water",
	"atlas": Vector2i(2, 0),
	"color": Color(0, 0, 1, 1).to_html(true),
	"secondary_tiles": [
		{
			"chance": 2, # 2%
			"atlas": {
				"tiles": [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)],
				"animation": true
			}
		}
	]
}
var sand = {
	"name": "sand",
	"atlas": Vector2i(1, 0),
	"color": Color(1, 1, 0, 1).to_html(true)
}
var dirt = {
	"name": "dirt",
	"atlas": Vector2i(1, 0),
	"color": Color(0.4314, 0.1647, 0, 1).to_html(true)
}
var grass = {
	"name": "grass",
	"atlas": Vector2i(1, 4),
	"color": Color(0, 0.7765, 0, 1).to_html(true),
	"secondary_tiles": [
		{
			"chance": 5, # 30%
			"atlas": {
				"tiles": [Vector2i(1, 1)],
				"animation": false,
			}
		},
		{
			"chance": 10,
			"atlas": {
				"tiles": [Vector2i(1, 7)],
				"animation": false,
			}
		},
		{
			"chance": 7,
			"atlas": {
				"tiles": [Vector2i(1, 8)],
				"animation": false,
			}
		},
	],
}

var current_tile = "none"

func _ready():
	noise = noise_texture.noise
	noise.seed = SEED # ISSO DEFINE O MUNDO GERADO
	seed(SEED)
	await noise_texture.changed
	noise_img = noise_texture.get_image()
	generate_world()
	
func set_tile(layer: TileMapLayer, pos: Vector2i, source_id: int, tile_data: Dictionary):
	current_tile = tile_data["name"]
	layer.set_cell(pos, source_id, tile_data["atlas"])
	
	if "secondary_tiles" in tile_data:
		var rn = randi() % 100
		var acc = 0
		for sec_actual_tile in tile_data["secondary_tiles"]:
			acc += sec_actual_tile["chance"]
			if acc > rn:
				var tiles = sec_actual_tile["atlas"]["tiles"]
				layer.set_cell(pos, source_id, tiles[rn % tiles.size()])
				break

# Esse código gera os tiles
func generate_world():
	var OFFSET = Vector2i(int(width/2), int(height/2))
	for x in range(-OFFSET.x, OFFSET.x):
		world_tiles_representation_matrix.append([])
		for y in range(-OFFSET.y, OFFSET.y):
			# x + OFFSET.x = 0 até width
			current_tile = "none"
			
			var position = Vector2i(x, y)
			var noise_pixel = noise_img.get_pixel(x + OFFSET.x, y + OFFSET.y).to_html(true)
			
			if noise_pixel.contains(dirt["color"]):    set_tile($Dirt, position, source_id, dirt)
			elif noise_pixel.contains(water["color"]): set_tile($Water, position, source_id, water)
			elif noise_pixel.contains(grass["color"]): set_tile($Grass, position, source_id, grass)
			elif noise_pixel.contains(sand["color"]):  set_tile($Dirt, position, source_id, dirt)
			
			world_tiles_representation_matrix[x + OFFSET.x].append(current_tile)

func place_decorations_arround_world():
	pass
