extends CharacterBody2D

@export var ghost_node : PackedScene 
@onready var ghost_timer = $GhostTimer
@onready var dash_particles = $DashParticles
@onready var gun = $Pistol

# variaveis de atributo do jogador
@export var max_hp : int = 3
@export var move_speed : float = 100
@export var acceleration : float = 800
@export var range : float = 15
@export var bullet_speed : float = 2
@export var bullet_size : float = 1.3 # É o valor de scale da scene bullet
@export var dash_speed : float = 325
@export var dash_duration : float = 0.2
@export var dash_cooldown : float = 0.5

@onready var animation_player = $AnimationPlayer

# variaveis auxiliares
var is_dashing : bool = false
var last_input_dir : Vector2 = Vector2(1.0, 0.0)

# essas aqui vão apenas pegar os valores das variaveis de atributo definidas acima
var dash_timer : float = 0.0
var dash_cooldown_timer : float = 0.0
var actual_hp : int = 3

# Upgrades na bala do jogador
var bullet_upgrades : Array[BaseBulletStrategy] = [
	#DamageBulletStrategy.new(),
	#TripleshotBulletStrategy.new()
]

func _ready():
	#print("posição da arma: ", $Pistol.global_position.y)
	#print("posição do sprite: ", $Sprite2D.global_position.y)
	pass

# underscore in godot is equal to "unused"
# delta é o intervalo de tempo entre o frame anterior e o atual.
func _physics_process(delta: float) -> void:
	
	# isso aqui lida com a posição espelhada do sprite de acordo com a posição da mira (mouse)
	$Sprite2D.flip_h = get_global_mouse_position().x < global_position.x
	
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			dash_particles.emitting = false
			ghost_timer.stop()
			
	
	attack_handler()
	
	var input_dir = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")  
	)
	
	if !input_dir.is_zero_approx():
		last_input_dir = input_dir.normalized()
	
	dash_handler()
	
	if input_dir != Vector2.ZERO:
		# interpolando a velocidade suavemente
		# Aproxime a velocity do valor target, a uma velocidade máxima de acceleration * delta por frame.
		velocity = velocity.move_toward(last_input_dir * move_speed, acceleration * delta)
	else:
		# desaceleração suave até parar
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
		
	if velocity.is_zero_approx():
		animation_player.play("idle")
		rotation_degrees = 0
	elif !is_dashing:
		animation_player.play("walk")

	move_and_slide()

func attack_handler():
	if Input.is_action_just_pressed("attack"):
		gun.fire()

func dash_handler():
	if !Input.is_action_just_pressed("dash") or is_dashing or dash_cooldown_timer > 0:
		return
		
	var dash_direction = last_input_dir
	velocity = dash_direction * dash_speed
	ghost_timer.start()
	animation_player.play("dash")
	dash_particles.emitting = true
	is_dashing = true
	dash_timer = dash_duration
	dash_cooldown_timer = dash_cooldown

# TODO dar uma lida melhor nesse código e entender
func add_ghost():
	pass
	#var ghost = ghost_node.instantiate()
	#var sprite = $Sprite2D
#
	#var atlas = AtlasTexture.new()
	#atlas.atlas = sprite.texture
#
	#var frame_size = sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)
	#var frame_coords = Vector2(sprite.frame % sprite.hframes, sprite.frame / sprite.hframes)
	#atlas.region = Rect2(frame_coords * frame_size, frame_size)
#
	#ghost.texture = atlas
	#ghost.global_position = sprite.global_position
	#ghost.scale = scale
	#ghost.flip_h = sprite.flip_h
	#ghost.flip_v = sprite.flip_v
#
	## TODO ajeitar depois a porra do y-sort desse fantasma
	#get_tree().current_scene.add_child(ghost)

func add_bullet_upgrade(upgrade : BaseBulletStrategy):
	bullet_upgrades.append(upgrade)

func _on_ghost_timer_timeout() -> void:
	add_ghost()
