extends CharacterBody2D
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var player = get_tree().get_first_node_in_group("player")

var chasing := false
var speed := 60.0

func _ready():
	agent.target_position = global_position
	

func _physics_process(delta):
	
	agent.target_position = player.global_position
	if not chasing:
		return

	# Update target every tick
	agent.target_position = player.global_position

	# Get next point on the path
	var next_pos = agent.get_next_path_position()

	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_visible_on_screen_notifier_2d_screen_entered():
	chasing = true
	agent.target_position = player.global_position

func _on_visible_on_screen_notifier_2d_screen_exited():
	chasing = false
	agent.target_position = global_position
