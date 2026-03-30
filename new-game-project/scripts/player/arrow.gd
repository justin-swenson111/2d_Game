extends RigidBody2D

var dir = Vector2(0,0)
var dmg = 1
var speed=1000
func _physics_process(_delta: float) -> void:
	apply_central_force(dir*speed)
	var atk = get_colliding_bodies()
	for body in atk:
		if not body.is_in_group("player"):
			if body.is_in_group("dest"):
				if Global.curBow=="bow":
					dmg=1
				else:
					dmg=2
				body.hurt(self,dmg)
			queue_free()
				
	
