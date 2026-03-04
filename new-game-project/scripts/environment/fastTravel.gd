extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player= get_tree().get_first_node_in_group("player")
	if player.global_position.y>self.global_position.y:
		self.get_parent().z_index=1
	else:
		self.get_parent().z_index=3


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var inList = false
		for i in Global.checkpoints:
			if i ==self.get_parent().name:
				inList=true
		if !inList:
			Global.checkpoints[self.get_parent().name]=[self.global_position.x,self.global_position.y]
		var menu = preload("res://scenes/checkpointTravelMenu.tscn")
		get_tree().paused=true
		var ftMenu=menu.instantiate()
		var cam = get_tree().get_first_node_in_group("player").get_child(8)
		ftMenu.position=cam.global_position
		get_tree().current_scene.add_child(ftMenu)
		Global.save(body)
