class_name Level
extends Node2D

signal collected

const CACTUS = preload("uid://c44a4nntknj6q")
const ICE_CUBE = preload("uid://dk5f5sj4fo8a1")

const BASELINE_SPEED = 100
const BASELINE_CACTUS_TIME = 2
const BASELINE_ICE_CUBE_TIME = 1
const MINIMUM_CACTUS_TIME = 0.2
const MAXIMUM_ICE_CUBE_TIME = 2

var speed = BASELINE_SPEED
var cactus_time = BASELINE_CACTUS_TIME
var ice_cube_time = BASELINE_ICE_CUBE_TIME

@onready var spawn_marker: Marker2D = %SpawnMarker
@onready var cactus_timer: Timer = %CactusTimer
@onready var ice_cube_timer: Timer = %IceCubeTimer
@onready var backgrounds: Node2D = $Backgrounds

var tweens: Array[Tween] = []

func _physics_process(delta: float) -> void:
	for object: Node2D in get_tree().get_nodes_in_group("moving_objects"):
		object.position.x -= delta * speed
	if GameState.game_state == GameState.GAME_STATES.RUNNING:
		speed += delta * 2
		cactus_time = max(cactus_time - delta * 0.04, MINIMUM_CACTUS_TIME)
		ice_cube_time = min(ice_cube_time + delta * 0.02, MAXIMUM_ICE_CUBE_TIME)


func _on_cactus_timer_timeout() -> void:
	var new_cactus = CACTUS.instantiate() as Cactus
	new_cactus.position = spawn_marker.position
	add_child(new_cactus)
	cactus_timer.start(randf_range(cactus_time, 2 * cactus_time + 1))


func _on_ice_cube_timer_timeout() -> void:
	var new_ice_cube = ICE_CUBE.instantiate() as IceCube
	new_ice_cube.collected.connect(_on_ice_cube_collected)
	new_ice_cube.position = spawn_marker.position + Vector2(0, randi_range(-50, -150))
	add_child(new_ice_cube)
	ice_cube_timer.start(randf_range(ice_cube_time, ice_cube_time + 1))


func _on_ice_cube_collected() -> void:
	collected.emit()


func start_spawning() -> void:
	cactus_timer.start(randf_range(1, 3))
	ice_cube_timer.start(randf_range(1, 3))


func stop_spawning() -> void:
	cactus_timer.stop()
	ice_cube_timer.stop()


func start_scroll() -> void:
	for tween in tweens:
		tween.kill()
	var scroll_values: Array[int] = [
		-20,
		-30,
		-40,
		-60,
		-100,
	]
	var parallaxLayers = backgrounds.get_children()
	for item in parallaxLayers:
		if item is Parallax2D:
			item.autoscroll.x = scroll_values.pop_front()


func end_scroll() -> void:
	var parallaxLayers = backgrounds.get_children()
	for item in parallaxLayers:
		if item is Parallax2D:
			item.autoscroll.x = 0


func slow_scroll() -> void:
	var parallaxLayers = backgrounds.get_children()
	for item in parallaxLayers:
		if item is Parallax2D:
			var new_tween = create_tween()
			new_tween.tween_property(item, "autoscroll:x", 0, 2)
			tweens.append(new_tween)


func restart_values() -> void:
	speed = BASELINE_SPEED
	cactus_time = BASELINE_CACTUS_TIME
