class_name MainMenu
extends Control

signal start_game

func _on_button_pressed() -> void:
	start_game.emit()


func _on_button_mouse_entered() -> void:
	AudioManager.play("chomp")
