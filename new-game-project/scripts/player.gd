extends CharacterBody2D

@onready var atkList :={
	"atkD" : $downAtk,
	"atkL" : $leftAtk,
	"atkR" : $rightAtk,
	"atkU" : $upAtk
}

const arrow = preload("res://objects/arrow.tscn")
const menu = preload("res://scenes/playerMenu.tscn")
const h = preload("res://objects/heart.tscn")
const emptyH = preload("res://objects/heartEmpty.tscn")


var knockback_strength = 100
var knockback=false

var health = 3

#weapon name [vertical range, horizontal range, time attacking, attack delay, xpos, ypos]
@onready var weaponList =Global.weaponList
@onready var weaponSprites = Global.weaponSprites

var w1 = Global.w1
var w2 = Global.w2
var curWeapon = w1
@onready var curWeaponSprite = weaponSprites["sword"]

var melee = true

const SPEED = 100
var atkDelay =false

var atkDelayLng =1
var atkTime =0.5
var atkDamage = 1

#auto sets the weapon based on selections
func _ready():
	setWeapon()
	for i in health:
		var heart = h.instantiate()
		heart.name="h"+str(i)
		heart.add_to_group("heart")
		$hearts.add_child(heart)
		var child = $hearts.get_children()
		for j in child:
			if j.name==heart.name:
				j.position.y = -90
				j.position.x=-175+15*i
	

#movement based on wasd presses
func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")

	if input.length() > 0 and not knockback:
		velocity = input * SPEED
	elif knockback:
		pass
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	if velocity==Vector2.ZERO and not atkDelay:
		$stand.visible=true
		$moving.visible=false	
		$anim.stop()
		
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
			#set the dmg and atk delay correctly
			setWeapon()
			melee=false	
		else:
			#set delay to ranged time
			#dmg is set in arrow.gd
			atkDelayLng=1
			melee=true
	if event.is_action_pressed("openMenu"):
		get_tree().paused=true
		var menuInst = menu.instantiate()
		menuInst.position=$mainCamera.global_position
		get_tree().current_scene.add_child(menuInst)
	if event.is_action_pressed("down"):
		$stand.visible=false
		$moving.visible=true
		$anim.stop()
		$anim.play("fwdWalk")
	if event.is_action_pressed("up"):
		$stand.visible=false
		$moving.visible=true
		$anim.stop()
		$anim.play("bckwdWalk")

#getting the collision to be used and running the attack delay
func atk(dmg: Area2D):
	if not atkDelay:
		var coll = dmg.get_node("CollisionShape2D")
		attack(coll)
		atkDly()

#turning on the collisionshape and keeping it on for the atk time
func attack(coll: Node2D):
	coll.disabled=false
	await get_tree().create_timer(atkTime).timeout
	coll.disabled=true

func atkDly():
	atkDelay = true
	await get_tree().create_timer(atkDelayLng).timeout
	atkDelay=false
#switching weapon
func switch():
	#switching the current weapon
	if curWeapon==w1:
		curWeapon=w2
	else: 
		curWeapon=w1
	setWeapon()

func setWeapon():
	var height = 0
	var width = 0
		#iteracting through keys in weapon dictionary
	for t in weaponList:
		#getting the array in the disctionary value
		var type = weaponList[t]
		#if the new current weapon equals the key
		if t == curWeapon:
			#setting the sprite path
			curWeaponSprite=weaponSprites[t]
			#height and width of weapon hit box
			height= type[0]
			width = type[1]
			#length of attack and delay before next attack
			atkTime=type[2]
			atkDelayLng=type[3]
			#amount of damage
			atkDamage = type[4]
			
	$currentWeapon.texture=load(curWeaponSprite)
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
	#if the atk dely is not active
	if not atkDelay:
		#create an instance of the arrow object and set its 
		#rotation and velocity depending on where it got spawned
		var nArrow = arrow.instantiate()
		if dir =="atkU":
			nArrow.dir=Vector2(0,-1)
			nArrow.rotation=deg_to_rad(270)
		elif dir =="atkD":
			nArrow.dir=Vector2(0,1)
			nArrow.rotation=deg_to_rad(90)
		elif dir == "atkL":
			nArrow.dir=Vector2(-1,0)
			nArrow.rotation=deg_to_rad(180)
		else:
			nArrow.dir=Vector2(1,0)
		#create the arrow and start the atk delay
		add_child(nArrow)
		atkDly()

func ouchie(source):
	health-=1
	knockback_from(source)
	var highest = $hearts.get_child(0)
	var empt = emptyH.instantiate()
	for i in $hearts.get_children():
		if (i.is_in_group("heart")):
			if int(i.name.substr(1))>int(highest.name.substr(1)):
				highest=i
				empt.name="e"+str(i.name.substr(1))
	empt.position.x = highest.position.x
	empt.position.y = highest.position.y
	empt.add_to_group("emptyHeart")
	
	$hearts.add_child(empt)
	highest.queue_free()
	heal()

func heal():
	health-=1
	var lowest = $hearts.get_child(0)
	var full = h.instantiate()
	for i in $hearts.get_children():
		if (i.is_in_group("emptyHeart")):
			#print(i.name)
			if int(i.name.substr(1))<int(lowest.name.substr(1)):
				lowest=i
				full.name="e"+str(i.name.substr(1))
	full.position.x = lowest.position.x
	full.position.y = lowest.position.y
	full.add_to_group("heart")
	#$hearts.add_child(full)
	#lowest.queue_free()
	pass
		
		
func knockback_from(source: Node2D):
	#gets opposite direction from damage 
	#source and moves in that direction
	knockback=true
	var dir := (global_position - source.global_position).normalized()
	
	velocity = dir * knockback_strength
	await get_tree().create_timer(0.25).timeout
	knockback=false
	

#attack hit box calls
func _on_left_atk_body_entered(body: Node2D) -> void:
	damage(body) 

func _on_right_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.

func _on_up_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.

func _on_down_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.
