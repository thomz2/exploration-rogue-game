extends Node2D

@export var separation = 6

var leaves_res = [
	#preload("res://Resources/Environment/Leafables/leaf1.tres"),
	#preload("res://Resources/Environment/Leafables/leaf2.tres"),
	preload("res://Resources/Environment/Leafables/leaf3.tres"),
]

var leaf_node = preload("res://Environment/leafable.tscn")

var leaves_preset = [
	[0, 1, 1, 1, 0],
	[1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1],
	[0, 1, 1, 1, 0],
]

func _ready() -> void:
	var center_offset = Vector2(floor(leaves_preset.size() / 2), floor(leaves_preset.size() / 2))

	for y in range(leaves_preset.size()):
		for x in range(leaves_preset[y].size()):
			if leaves_preset[y][x] == 0:
				continue

			var leaf_inst = leaf_node.instantiate()
			leaf_inst.leafable_data = leaves_res[randi() % leaves_res.size()]
			leaf_inst.init()
			
			var offset = (Vector2(x, y) - center_offset) * separation
			leaf_inst.position = offset # posicionando de forma relativa ao nó pai
			leaf_inst.set_sprite_scale(Vector2(leaf_inst.scale_range.x, leaf_inst.scale_range.x))
			add_child(leaf_inst)
