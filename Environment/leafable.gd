extends Node2D

var next_anim : String
var leafable_data : LeafableData 
var scale_range : Vector2

func set_sprite_scale(scale_vec : Vector2):
	$Sprite2D.scale = scale_vec

func init():
	if leafable_data == null: return
	
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(leafable_data.region_xy, leafable_data.region_wh)
	$Sprite2D.offset = leafable_data.offset
	scale_range = leafable_data.scale_range

func _physics_process(delta: float) -> void:
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("idle", 0.2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	var body_dir = (self.global_position - body.global_position).normalized()
	if body_dir.x <= 0:
		$AnimationPlayer.play("left_rotation", 0.2)
		next_anim = "left_disrotation"
	else:
		$AnimationPlayer.play("right_rotation", 0.2)
		next_anim = "right_disrotation"

func _on_area_2d_body_exited(body: Node2D) -> void:
	$AnimationPlayer.play(next_anim, 0.2)
