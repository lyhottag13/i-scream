extends Control

@onready var blue_bar: NinePatchRect = $Bar/BlueBar

func set_bar(ratio: float) -> void:
	blue_bar.size.y = ratio * 133
	blue_bar.position.y = 3 + (133 * (1 - ratio))
