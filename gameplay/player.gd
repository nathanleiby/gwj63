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

signal player_health_changed(new_value: int)

func shoot():
	var now := Time.get_ticks_msec() 
	if lastFired < 0 or (now - lastFired) > fireIntervalMs:
		lastFired = now
		
		var n := get_tree().root.get_node("Gameplay")
		if gun_type == GunType.SINGLE:
			var b: Bullet = bullet_scene.instantiate()		
			b.start(position + Vector2(0, -HALF_SHIP_SIZE), "player")
			n.add_child(b)
		elif gun_type == GunType.DOUBLE:
			var b: Bullet = bullet_scene.instantiate()		
			b.start(position + Vector2(-16, -HALF_SHIP_SIZE), "player")
			get_tree().root.add_child(b)
			var b2: Bullet = bullet_scene.instantiate()		
			b2.start(position + Vector2(16, -HALF_SHIP_SIZE), "player")
			n.add_child(b2)
		elif gun_type == GunType.TRIPLE:
			var b: Bullet = bullet_scene.instantiate()		
			b.start(position + Vector2(-32, -HALF_SHIP_SIZE), "player")
			n.add_child(b)
			var b2: Bullet = bullet_scene.instantiate()		
			b2.start(position + Vector2(0, -HALF_SHIP_SIZE), "player")
			n.add_child(b2)
			var b3: Bullet = bullet_scene.instantiate()		
			b3.start(position + Vector2(32, -HALF_SHIP_SIZE), "player")
			n.add_child(b3)
				
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
		health = 0
		game_over()
	
	emit_signal("player_health_changed", health)

func game_over():
	var root = get_tree().get_root().get_tree()
	root.change_scene_to_file(Global.SCENE_GAME_OVER)

	pass
