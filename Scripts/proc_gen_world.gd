#(0.4314, 0.1647, 0, 1), - marrom
#(0, 0.7765, 0, 1), - verde
#(1, 1, 0, 1), - amarelo
#(0, 0, 1, 1) - azul

extends Node2D

@export var noise_texture : NoiseTexture2D
var noise : FastNoiseLite
var noise_img : Image

var width = 400
var height = 400

var source_id = 0
var water = {
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
	"atlas": Vector2i(1, 0),
	"color": Color(1, 1, 0, 1).to_html(true)
}
var dirt = {
	"atlas": Vector2i(1, 0),
	"color": Color(0.4314, 0.1647, 0, 1).to_html(true)
}
var grass = {
	"atlas": Vector2i(1, 4),
	"color": Color(0, 0.7765, 0, 1).to_html(true),
	"secondary_tiles": [
		{
			"chance": 30, # 30%
			"atlas": {
				"tiles": [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2), Vector2i(1, 3)],
				"animation": false,
			}
		},
	],
}

func _ready():
	noise = noise_texture.noise
	noise.seed = 2 # ISSO DEFINE O MUNDO GERADO
	await noise_texture.changed
	noise_img = noise_texture.get_image()
	generate_world()
	
func generate_world():
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_pixel = noise_img.get_pixel(x + width/2, y + height/2).to_html(true)
			if noise_pixel.contains(dirt["color"]):
				$Dirt.set_cell(Vector2i(x, y), source_id, dirt["atlas"])
			elif noise_pixel.contains(water["color"]):
				$Water.set_cell(Vector2i(x, y), source_id, water["atlas"])
				if water["secondary_tiles"]:
					var rn = randi() % 100
					if rn < water["secondary_tiles"][0]["chance"]: 
						$Water.set_cell(Vector2i(x, y), source_id, water["secondary_tiles"][0]["atlas"]["tiles"][rn % water["secondary_tiles"][0]["atlas"]["tiles"].size()])
			elif noise_pixel.contains(grass["color"]):
				$Grass.set_cell(Vector2i(x, y), source_id, grass["atlas"])
				if grass["secondary_tiles"]:
					var rn = randi() % 100
					if rn < grass["secondary_tiles"][0]["chance"]: 
						$Grass.set_cell(Vector2i(x, y), source_id, grass["secondary_tiles"][0]["atlas"]["tiles"][rn % grass["secondary_tiles"][0]["atlas"]["tiles"].size()])
			else:
				$Sand.set_cell(Vector2i(x, y), source_id, sand["atlas"])
