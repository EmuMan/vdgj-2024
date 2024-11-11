extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.get_groups():
		body.get_node("PlayerStats").heal(20.)
		queue_free()
