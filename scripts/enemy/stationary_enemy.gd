extends RigidBody2D


@export var target: Node2D

@onready var shooter := $EnemyShooter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shooter.target = target
