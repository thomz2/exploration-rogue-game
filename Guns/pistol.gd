extends Node2D

@onready var muzzle = $Marker2D
@export var bullet_scene = preload("res://Bullets/bullet.tscn")

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
	# O wrap serve para limitar o valor da rotação, visto que se 
	# rodarmos muitas vezes, o valor pode ser maior que 360
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	
	# Para entender o if basta rodar a arma e ver que nesse intervalo seria melhor inverter o sprite
	if rotation_degrees > 90 and rotation_degrees < 270:
		# Deixa o sprite de cabeça para baixo
		scale.y = -1
	else:
		scale.y = 1

func fire():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	bullet.rotation = bullet.direction.angle()
	
	get_tree().root.add_child(bullet)
