extends Node2D

var next_anim : String

func _on_area_2d_body_entered(body: Node2D) -> void:
	var body_dir = (self.global_position - body.global_position).normalized()
	if body_dir.x <= 0:
		$AnimationPlayer.play("left_rotation")
		next_anim = "left_disrotation"
	else:
		$AnimationPlayer.play("right_rotation")
		next_anim = "right_disrotation"

func _on_area_2d_body_exited(body: Node2D) -> void:
	$AnimationPlayer.play(next_anim)
