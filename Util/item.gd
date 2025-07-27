class_name Item
extends Resource

@export var item_name : String
@export var description : String
@export var sprite : Texture2D = AtlasTexture.new()
@export var upgrade : BaseBulletStrategy # TODO por enquanto está como melhoria de bullet, mas pode ser qualquer coisa

func _to_string() -> String:
	return item_name
