extends Node

func hurt(_player: Node2D,_dmg):
	var c = preload("res://objects/worldItems/gold.tscn")
	var coin = c.instantiate()
	coin.position=self.global_position
	get_tree().current_scene.add_child(coin)
	self.queue_free()
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
