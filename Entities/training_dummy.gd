extends CharacterBody2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	$AnimationPlayer.stop() # Oh yeah
	$AnimationPlayer.play("took_damage")
