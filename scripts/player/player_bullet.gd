extends RigidBody2D


const PLAYER_BULLET_SPEED = 500

var facing_direction: float = 0.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	facing_direction = transform.get_rotation()

func _physics_process(delta: float) -> void:
	var movement_vector := Vector2(PLAYER_BULLET_SPEED, 0) * delta
	movement_vector = movement_vector.rotated(facing_direction)
	var collision := move_and_collide(movement_vector)
	if collision:
		var collider := collision.get_collider()
		if collider is Node:
			if "Terrain" in collider.get_groups():
				on_terrain_collision()
			elif "Enemy" in collider.get_groups():
				on_enemy_collision(collider)

func on_terrain_collision() -> void:
	queue_free()

func on_enemy_collision(enemy: Node) -> void:
	var stats := enemy.find_child("EnemyStats")
	if is_instance_valid(stats):
		stats.damage(40.0)
		queue_free()
