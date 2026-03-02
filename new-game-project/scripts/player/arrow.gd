extends RigidBody2D

var dir = Vector2(0,0)
var dmg = 1
var speed=1000
func _physics_process(delta: float) -> void:
	apply_central_force(dir*speed)
	var atk = get_colliding_bodies()
	for body in atk:
		if not body.is_in_group("player"):
			if body.is_in_group("dest"):
				body.hurt(self,dmg)
			queue_free()
				
	
