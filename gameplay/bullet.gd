class_name Bullet
extends Node2D


@export var speed := -250
var target: Vector2

func start(pos: Vector2) -> void:
	position = pos
	
func _physics_process(delta: float) -> void:
	#if not target:
	#	return
	
	position.y += speed * delta
	



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		area.explode()
		queue_free()
