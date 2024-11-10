extends Node2D


@export var destabilizer: Destabilizer

@onready var on_sprite = $ReactorOnSprite
@onready var off_sprite = $ReactorOffSprite

var noise_x := FastNoiseLite.new()
var noise_y := FastNoiseLite.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destabilizer.destabilize.connect(on_destabilize)
	destabilizer.stabilize.connect(on_stabilize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_position = Vector2(noise_x.get_noise_1d(Time.get_ticks_msec()),
							   noise_y.get_noise_1d(Time.get_ticks_msec() + 100000))
	on_sprite.position = new_position * 30

func on_destabilize() -> void:
	on_sprite.visible = true
	off_sprite.visible = false

func on_stabilize() -> void:
	on_sprite.visible = false
	off_sprite.visible = true
