extends Node2D

var max_z_index := 0 # Ta dando 2, por causa da arma
var player : Node2D

func _ready():
	player = get_tree().get_nodes_in_group("players")[0]
	for node in player.get_children(true):
		if node is CanvasItem:
			max_z_index = max(max_z_index, node.z_index)

func _physics_process(delta: float) -> void:
	var sortables = get_tree().get_nodes_in_group("sortable")
	for entity in sortables:
		if entity.global_position.y > player.global_position.y:
			entity.z_index = max_z_index + 1
		else:
			entity.z_index = 0
