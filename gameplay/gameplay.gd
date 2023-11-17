extends Node2D

@onready var screensize = get_viewport_rect().size
@onready var enemies: Node2D = $Enemies
@onready var background: ColorRect = $Background
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

@export var enemy_scene: PackedScene

const BACKGROUND_HEIGHT := 2880 # TODO: get dynamically

func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_file(Global.SCENE_MAIN_MENU)
	
	# show vertical scroll as long as more background exists
	if abs(background.position.y) < (BACKGROUND_HEIGHT - screensize.y):
		background.position.y -= 1
	
	$UI/TimeRemaining.text = "Time Left: %d" % ceil($LevelTimer.time_left)
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")

func _pause() -> void:
	$Paused.pause()
	
	get_tree().paused = true


func _on_enemy_spawn_timer_timeout() -> void:
	var enemy: Enemy = enemy_scene.instantiate()
	var pos := Vector2(randi_range(128,256), 64)
	enemy.start(pos, Global.PathType.STRAIGHT)
	enemies.add_child(enemy)


func _on_player_player_health_changed(new_value: int) -> void:
	$UI/Health.text = "Health: %d" % new_value


func game_over():
	var root = get_tree().get_root().get_tree()
	root.change_scene_to_file(Global.SCENE_GAME_OVER)


func _on_level_timer_timeout() -> void:
	# TODO: Should be victory tho!
	game_over()
