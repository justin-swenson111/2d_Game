extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var travOpt = $locations/MenuButton/wOption1
	travOpt.clear()
	for i in Global.checkpoints:
		travOpt.add_item(i)
		travOpt.add_item(i)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
