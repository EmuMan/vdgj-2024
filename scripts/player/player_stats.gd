extends Node2D


@export var max_health: float = 100.0

var health := 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health

func on_death() -> void:
	print_debug("DEAD!!!! hehehaw, says larty")
	get_parent().queue_free()

func damage(hp: float) -> void:
	if health - hp <= 0.0:
		health = 0.0
		on_death()
	else:
		health -= hp
		print_debug("Damaged: ", health)

func heal(hp: float) -> void:
	health = min(health + hp, max_health)
	print_debug("Healed: ", health)
