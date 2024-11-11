extends Node2D

class_name PlayerStats

signal health_changed

@onready var hurt_audio_player = $HurtAudio
@onready var heal_audio_player = $HealAudio

@export var max_health: float = 100.0

var health := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	Util.enemies_killed = 0

func on_death() -> void:
	print_debug("DEAD!!!! hehehaw, says larty")
	get_tree().change_scene_to_file("res://levels/game_over.tscn")

func damage(hp: float) -> void:
	if health - hp <= 0.0:
		health = 0.0
		on_death()
	else:
		health -= hp
	health_changed.emit()
	hurt_audio_player.play()

func heal(hp: float) -> void:
	health = min(health + hp, max_health)
	health_changed.emit()
	heal_audio_player.play()
