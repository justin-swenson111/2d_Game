extends CharacterBody2D

const SPEED = 100

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	if input.length() > 0:
		velocity = input * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()

func damage(body: Node2D):
	if (body.is_in_group("dest")):
		body.hurt()


func _on_left_atk_body_entered(body: Node2D) -> void:
	damage(body) 


func _on_right_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.


func _on_up_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.


func _on_down_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.
