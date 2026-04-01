extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	artiRefresh()
	self.z_index=10
	var travOpt = $locations/MenuButton/wOption1
	travOpt.clear()
	for i in Global.checkpoints:
		travOpt.add_item(i)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_(_delta: float) -> void:
	pass

func artiRefresh():
	var artifact=$artifact/MenuButton/wOption1
	Global.collArtifacts.sort()
	artifact.clear()
	artifact.add_item(Global.curArtifact)
	var items=Global.collArtifacts.duplicate()
	var pos = items.find(Global.curArtifact)
	if pos>=0:
		items.remove_at(pos)
	for i in items:
		#if i!=Global.curArtifact or !first:
			artifact.add_item(i)
