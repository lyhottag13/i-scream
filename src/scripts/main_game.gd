class_name MainGame
extends Node

const MELT_RATE: float = 0.1
const PLAYER = preload("uid://bu8cjok6o02rb")

@onready var bar: Panel = $GUI/Bar
@onready var player: Player = $World/Player
@onready var score_label: Label = %Score
@onready var score_timer: Timer = $ScoreTimer
@onready var level: Level = $World/Level
@onready var game_over: GameOver = $GUI/GameOver
@onready var tutorial: Label = $GUI/Tutorial
@onready var main_menu: MainMenu = $GUI/MainMenu
@onready var player_spawner: Marker2D = $World/PlayerSpawner
@onready var world: Node2D = $World

var bar_ratio := 1.0
var score := 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _process(delta: float) -> void:
	match GameState.game_state:
		GameState.GAME_STATES.RUNNING:
			bar_ratio -= (MELT_RATE * delta)
			bar.set_bar(bar_ratio)
			if bar_ratio <= 0:
				_end_game()


func _on_player_hit() -> void:
	bar_ratio -= 0.2


func _on_level_collected() -> void:
	bar_ratio = min(1.0, bar_ratio + 0.3)


var game_over_tween: Tween

func _start_game() -> void:
	GameState.game_state = GameState.GAME_STATES.RUNNING
	if game_over_tween:
		game_over_tween.kill()
	game_over.position.y = -320
	game_over.hide()
	main_menu.hide()
	level.start_spawning()
	level.start_scroll()
	level.restart_values()
	score = 0
	score_label.text = "Score: 0"
	score_timer.start()
	bar.show()
	bar_ratio = 1
	score_label.show()
	tutorial.position.x = 500
	create_tween().tween_property(tutorial, "position:x", -300, 3).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_CUBIC)


func _end_game() -> void:
	GameState.game_state = GameState.GAME_STATES.NOT_RUNNING
	game_over.set_score(score)
	level.stop_spawning()
	score_timer.stop()
	player.die()
	bar.hide()
	await get_tree().create_timer(1.0).timeout
	game_over.show()
	level.slow_scroll()
	game_over_tween = create_tween()
	game_over_tween.tween_property(game_over, "position:y", 0, 1).set_trans(Tween.TRANS_CUBIC)


func _on_score_timer_timeout() -> void:
	score += 10
	score_label.text = "Score: " + str(score)


func _on_game_over_retry() -> void:
	var new_player = PLAYER.instantiate()
	new_player.position = player_spawner.position
	player = new_player
	player.hit.connect(_on_player_hit)
	world.add_child(new_player)
	_start_game()


func _on_main_menu_start_game() -> void:
	_start_game()
