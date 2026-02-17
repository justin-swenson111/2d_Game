extends CharacterBody2D
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")

var inRange = false
var chasing := false
var atking = false
var speed := 60.0
var health=5

@export var knockback_strength := 100.0
@export var knockback_stun_time := 0.5

var stunned := false


func _ready():
	agent.target_position = global_position
	

func hurt(source: Node2D,dmg: int):
	#takes damage then knockback
	print(health, dmg)
	health-=dmg
	knockback_from(source)
	if health<=0:
		self.queue_free()
	
func knockback_from(source: Node2D):
	#gets opposite direction from damage source and moves in that direction
	var dir := (global_position - source.global_position).normalized()
	velocity = dir * knockback_strength

	#cannot update its velocity for stun_time
	stunned = true

	await get_tree().create_timer(knockback_stun_time).timeout
	#enemy can move again
	stunned = false


func _physics_process(delta):
	agent.target_position = player.global_position
	if not chasing:
		$anim.stop()
		$stand.visible=true
		$walk.visible=false
		return
		
	
	#$anim.play("bwehWalk")
	# Update target every tick
	agent.target_position = player.global_position

	# Get next point on the path
	var next_pos = agent.get_next_path_position()

	var direction = (next_pos - global_position).normalized()
	#if not taking knockback move towards the player at speed
	if not stunned:
		velocity = direction * speed
	if not atking:
		$anim.play("bwehWalk")
		move_and_slide()

func atk(source):
	$attack.visible=true
	$walk.visible=false
	$stand.visible=false
	await get_tree().create_timer(0.5).timeout
	atking=true
	$anim.stop()
	$anim.play("bwehAtk")
	await get_tree().create_timer(1).timeout
	if inRange:
		source.ouchie(source)
		knockback_from(source)
	atking=false
	$attack.visible=false
	var small = load("res://sprites/bweh/BWEHatk1.png")
	$attack.texture=small
	$walk.visible=true
	$stand.visible=true
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	#if the player is in its pathfind area chase him
	if (body.is_in_group("player")):
		chasing=true
		$stand.visible=false
		$walk.visible=true
		
	

func _on_area_2d_body_exited(body: Node2D) -> void:
	#stop chasing player when leave area
	if (body.is_in_group("player")):
		chasing=false
