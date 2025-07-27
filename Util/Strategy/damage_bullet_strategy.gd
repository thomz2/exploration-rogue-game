class_name DamageBulletStrategy
extends BaseBulletStrategy

var damage_increase := 10.0

func apply_upgrade(bullet : Bullet, root : Window = null):
	bullet.damage += damage_increase
