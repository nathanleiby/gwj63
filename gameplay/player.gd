class_name Player
extends Area2D

@onready var screensize = get_viewport_rect().size
@export var speed: int = 500
@export var bullet_scene: PackedScene

# half of the ship size, actually
const SHIP_SIZE: int = 64
const HALF_SHIP_SIZE = SHIP_SIZE/2
const BULLET_SIZE: int = 32

func _process(delta: float) -> void:
	get_input(delta)

var lastFired: float = -1.0
@export var fireIntervalMs: int = 200
@export var health: int = 10

enum GunType { SINGLE, DOUBLE, TRIPLE }

@export var gun_type: GunType


func shoot():
	var now := Time.get_ticks_msec() 
	if lastFired < 0 or (now - lastFired) > fireIntervalMs:
		lastFired = now
		
		if gun_type == GunType.SINGLE:
			var b: Bullet = bullet_scene.instantiate()		
			b.start(position + Vector2(0, -HALF_SHIP_SIZE), "player")
			get_tree().root.add_child(b)
		elif gun_type == GunType.DOUBLE:
			var b: Bullet = bullet_scene.instantiate()		
			b.start(position + Vector2(-16, -HALF_SHIP_SIZE), "player")
			get_tree().root.add_child(b)
			var b2: Bullet = bullet_scene.instantiate()		
			b2.start(position + Vector2(16, -HALF_SHIP_SIZE), "player")
			get_tree().root.add_child(b2)
		elif gun_type == GunType.TRIPLE:
			var b: Bullet = bullet_scene.instantiate()		
			b.start(position + Vector2(-32, -HALF_SHIP_SIZE), "player")
			get_tree().root.add_child(b)
			var b2: Bullet = bullet_scene.instantiate()		
			b2.start(position + Vector2(0, -HALF_SHIP_SIZE), "player")
			get_tree().root.add_child(b2)
			var b3: Bullet = bullet_scene.instantiate()		
			b3.start(position + Vector2(32, -HALF_SHIP_SIZE), "player")
			get_tree().root.add_child(b3)
				
func get_input(delta: float) -> void:
	# move
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += input_direction * speed * delta
	const boundary := Vector2(HALF_SHIP_SIZE, HALF_SHIP_SIZE)
	position = position.clamp(boundary, screensize - boundary)
	
	if Input.is_action_pressed("shoot"):
		shoot()

func damage(amount: int):
	health -= amount
	# TODO: flash to indicate damage
	if health <= 0:
		explode()

func explode():
	# TODO: game over or lose life
	pass