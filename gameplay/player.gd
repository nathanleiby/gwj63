class_name Player
extends Area2D

@onready var screensize = get_viewport_rect().size
@export var speed: int = 500
@export var bullet_scene: PackedScene

# half of the ship size, actually
const SHIP_SIZE: int = 64
const BULLET_SIZE: int = 32

func _process(delta: float) -> void:
	get_input(delta)

var lastFired: float = -1.0
@export var fireIntervalMs: int = 200

func shoot():
	var now := Time.get_ticks_msec() 
	if lastFired < 0 or (now - lastFired) > fireIntervalMs:
		lastFired = now
		var b: Bullet = bullet_scene.instantiate()		
		b.start(position + Vector2(0, -SHIP_SIZE))
		get_tree().root.add_child(b)
				
func get_input(delta: float) -> void:
	# move
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += input_direction * speed * delta
	position = position.clamp(Vector2(SHIP_SIZE, SHIP_SIZE), screensize - Vector2(SHIP_SIZE, SHIP_SIZE))
	
	if Input.is_action_pressed("shoot"):
		shoot()
