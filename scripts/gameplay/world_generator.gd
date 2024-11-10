extends Node2D


@export var load_target: Node2D

@export var load_range = 500
@export var block_width = 150


@onready var block_scene = preload("res://scenes/terrain_block.tscn")

var blocks: Dictionary = {}

var last_target_position = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_instance_valid(load_target):
		last_target_position = load_target.global_position
	
	var min_index = floori((last_target_position.x / 8 - load_range) / block_width)
	var max_index = floori((last_target_position.x / 8 + load_range) / block_width)
	
	var remaining = range(min_index, max_index + 1)
	var to_delete = []
	for index in blocks.keys():
		if index < min_index or index > max_index:
			blocks[index].queue_free()
			to_delete.append(index)
		else:
			remaining.erase(index)
	for index in to_delete:
		blocks.erase(index)
	
	for index in remaining:
		var new_block = create_block(index)
		blocks[index] = new_block

func create_block(index: int) -> Node2D:
	var x_pos = index * block_width
	print_debug(x_pos)
	var block := block_scene.instantiate() as Node2D
	block.position.x = x_pos * 8.0
	block.block_width = block_width
	add_child(block)
	return block
