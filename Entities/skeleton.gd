extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("players")[0]
@onready var animation_player = $AnimationPlayer
var saw_player = false

func _physics_process(delta: float) -> void:
	
	$Sprite2D.flip_h = player.global_position.x > global_position.x
	
	var distance = global_position.distance_to(player.global_position)
	if distance < 32 || saw_player:
		saw_player = true
		animation_player.play("walk")
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * 50
	else:
		animation_player.stop()
		velocity = Vector2.ZERO
		
	if distance > 50:
		saw_player = false
		
	var collision = move_and_collide(velocity * delta)
	
