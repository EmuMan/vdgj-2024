extends Node2D


@export var music_volume = -6.0

@onready var music_normal = $"Music Normal"
@onready var music_chaotic = $"Music Chaotic"


func _on_destabilizer_destabilize() -> void:
	music_normal.volume_db = -INF
	music_chaotic.volume_db = music_volume

func _on_destabilizer_stabilize() -> void:
	music_normal.volume_db = music_volume
	music_chaotic.volume_db = -INF
