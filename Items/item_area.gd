extends Area2D

@export var item : Item

func _ready() -> void:
	$Sprite2D.texture = item.sprite

func init(item_res: Item) -> void:
	item = item_res
	update_visual()

func update_visual() -> void:
	$Sprite2D.texture = item.sprite

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.add_bullet_upgrade(item.upgrade)
		$AnimationPlayer.play("collect")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "collect":
		queue_free()
