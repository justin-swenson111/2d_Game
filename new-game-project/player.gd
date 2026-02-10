extends CharacterBody2D

@onready var atkList :={
	"atkD" : $downAtk,
	"atkL" : $leftAtk,
	"atkR" : $rightAtk,
	"atkU" : $upAtk
}
@onready var weaponList :={
	"sword" : [1,1,0.5,1],
	"spear" : [2,0.5,0.5,1],
	"axe" : [0.5,1,0.75,1.25],
	"mace" : [1,1,1,2]
}
var w1 = "sword"
var w2 = "spear"
var curWeapon = w1

const SPEED = 100
var atkDelay =false

var atkDelayLng =1
var atkTime =0.5

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
	if event.is_action_pressed("switch"):
		switch()

func atk(dmg: Area2D):
	if not atkDelay:
		var coll = dmg.get_node("CollisionShape2D")
		attack(coll)
		atkDelay = true
		await get_tree().create_timer(atkDelayLng).timeout
		atkDelay=false
	
func attack(coll: Node2D):
	coll.disabled=false
	await get_tree().create_timer(atkTime).timeout
	coll.disabled=true

func switch():
	var height =0
	var width =0
	if curWeapon==w1:
		curWeapon=w2
	else: 
		curWeapon=w1
	for t in weaponList:
		var type = weaponList[t]
		if t == curWeapon:
			height= type[0]
			width = type[1]
			atkTime=type[2]
			atkDelayLng=type[3]
	for i in atkList:
		if atkList[i]==$leftAtk or atkList[i]==$rightAtk:
			atkList[i].scale.x=height
			atkList[i].scale.y=width
		else:
			atkList[i].scale.y=height
			atkList[i].scale.x=width
			
	


#attack hit box calls
func _on_left_atk_body_entered(body: Node2D) -> void:
	damage(body) 

func _on_right_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.

func _on_up_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.


func _on_down_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.
