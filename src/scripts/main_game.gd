class_name MainGame
extends Node

const MELT_RATE: float = 0.1

@onready var bar: Panel = $GUI/Bar
@onready var player: Player = $World/Player

var bar_ratio := 1.0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _ready() -> void:
	GameState.game_state = GameState.GAME_STATES.RUNNING


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


func _end_game() -> void:
	GameState.game_state = GameState.GAME_STATES.NOT_RUNNING
	player.die()
