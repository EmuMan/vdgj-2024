extends Node2D


@export var destabilizer: Destabilizer

@onready var on_sprite = $ReactorOnSprite
@onready var off_sprite = $ReactorOffSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destabilizer.destabilize.connect(on_destabilize)
	destabilizer.stabilize.connect(on_stabilize)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_destabilize() -> void:
	on_sprite.visible = true
	off_sprite.visible = false

func on_stabilize() -> void:
	on_sprite.visible = false
	off_sprite.visible = true
