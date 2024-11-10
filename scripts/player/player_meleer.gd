extends Node2D


const melee_cooldown: int = 200

var last_melee_action_time: int = 0

const melee_scene := preload("res://scenes/player/player_melee.tscn")


func _physics_process(delta: float) -> void:
	var now = Time.get_ticks_msec()
	
	if now < last_melee_action_time + melee_cooldown:
		return
	
	if Input.is_action_just_pressed("melee"):
		var mouse_pos := get_global_mouse_position()
		var displacement := mouse_pos - global_position
		melee(displacement.angle())

func melee(direction: float) -> void:
	last_melee_action_time = Time.get_ticks_msec()
	var melee_instance := melee_scene.instantiate()
	melee_instance.rotation = direction
	add_child(melee_instance)
