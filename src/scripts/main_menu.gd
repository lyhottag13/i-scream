class_name MainMenu
extends Control

signal start_game

@onready var texture_rect: TextureRect = $TextureRect
@onready var button: TextureButton = $Button

func _ready() -> void:
	_rotate_endlessly()


func _on_button_pressed() -> void:
	start_game.emit()


func _on_button_mouse_entered() -> void:
	AudioManager.play("chomp")
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).tween_property(button, "scale", Vector2(1.2, 1.2), 0.5)


func _on_button_mouse_exited() -> void:
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).tween_property(button, "scale", Vector2(1, 1), 0.5)


func _rotate_endlessly() -> void:
	var rotate = create_tween()
	rotate.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	rotate.tween_property(texture_rect, "rotation_degrees", 2, 1)
	await rotate.tween_property(texture_rect, "rotation_degrees", -2, 1).finished
	_rotate_endlessly()
