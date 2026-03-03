extends Area2D



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
