extends OptionButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_selected(index: int) -> void:
	var x
	var y
	for i in Global.checkpoints:
		if i == self.get_item_text(index):
			x = Global.checkpoints[i][0]
			y = Global.checkpoints[i][1]
	print(get_tree().get_node_count())
