extends Node

var player
var enter
var extTime=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if enter:
		if player.health>=player.maxHealth:
			#print(player.health," ",player.maxHealth," ",player.curExtraHealth)
			if player.curExtraHealth!=player.maxExtraHealth:
				extTime+=delta
		if extTime>=1:
			player.extraHeal()
			extTime=0


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player=body
		enter=true
		body.healthIncTime=1
		body.manaIncTime=1


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		enter=false
		body.healthIncTime=30
		body.manaIncTime=10
