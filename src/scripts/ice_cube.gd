class_name IceCube
extends Area2D

signal collected

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		collected.emit()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
