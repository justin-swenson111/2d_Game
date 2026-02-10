extends CharacterBody2D

@onready var atkList :={
	"atkD" : $downAtk,
	"atkL" : $leftAtk,
	"atkR" : $rightAtk,
	"atkU" : $upAtk
}


const SPEED = 100
var atkDelay =false
var atkDelayLng =2
func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	if input.length() > 0:
		velocity = input * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()

func damage(body: Node2D):
	if (body.is_in_group("dest")):
		body.hurt(self)

func _input(event: InputEvent) -> void:
	for k in atkList.keys():
		if event.is_action_pressed(k):
			atk(atkList[k])

func atk(dmg: Area2D):
	if not atkDelay:
		var coll = dmg.get_node("CollisionShape2D")

		coll.disabled=false
		await get_tree().create_timer(1).timeout
		coll.disabled=true
		atkDelay = true
		await get_tree().create_timer(atkDelayLng).timeout
		atkDelay=false
	


func _on_left_atk_body_entered(body: Node2D) -> void:
	damage(body) 


func _on_right_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.


func _on_up_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.


func _on_down_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.
