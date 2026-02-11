extends CharacterBody2D

@onready var atkList :={
	"atkD" : $downAtk,
	"atkL" : $leftAtk,
	"atkR" : $rightAtk,
	"atkU" : $upAtk
}

const arrow = preload("res://arrow.tscn")

#weapon name [vertical range, horizontal range, time attacking, attack delay, xpos, ypos]
@onready var weaponList :={
	"sword" : [0.5,1.5,0.5,1,1],
	"spear" : [2,0.5,0.5,1,1],
	"axe" : [0.75,0.5,0.25,1.25,3],
	"mace" : [0.5,1,1,2,2]
}
var w1 = "axe"
var w2 = "mace"
var curWeapon = w2

var melee = true

const SPEED = 100
var atkDelay =false

var atkDelayLng =1
var atkTime =0.5
var atkDamage = 1

#auto sets the weapon based on selections
func _ready():
	switch()

#movement based on wasd presses
func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	if input.length() > 0:
		velocity = input * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()

#if a destructable object is in a attack area it takes the set damage
func damage(body: Node2D):
	if (body.is_in_group("dest")):
		body.hurt(self,atkDamage)

#on input events
func _input(event: InputEvent) -> void:
	for k in atkList.keys():
		if event.is_action_pressed(k):
			if melee:
				atk(atkList[k])
			else:
				rgdAtk(k)
	if event.is_action_pressed("switch"):
		switch()
	if event.is_action_pressed("switchRgd"):
		if melee:
			melee=false	
		else:
			melee=true

#getting the collision to be used and running the attack delay
func atk(dmg: Area2D):
	if not atkDelay:
		var coll = dmg.get_node("CollisionShape2D")
		attack(coll)
		atkDelay = true
		await get_tree().create_timer(atkDelayLng).timeout
		atkDelay=false
	
#turning on the collisionshape and keeping it on for the atk time
func attack(coll: Node2D):
	coll.disabled=false
	await get_tree().create_timer(atkTime).timeout
	coll.disabled=true

#switching weapon
func switch():
	var height = 0
	var width = 0
	
	#switching the current weapon
	if curWeapon==w1:
		curWeapon=w2
	else: 
		curWeapon=w1
		
	#iteracting through keys in weapon dictionary
	for t in weaponList:
		#getting the array in the disctionary value
		var type = weaponList[t]
		#if the new current weapon equals the key
		if t == curWeapon:
			#height and width of weapon hit box
			height= type[0]
			width = type[1]
			#length of attack and delay before next attack
			atkTime=type[2]
			atkDelayLng=type[3]
			#amount of damage
			atkDamage = type[4]
			
	#setting the different hitboxes size
	for i in atkList:
		var coll = atkList[i].get_node("CollisionShape2D")
		
		#horizontal hitboxes are inverse sized
		if atkList[i]==$leftAtk or atkList[i]==$rightAtk:
			coll.scale.x=height
			coll.scale.y=width
			
		#vertical hitboxes are the standard size
		else:
			coll.scale.y=height
			coll.scale.x=width

#ranged attack
func rgdAtk(dir: String):
	var nArrow = arrow.instantiate()
	if dir =="atkU":
		nArrow.dir=Vector2(0,-1)
	elif dir =="atlD":
		nArrow.dir=Vector2(0,1)
	elif dir == "atkL":
		nArrow.dir=Vector2(-1,0)
	else:
		nArrow.dir=Vector2(1,0)

#attack hit box calls
func _on_left_atk_body_entered(body: Node2D) -> void:
	damage(body) 

func _on_right_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.

func _on_up_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.

func _on_down_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.
