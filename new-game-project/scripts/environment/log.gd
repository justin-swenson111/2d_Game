extends Node

func hurt(player: Node2D,_dmg):
	if player.curWeapon=="axe":
		self.queue_free()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
