extends Node2D


@onready var shoot_audio_player = $ShootAudio

const shooting_cooldown: int = 300

var last_shoot_action_time: int = 0

const bullet_scene := preload("res://scenes/player/player_bullet.tscn")


func _physics_process(delta: float) -> void:
	var now = Time.get_ticks_msec()
	
	if now < last_shoot_action_time + shooting_cooldown:
		return
	
	if Input.is_action_just_pressed("shoot"):
		var mouse_pos := get_global_mouse_position()
		var displacement := mouse_pos - global_position
		shoot(displacement.angle())

func shoot(direction: float) -> void:
	last_shoot_action_time = Time.get_ticks_msec()
	var bullet_instance := bullet_scene.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.rotation = direction
	get_tree().root.add_child(bullet_instance)
	shoot_audio_player.play()
