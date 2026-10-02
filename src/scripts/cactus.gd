class_name Cactus
extends StaticBody2D

@onready var cactus_1: Sprite2D = $Cactus1
@onready var cactus_2: Sprite2D = $Cactus2
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	var is_easy_cactus = randi_range(1, 10) <= 8
	var current_cactus = cactus_1 if is_easy_cactus else cactus_2
	current_cactus.visible = true
	current_cactus.flip_h = randi_range(0, 1)
	
	if !is_easy_cactus:
		(collision_shape_2d.shape as CapsuleShape2D).height = 90
		collision_shape_2d.position.y = -45

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
