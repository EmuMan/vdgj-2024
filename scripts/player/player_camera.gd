extends Camera2D


@export var player: Node2D

const MAX_DISPLACEMENT = Vector2(300., 200.)
const MOVEMENT_RATE = 0.1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var target_position := player.global_position if is_instance_valid(player) else Vector2(0., 0.)
	
	var min_position = target_position - MAX_DISPLACEMENT
	var max_position = target_position + MAX_DISPLACEMENT
	var clamped_position := global_position.clamp(min_position, max_position)
	if global_position != clamped_position:
		global_position = clamped_position
		return
	
	var distance := global_position.distance_to(target_position)
	global_position = global_position.move_toward(target_position, distance * MOVEMENT_RATE)
