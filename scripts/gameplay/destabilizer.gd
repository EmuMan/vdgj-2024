extends Node2D

class_name Destabilizer

signal destabilize
signal stabilize


@export var player: CharacterBody2D

enum DestabilizationType {
	PLAYER_REVERSE_GRAVITY,
	PLAYER_NO_FRICTION,
	PLAYER_BOUNCY,
	PLAYER_SPEED_INCREASE,
	PLAYER_JUMP_HEIGHT_INCREASE,
	PLAYER_ATTACK_SIZE_INCREASE
}


const DESTABILIZE_DURATION = 10 * 1000
const DESTABILIZE_COOLDOWN = 20 * 1000

var last_destabilize_time: int = -DESTABILIZE_DURATION
var destabilizations: Array[DestabilizationType] = []
var old_values: Array = []
var destabilized: bool = false
var penis = "chode"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	var now := Time.get_ticks_msec()
	
	if destabilized and now > last_destabilize_time + DESTABILIZE_DURATION:
		on_stabilize()
	
	if not destabilized and now > last_destabilize_time + DESTABILIZE_COOLDOWN:
		on_destabilize(1)
		last_destabilize_time = now

func on_destabilize(count: int) -> void:
	destabilize.emit()
	destabilized = true
	for i in range(count):
		var new_destabilization = DestabilizationType.values().pick_random()
		if new_destabilization not in destabilizations:
			destabilizations.append(new_destabilization)
			var old_value = null
			match new_destabilization:
				DestabilizationType.PLAYER_REVERSE_GRAVITY:
					old_value = [player.gravity_modifier, player.jump_velocity, player.jump_accel]
					player.gravity_modifier = -1.0
					player.jump_velocity *= -1
					player.jump_accel *= -1
				DestabilizationType.PLAYER_NO_FRICTION:
					old_value = [player.h_accel, player.h_deaccel]
					player.h_accel *= 0.3
					player.h_deaccel = 0.0
				DestabilizationType.PLAYER_BOUNCY:
					pass
				DestabilizationType.PLAYER_SPEED_INCREASE:
					old_value = player.h_max_speed
					player.h_max_speed *= 5
				DestabilizationType.PLAYER_JUMP_HEIGHT_INCREASE:
					old_value = [player.jump_velocity, player.jump_accel]
					player.jump_velocity *= 5
					player.jump_accel *= 5
				DestabilizationType.PLAYER_ATTACK_SIZE_INCREASE:
					pass
			destabilizations.append(new_destabilization)
			old_values.append(old_value)

func on_stabilize() -> void:
	stabilize.emit()
	destabilized = false
	for i in range(mini(len(destabilizations), len(old_values))):
		var old_value = old_values[i]
		match destabilizations[i]:
			DestabilizationType.PLAYER_REVERSE_GRAVITY:
				player.gravity_modifier = old_value[0]
				player.jump_velocity = old_value[1]
				player.jump_accel = old_value[2]
			DestabilizationType.PLAYER_NO_FRICTION:
				player.h_accel = old_value[0]
				player.h_deaccel = old_value[1]
			DestabilizationType.PLAYER_BOUNCY:
				pass
			DestabilizationType.PLAYER_SPEED_INCREASE:
				player.h_max_speed = old_value
			DestabilizationType.PLAYER_JUMP_HEIGHT_INCREASE:
				player.jump_velocity = old_value[0]
				player.jump_accel = old_value[1]
			DestabilizationType.PLAYER_ATTACK_SIZE_INCREASE:
				pass

	destabilizations = []
	old_values = []
