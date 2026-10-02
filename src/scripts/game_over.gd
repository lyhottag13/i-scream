class_name GameOver
extends Panel

signal retry

@onready var score_text: Label = $ScoreText
@onready var texture_button: TextureButton = $TextureButton

func _on_button_pressed() -> void:
	retry.emit()


func set_score(score: int) -> void:
	score_text.text = "Final Score: " + str(score) 


func _on_texture_button_mouse_entered() -> void:
	AudioManager.play("chomp")
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).tween_property(texture_button, "scale", Vector2(1.2, 1.2), 0.5)


func _on_texture_button_mouse_exited() -> void:
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).tween_property(texture_button, "scale", Vector2(1, 1), 0.5)
