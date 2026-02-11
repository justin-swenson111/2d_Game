extends RigidBody2D

var dir = Vector2(0,0)
var speed=1000
func _physics_process(delta: float) -> void:
	apply_central_force(dir*speed)
