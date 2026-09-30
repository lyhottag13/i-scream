class_name MainGame
extends Node

const MELT_RATE: float = 0.1

@onready var bar: Panel = $GUI/Bar
@onready var player: Player = $World/Player
@onready var score_label: Label = %Score
@onready var score_timer: Timer = $ScoreTimer
@onready var level: Level = $World/Level
@onready var game_over: GameOver = $GUI/GameOver
@onready var tutorial: Label = $GUI/Tutorial

var bar_ratio := 1.0
var score := 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _ready() -> void:
	GameState.game_state = GameState.GAME_STATES.RUNNING
	_start_game()


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


func _start_game() -> void:
	GameState.game_state = GameState.GAME_STATES.RUNNING
	level.start_spawning()
	score_label.text = "Score: 0"
	score_timer.start()
	bar.show()
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
	#game_over.position.y = 0
	var tween = create_tween().tween_property(game_over, "position:y", 0, 1).set_trans(Tween.TRANS_CUBIC)


func _on_score_timer_timeout() -> void:
	score += 10
	score_label.text = "Score: " + str(score)


func _on_game_over_retry() -> void:
	get_tree().reload_current_scene()
