extends Area2D



func _on_body_entered(body: Node2D) -> void:
	owner.inRange=true
	if body.is_in_group("player"):
		owner.atk(body)
		


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		if owner:
			owner.inRange=false
