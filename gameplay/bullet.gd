class_name Bullet
extends Node2D


@export var speed := +250
var target: Vector2
var owner_type: String

func start(pos: Vector2, new_owner_type: String) -> void:
	position = pos
	owner_type = new_owner_type
	if owner_type == "player":
		speed = -250
	else:
		speed = 250
	
func _physics_process(delta: float) -> void:
	position.y += speed * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if owner_type == "player" and area.is_in_group("enemies"):
		area.damage(1)
		queue_free()
	elif owner_type != "player" and area.is_in_group("player"):
		area.damage(1)
		queue_free()
		
