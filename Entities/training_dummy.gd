extends CharacterBody2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	$AnimationPlayer.play("took_damage")
	pass # Replace with function body.
