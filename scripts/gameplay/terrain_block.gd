extends Node2D


@export var block_width: float = 150
@export var block_height: float = 100
@export var boundary_thickness: float = 40

@export var pillar_min_height: float = 1
@export var pillar_max_height: float = 25
@export var pillar_min_width: float = 5
@export var pillar_max_width: float = 40

@export var platform_height: float = 1
@export var platform_width: float = 10

@onready var terrain_scene := preload("res://scenes/terrain.tscn")
@onready var stationary_enemy_scene := preload("res://scenes/enemy/stationary_enemy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	establish_boundaries()
	for i in range(10):
		add_random_floor_pillar(false)
	for i in range(10):
		add_random_floor_pillar(true)
	for i in range(10):
		add_random_platform()

func establish_boundaries() -> void:
	var x_pos = -block_width / 2
	
	var floor = instantiate_terrain(Vector2(x_pos, block_height / 2),
						Vector2(block_width, boundary_thickness))
	add_child(floor)
	var ceiling = instantiate_terrain(Vector2(x_pos, -(block_height / 2 + boundary_thickness)),
						Vector2(block_width, boundary_thickness))
	add_child(ceiling)

func add_random_floor_pillar(on_ceiling: bool):
	var x_pos = randf_range(-block_width / 2, block_width / 2)
	var width = randf_range(pillar_min_width, pillar_max_width)
	var height = randf_range(pillar_min_height, pillar_max_height)
	var y_pos = -block_height / 2 if on_ceiling else block_height / 2 - height
	var pillar = instantiate_terrain(Vector2(x_pos, y_pos), Vector2(width, height))
	add_child(pillar)

func add_random_platform():
	var pos = Vector2(randf_range(-block_width / 2, block_width / 2),
						randf_range(-block_height / 4, block_height / 4))
	var platform = instantiate_terrain(pos, Vector2(platform_width, platform_height))
	add_child(platform)
	
	var enemy_pos = pos + Vector2(platform_width / 2, -2.)
	var enemy = instantiate_stationary_enemy(enemy_pos)
	enemy.target = get_node("/root/TestScene/Player")
	print_debug(enemy.target)
	add_child(enemy)

func instantiate_terrain(position: Vector2, size: Vector2) -> Node2D:
	var terrain = terrain_scene.instantiate() as Node2D
	terrain.scale = size * 0.5
	terrain.position = position * 8.0
	return terrain

func instantiate_stationary_enemy(position: Vector2) -> Node2D:
	var enemy = stationary_enemy_scene.instantiate() as Node2D
	enemy.position = position * 8.0
	return enemy
