class_name TripleshotBulletStrategy
extends BaseBulletStrategy

func apply_upgrade(bullet : Bullet, root : Window = null):
	var spread_angle = 15

	for offset in [-spread_angle, spread_angle]:
		var new_bullet = bullet.duplicate()
		
		new_bullet.direction = bullet.direction.rotated(deg_to_rad(offset)).normalized()
		new_bullet.global_position = bullet.global_position
		new_bullet.rotation = new_bullet.direction.angle()
		
		root.add_child(new_bullet)
