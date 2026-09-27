extends Node2D

signal collected

const CACTUS = preload("uid://c44a4nntknj6q")
const ICE_CUBE = preload("uid://dk5f5sj4fo8a1")

var speed = 100
var cactus_timer_minimum = 2
var ice_cube_timer_minimum = 1

@onready var spawn_marker: Marker2D = %SpawnMarker
@onready var cactus_timer: Timer = %CactusTimer
@onready var ice_cube_timer: Timer = %IceCubeTimer

var objects: Array[Node2D] = []

func _ready() -> void:
	cactus_timer.start(randf_range(1, 3))
	ice_cube_timer.start(randf_range(1, 3))


func _physics_process(delta: float) -> void:
	if GameState.game_state == GameState.GAME_STATES.RUNNING:
		for object: Node2D in get_tree().get_nodes_in_group("moving_objects"):
			object.position.x -= delta * speed
		speed += delta * 2
		cactus_timer_minimum -= delta * 0.05


func _on_cactus_timer_timeout() -> void:
	var new_cactus = CACTUS.instantiate() as Cactus
	new_cactus.position = spawn_marker.position
	objects.append(new_cactus)
	add_child(new_cactus)
	cactus_timer.start(randf_range(cactus_timer_minimum, cactus_timer_minimum + 2))


func _on_ice_cube_timer_timeout() -> void:
	var new_ice_cube = ICE_CUBE.instantiate() as IceCube
	new_ice_cube.collected.connect(_on_ice_cube_collected)
	new_ice_cube.position = spawn_marker.position + Vector2(0, -100)
	add_child(new_ice_cube)
	ice_cube_timer.start(randf_range(ice_cube_timer_minimum, ice_cube_timer_minimum + 1))


func _on_ice_cube_collected() -> void:
	collected.emit()
