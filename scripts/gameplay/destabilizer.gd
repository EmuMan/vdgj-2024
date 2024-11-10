extends Node2D


@export var player: Node2D


const DESTABILIZE_DURATION = 15 * 1000
const DESTABILIZE_COOLDOWN = 30 * 1000

var last_destabilize_time: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
