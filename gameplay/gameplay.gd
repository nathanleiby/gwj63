extends Node2D

@onready var screensize = get_viewport_rect().size
@onready var background: ColorRect = $Background

const BACKGROUND_HEIGHT := 2880 # TODO: get dynamically

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file(Global.SCENE_MAIN_MENU)
	
	# show vertical scroll as long as more background exists
	if background.position.y < (BACKGROUND_HEIGHT - screensize.y):
		background.position.y -= 1

	# TODO: spawn enemies periodically
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")

func _pause() -> void:
	$Paused.pause()
	
	get_tree().paused = true
