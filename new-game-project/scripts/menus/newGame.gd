extends Area2D



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		#x,y,health,weaponlist,inventory,checkpoints
		Global.startX=0
		Global.startY=0
		Global.startHealth=5
		Global.weaponList={
			#"weapon":[dist away, dist sides, time atking, atkdelay, dmg]
			"sword" : [0.5,1.5,0.5,1,1],
			"spear" : [2,0.5,0.5,1,1]
		}
		Global.inventory=[]
		Global.checkpoints={}
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
