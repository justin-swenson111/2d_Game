extends Button




func _on_pressed() -> void:
	get_tree().paused=false
	get_parent().queue_free()
	var p = self.owner.get_parent().get_tree().get_first_node_in_group("player")
	p.w1 = Global.w1
	p.w2 = Global.w2
	p.curWeapon=p.w1
	p.setWeapon()
