class_name Bullet
extends Node2D

var direction : Vector2
var player 
var bullet_speed
@export var friction: float = 0.1  # 0 = sem atrito, 100 = atrito alto, nem se move
@export var damage: float = 3.5

func _ready() -> void:
	# Inicializando variaveis 
	player = get_tree().get_nodes_in_group("players")[0]
	bullet_speed = player.bullet_speed
	
	scale.x = player.bullet_size
	scale.y = player.bullet_size
	$AnimationPlayer.play("appear")

func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var hit = $RayCast2D.get_collider()
		# TODO colocar aqui um if "acertou grupo inimigo" para tratar caso uma das colisões pertença ao grupo "inimigos"
		# - Além disso, uma boa seria colocar varios tipos de tratamento, para diferentes animações dependendo do que hitar por exemplo
		#print("Acertou: ", hit.name)
		
		await hit_proccess()
		
		return
		
	global_position += direction * bullet_speed

	# Aplica desaceleração
	if friction > 0:
		# A lógica aqui é que a cada tempo que passa (delta = tempo de um frame), a velocidade diminui 
		bullet_speed = max(0, bullet_speed - friction * delta)
	if bullet_speed <= 0:
		queue_free()

func hit_proccess():
	$AnimationPlayer.play("disappear")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.stop()
	queue_free()

func _on_timer_timeout() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() in get_tree().get_nodes_in_group("enemies"):
		await hit_proccess()
