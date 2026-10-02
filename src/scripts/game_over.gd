class_name GameOver
extends Panel

signal retry

@onready var score_text: Label = $ScoreText

func _on_button_pressed() -> void:
	retry.emit()


func set_score(score: int) -> void:
	score_text.text = "Final Score: " + str(score) 


func _on_texture_button_mouse_entered() -> void:
	AudioManager.play("chomp")
