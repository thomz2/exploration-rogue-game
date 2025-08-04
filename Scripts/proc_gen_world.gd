extends Node2D

@export var noise_texture : NoiseTexture2D
var noise : Noise

var width = 100
var height = 100

func _ready():
	noise = noise_texture.noise
	generate_world()
	
func generate_world():
	pass
