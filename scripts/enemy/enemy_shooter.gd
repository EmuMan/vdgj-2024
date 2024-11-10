extends Node2D

@export var target: Node2D

const shooting_cooldown: int = 2000

var last_shoot_action_time: int = 0

const bullet_scene := preload("res://scenes/enemy/enemy_bullet.tscn")


func _physics_process(delta: float) -> void:
	var now = Time.get_ticks_msec()
	
	if now < last_shoot_action_time + shooting_cooldown:
		return

	if is_instance_valid(target):
		var displacement := target.global_position - global_position
		shoot(displacement.angle())

func shoot(direction: float) -> void:
	last_shoot_action_time = Time.get_ticks_msec()
	var bullet_instance := bullet_scene.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.rotation = direction
	get_tree().root.add_child(bullet_instance)
