extends Node

@onready var hit: AudioStreamPlayer = $Hit
@onready var chomp: AudioStreamPlayer = $Chomp
@onready var scream: AudioStreamPlayer = $Scream
@onready var ice_collect: AudioStreamPlayer = $IceCollect
@onready var jump: AudioStreamPlayer = $Jump


func play(sfx_name: String) -> void:
	match sfx_name:
		"hit": hit.play()
		"chomp": chomp.play()
		"scream": scream.play()
		"ice_collect": ice_collect.play()
		"jump": jump.play()
