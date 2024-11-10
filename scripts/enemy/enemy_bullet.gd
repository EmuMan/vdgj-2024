extends RigidBody2D


const ENEMY_BULLET_SPEED = 500

var facing_direction: float = 0.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	facing_direction = transform.get_rotation()

func _physics_process(delta: float) -> void:
	var movement_vector := Vector2(ENEMY_BULLET_SPEED, 0) * delta
	movement_vector = movement_vector.rotated(facing_direction)
	var collision := move_and_collide(movement_vector)
	if collision:
		var collider := collision.get_collider()
		if collider is Node:
			if "Terrain" in collider.get_groups():
				on_terrain_collision()
			elif "Player" in collider.get_groups():
				on_player_collision(collider)

func on_terrain_collision() -> void:
	queue_free()

func on_player_collision(player: Node) -> void:
	var stats := player.get_parent().find_child("PlayerStats")
	if is_instance_valid(stats):
		stats.damage(10.0)
		queue_free()
