extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_item_selected(index: int) -> void:
	var x
	var y
	for i in Global.checkpoints:
		if i == self.get_item_text(index):
			x = Global.checkpoints[i][0]
			y = Global.checkpoints[i][1]
	var scene=owner.get_parent()
	var player
	for i in scene.get_children():
		if i.is_in_group("player"):
			player=i
	player.position.x=x
	player.position.y=y
	get_tree().paused=false	
	owner.queue_free()
