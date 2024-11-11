extends Area2D


@onready var hurtbox := $Hurtbox
@onready var stick := $Stick

const MELEE_DURATION = 150

var instantiation_time := 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiation_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	var progress = (float)(Time.get_ticks_msec() - instantiation_time) / MELEE_DURATION
	print_debug(progress)
	stick.rotation = -0.4 + progress * 0.8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() > instantiation_time + MELEE_DURATION:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if "Enemy" in body.get_groups():
		on_hit_enemy(body)

func on_hit_enemy(enemy: Node2D) -> void:
	var stats := enemy.find_child("EnemyStats")
	if is_instance_valid(stats):
		stats.damage(40.0)
