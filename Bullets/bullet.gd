extends Node2D

var direction : Vector2
@onready var player = $/root/GameLevel/PlayerOldMan
@onready var bullet_speed = player.bullet_speed
@export var friction: float = 0.1  # 0 = sem atrito, 100 = atrito alto, nem se move

func _ready() -> void:
	scale.x = player.bullet_size
	scale.y = player.bullet_size
	$AnimationPlayer.play("appear")

func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var hit = $RayCast2D.get_collider()
		# TODO colocar aqui um if "acertou grupo inimigo" para tratar caso uma das colisões pertença ao grupo "inimigos"
		# - Além disso, uma boa seria colocar varios tipos de tratamento, para diferentes animações dependendo do que hitar por exemplo
		print("Acertou: ", hit.name)
		
		$AnimationPlayer.play("disappear")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.stop()
		queue_free()
		return
		
	global_position += direction * bullet_speed

	# Aplica desaceleração
	if friction > 0:
		# A lógica aqui é que a cada tempo que passa (delta = tempo de um frame), a velocidade diminui 
		bullet_speed = max(0, bullet_speed - friction * delta)
	if bullet_speed <= 0:
		queue_free()

#func _ready():
	#linear_velocity = direction * bullet_speed

func _on_timer_timeout() -> void:
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
