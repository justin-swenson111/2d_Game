extends Node2D

const h = preload("res://objects/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in $player.health:
		var heart = h.instantiate()
		heart.name="h"+str(i)
		$player/hearts.add_child(heart)
		var child = $player/hearts.get_children()
		for j in child:
			if j.name==heart.name:
				j.position.y = -90
				j.position.x=-175+15*i
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
