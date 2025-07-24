extends Camera2D

var desired_offset : Vector2

func _process(delta: float):
	handle_aim()
	handle_zoom(delta)
	

func handle_aim():
	var player = get_parent().get_node("PlayerOldMan")
	
	var min_offset = -1 * player.range
	var max_offset = player.range
	
	desired_offset = (get_global_mouse_position() - position) * 0.5
	desired_offset.x = clamp(desired_offset.x, min_offset, max_offset)
	desired_offset.y = clamp(desired_offset.y, min_offset / 2.0, max_offset / 2.0)
	
	global_position = player.global_position + desired_offset
	
func handle_zoom(delta):
	var zoom_speed := 10
	var min_zoom := 0.1
	var max_zoom := 10.0
	
	if Input.is_action_pressed("scroll_down") or Input.is_action_just_released("scroll_down"):
		zoom *= Vector2(1 - zoom_speed * delta, 1 - zoom_speed * delta)
	elif Input.is_action_pressed("scroll_up") or Input.is_action_just_released("scroll_up"):
		zoom *= Vector2(1 + zoom_speed * delta, 1 + zoom_speed * delta)
		
	# Clampa o zoom (evita ficar muito pequeno ou gigante)
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = clamp(zoom.y, min_zoom, max_zoom)
