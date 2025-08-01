extends Node2D

var next_anim : String
var leafable_data : LeafableData 
var scale_range : Vector2

func init():
	if leafable_data == null: return
	
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(leafable_data.region_xy, leafable_data.region_wh)
	$Sprite2D.offset = leafable_data.offset
	scale_range = leafable_data.scale_range

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
