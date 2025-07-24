extends CharacterBody2D

@export var move_speed : float = 100
@export var acceleration : float = 800
@export var range : float = 15
@export var bullet_speed : float = 2

var bullet_scene = preload("res://Bullets/bullet.tscn")

@onready var animation_tree = $AnimationTree

# posso usar isso depois para fazer uma animação de idle
#func _ready() -> void:
	#animation_tree.set("parameters/Walk/blend_position", )

# underscore in godot is equal to "unused"
# delta é o intervalo de tempo entre o frame anterior e o atual.
func _physics_process(delta: float) -> void:
	attack_handler()
	
	var input_dir = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")  
	)
	
	update_animation_parameters(input_dir)
	
	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		# interpolando a velocidade suavemente
		# Aproxime a velocity do valor target, a uma velocidade máxima de acceleration * delta por frame.
		velocity = velocity.move_toward(input_dir * move_speed, acceleration * delta)
	else:
		# desaceleração suave até parar
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)

	move_and_slide()

func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		
func attack_handler():
	if Input.is_action_just_pressed("attack"):
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = (get_global_mouse_position() - global_position).normalized()
		
		$/root/GameLevel.add_child(bullet)
