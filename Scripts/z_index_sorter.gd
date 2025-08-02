extends Node2D

#var max_z_index := 0 # Ta dando 2, por causa da arma
#var min_z_index := 1
#var player : Node2D
#var sortables
#
#func _ready():
	#player = get_tree().get_nodes_in_group("players")[0]
#
#func _physics_process(delta: float) -> void:
	#sortables = get_tree().get_nodes_in_group("sortables")
	#sortables.append(player.get_node("Sprite2D"))
	#sortables.append(player.get_node("Pistol"))
	#sortables.sort_custom(
		#func(a, b): 
			#return a.global_position.y < b.global_position.y
	#)
	#for i in sortables.size():
		#sortables[i].z_index = i + min_z_index
	#
	## Para debug
	#if Input.is_action_just_pressed("debug"):
		#print("CADE DESGRAÇA")
		#for e in sortables:
			#print(e, " possui z-index = ", e.z_index)
