extends Control


@onready var killed_text = $Killed


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	killed_text.text = "you only killed %d larrys" % Util.enemies_killed



func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/test_scene.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/main_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
