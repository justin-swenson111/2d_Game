extends CharacterBody2D

const SPEED = 100

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	if input.length() > 0:
		velocity = input * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()
