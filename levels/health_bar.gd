extends ProgressBar

@export var player_stats: PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_stats.health_changed.connect(update)
	update()

func update() -> void:
	max_value = player_stats.max_health
	value = player_stats.health
