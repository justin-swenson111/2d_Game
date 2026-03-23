extends Area2D



func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		var saveFile = FileAccess.open("user://saveFile.save",FileAccess.READ)
		#x,y,health,weaponlist,inventory,checkpoints,gold
		var saveData=JSON.parse_string(saveFile.get_as_text())
		print(saveData)
		Global.startX=saveData[0]
		Global.startY=saveData[1]
		Global.startHealth=saveData[2]
		Global.weaponList=saveData[3]
		Global.inventory=saveData[4]
		Global.checkpoints=saveData[5]
		Global.checkpoints.sort()
		Global.startGold=int(saveData[6])
		Global.collArtifacts=saveData[7]
		Global.collArtifacts.sort()
		Global.curArtifact=saveData[8]
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
		
