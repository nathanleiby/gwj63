extends Area2D


signal died(points: int)
var speed: int = 150

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func explode():
	speed = 0
	died.emit(5)
	queue_free()
