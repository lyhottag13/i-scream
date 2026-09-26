class_name Cactus
extends StaticBody2D

func _ready() -> void:
	set_height(randi_range(1, 3))


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
