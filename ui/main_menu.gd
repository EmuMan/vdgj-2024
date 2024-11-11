extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/test_scene.tscn")

func _on_controls_pressed() -> void:
	get_tree().change_scene_to_file("res://levels/controls.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
