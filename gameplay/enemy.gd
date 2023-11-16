extends Area2D

@export var bullet_scene: PackedScene

signal died(points: int)
var speed: int = 150
@export var health: int = 5

var lastFired: float = -1.0
@export var fireIntervalMs: int = 1000

const SHIP_SIZE: int = 64
const HALF_SHIP_SIZE = SHIP_SIZE/2


func shoot():
	var now := Time.get_ticks_msec() 
	if lastFired < 0 or (now - lastFired) > fireIntervalMs:
		lastFired = now
		var b: Bullet = bullet_scene.instantiate()		
		b.start(position + Vector2(0, -HALF_SHIP_SIZE), "enemy")
		get_tree().root.add_child(b)
				

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	# move
	# TODO
	
	# shoot
	shoot()

func damage(amount: int):
	health -= amount
	# TODO: flash to indicate damage
	if health <= 0:
		explode()
		
func explode():
	speed = 0
	died.emit(5)
	queue_free()
