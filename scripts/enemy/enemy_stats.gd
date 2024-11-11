extends Node2D

@export var max_health: float = 100.0

@onready var health_bar = $"../HealthBar"

var health := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	health_bar.visible = false

func on_death() -> void:
	print_debug("lary kiled B)")
	Util.enemies_killed += 1
	get_parent().queue_free()

func damage(hp: float) -> void:
	if health - hp <= 0.0:
		health = 0.0
		on_death()
	else:
		health -= hp
	health_bar.visible = true
	health_bar.scale.x = health / max_health

func heal(hp: float) -> void:
	health = min(health + hp, max_health)
	health_bar.visible = true
	health_bar.scale.x = health / max_health
