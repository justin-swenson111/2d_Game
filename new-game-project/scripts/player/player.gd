extends CharacterBody2D

@onready var atkList :={
	"atkD" : $downAtk,
	"atkL" : $leftAtk,
	"atkR" : $rightAtk,
	"atkU" : $upAtk
}

const arrow = preload("res://objects/playerItemSprites/arrow.tscn")
const menu = preload("res://scenes/playerMenu.tscn")
const fullH = preload("res://objects/playerUI/heart.tscn")
const emptyH = preload("res://objects/playerUI/heartEmpty.tscn")
const fullM = preload("res://objects/playerUI/mana.tscn")
const emptym = preload("res://objects/playerUI/manaEmpty.tscn")


var knockback_strength = 100
var knockback=false

const maxHealth = 5
const maxMana = 10

var maxExtraHealth = 2
var curExtraHealth = 0

var health = 3
var mana = 10

var manaInc=0
var healthInc=0

var manaIncTime=10
var healthIncTime=30

var gold = 0

#weapon name [vertical range, horizontal range, time attacking, attack delay, xpos, ypos]
@onready var weaponList =Global.weaponList
@onready var weaponSprites = Global.weaponSprites
@onready var inventory=Global.inventory
@onready var magWeaponList=Global.allMagWeapons

var w1 = Global.w1
var w2 = Global.w2
var curWeapon = w1
@onready var curWeaponSprite = weaponSprites["sword"]

@onready var itemList = Global.items

var curMagWeapon

var curItem
var curItemSprite

var melee = true
var mag = false

const SPEED = 100
var atkDelay =false
var atking = false

var atkDelayLng =1
var atkTime =0.5
var atkDamage = 1

var curArtifact =""

var dmgMultiplier = 1
var resistanceMultiplier=1





#auto sets the base selections based on the save file
func _ready():
	#set gold
	gold=Global.startGold
	$gold.text=str(gold)
	
	#set positiona dn z index
	self.z_index=2
	self.position.x=Global.startX
	self.position.y=Global.startY
	#set health
	health=Global.startHealth
	curArtifact=Global.curArtifact
	#
	if inventory.size()>0:
		curItem= inventory[0]
		Global.curItem=curItem
		curItemSprite=itemList[curItem][1]
		var itmSprite = load(curItemSprite)
		$currentItem.texture=itmSprite
	setWeapon()
	if health>maxHealth:
		health=maxHealth
	for i in health:
		var heart = fullH.instantiate()
		heart.name="h"+str(i)
		heart.add_to_group("full")
		$hearts.add_child(heart)
		var child = $hearts.get_children()
		for j in child:
			if j.name==heart.name:
				j.position.y = -70
				j.position.x=-175+15*i
	for i in mana:
		var man = fullM.instantiate()
		man.name="m"+str(i)
		man.add_to_group("full")
		$mana.add_child(man)
		var child = $mana.get_children()
		for j in child:
			if j.name==man.name:
				j.position.y = -90
				j.position.x=-175+15*i





#movement based on wasd presses
func _physics_process(delta: float) -> void:
	#If there is missing mana it starts a timer to recharge it
	#one mana charge increase every 5 seconds
	if mana!=maxMana:
		manaInc+=delta
	if manaInc>=manaIncTime:
		incMana(1)
		manaInc=0
		
	#If there is missing health it starts a timer to recharge it
	#one hp increase every 10 seconds
	if health!=maxHealth:
		healthInc+=delta
	if healthInc>=healthIncTime:
		heal(1)
		healthInc=0
	
	var input = Input.get_vector("left", "right", "up", "down")

	if input.length() > 0 and not knockback:
		velocity = input * SPEED
		walkAnim()
	elif knockback:
		pass
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	if velocity==Vector2.ZERO and not atkDelay:
		$stand.visible=true
		$anim.stop()
		$moving.visible=false	
	if not atking:
		move_and_slide()





#if a destructable object is in a attack area it takes the set damage
func damage(body: Node2D):
	if (body.is_in_group("dest")):
		var dmgArti=1
		if curArtifact=="dmg":
			dmgArti=1.5
		
		body.hurt(self,round(dmgArti*atkDamage)*dmgMultiplier)





#on input events
func _input(event: InputEvent) -> void:
	for k in atkList.keys():
		if event.is_action_pressed(k):
			if melee and not mag:
				atk(atkList[k])
			elif not mag:
				rgdAtk(k)
			else:
				magAtk(k)
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
	if event.is_action_pressed("switchMag"):
		if mag:
			mag=false
			setWeapon()
		else:
			mag=true
			atkDelayLng=2
	if event.is_action_pressed("openMenu"):
		get_tree().paused=true
		Global.paused=true
		var menuInst = menu.instantiate()
		menuInst.position=$mainCamera.global_position
		get_tree().current_scene.add_child(menuInst)	
	if event.is_action_pressed("useItem"):
		useItem()

func walkAnim():
	await get_tree().create_timer(0.1).timeout
	if velocity!=Vector2.ZERO:
		var ang = velocity.angle()
		if -PI/4<ang and ang<PI/4:
			$anim.play("rightWalk")
			await get_tree().create_timer(0.01).timeout
			$moving.visible=true
			$stand.visible=false
		elif PI/4<ang and ang<3*PI/4:
			$anim.play("fwdWalk")
			await get_tree().create_timer(0.01).timeout
			$moving.visible=true
			$stand.visible=false
		elif -3*PI/4<ang and ang<-PI/4:
			$anim.play("bckwdWalk")
			await get_tree().create_timer(0.01).timeout
			$moving.visible=true
			$stand.visible=false
		else:
			$anim.play("leftWalk")
			await get_tree().create_timer(0.01).timeout
			$moving.visible=true
			$stand.visible=false





#getting the collision to be used and running the attack delay
func atk(dmg: Area2D):
	if not atkDelay:
		var coll = dmg.get_node("CollisionShape2D")
		attack(coll)
		atkDly()

#turning on the collisionshape and keeping it on for the atk time
func attack(coll: Node2D):
	coll.disabled=false
	atking=true
	await get_tree().create_timer(atkTime).timeout
	atking=false
	coll.disabled=true

#running the atk delay
func atkDly():
	atkDelay = true
	await get_tree().create_timer(atkDelayLng).timeout
	atkDelay=false

#switching weapon
func switch():
	#switching the current weapon
	if melee:
		if curWeapon==w1:
			curWeapon=w2
		else: 
			curWeapon=w1
		setWeapon()

#setting the current weapon atk settings
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
	if not atkDelay and mana>0:
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
		decMana(2)

#magic attacks
func magAtk(dir: String):
	
	var coll
	var xPos
	var yPos
	var xScale
	var yScale
	var shape
	
	#if the atk dely is not active and you have mana
	if not atkDelay and mana>0 and curMagWeapon!=null:
		var desc = Global.allMagWeapons[curMagWeapon]
		#activate the corresponding magic weapon hitbox
		#as well as changing the size and shape depenfing
		#on the current weapon used
		match dir:
			"atkL":
				coll = $magL/CollisionShape2D
				xPos=-desc[2]
				yPos=desc[3]
				xScale=desc[4]
				yScale=desc[5]
				shape=desc[6]
				coll.shape=shape.new()
				coll.scale=Vector2(xScale,yScale)
				coll.position=Vector2(xPos,yPos)
				coll.disabled=false
				atkDly()
				atking=true
				await get_tree().create_timer(atkTime).timeout
				atking=false
				coll.disabled=true
			"atkR":
				coll = $magR/CollisionShape2D
				xPos=desc[2]
				yPos=desc[3]
				xScale=desc[4]
				yScale=desc[5]
				shape=desc[6]
				coll.shape=shape.new()
				coll.scale=Vector2(xScale,yScale)
				coll.position=Vector2(xPos,yPos)
				coll.disabled=false
				atkDly()
				atking=true
				await get_tree().create_timer(atkTime).timeout
				atking=false
				coll.disabled=true
			"atkU":
				coll = $magU/CollisionShape2D
				xPos=desc[3]
				yPos=-desc[2]
				xScale=desc[5]
				yScale=desc[4]
				shape=desc[6]
				coll.shape=shape.new()
				coll.scale=Vector2(xScale,yScale)
				coll.position=Vector2(xPos,yPos)
				coll.disabled=false
				atkDly()
				atking=true
				await get_tree().create_timer(atkTime).timeout
				atking=false
				coll.disabled=true
			"atkD":
				coll = $magD/CollisionShape2D
				xPos=desc[3]
				yPos=desc[2]
				xScale=desc[5]
				yScale=desc[4]
				shape=desc[6]
				coll.shape=shape.new()
				coll.scale=Vector2(xScale,yScale)
				coll.position=Vector2(xPos,yPos)
				coll.disabled=false
				atkDly()
				atking=true
				await get_tree().create_timer(atkTime).timeout
				atking=false
				coll.disabled=true

func magDmg(body: Node2D, col):
	if body.is_in_group("enem"):
		var dmgArti=1
		if curArtifact=="dmg":
			dmgArti=1.5
		match curMagWeapon:
			"fireRod":
				#fire rod does 3 damage and stuns for 0 seconds
				decMana(Global.allMagWeapons[curMagWeapon][0])
				body.magHurt(round(dmgArti*3)*dmgMultiplier,0)
			"iceRod":
				#ice rod does 1 damage and freezes for 5 seconds
				decMana(Global.allMagWeapons[curMagWeapon][0])
				body.magHurt(round(dmgArti*1)*dmgMultiplier,5)
				
			"shockRod":
				#shock rod does 2 damage and stuns for 2 seconds
				decMana(Global.allMagWeapons[curMagWeapon][0])
				body.magHurt(round(dmgArti*2)*dmgMultiplier,2)





#setting the current Item
func setItem():
	if curItem!="":
		curItemSprite=itemList[curItem][1]
		var itmSprite = load(curItemSprite)
		$currentItem.texture=itmSprite
	else:
		$currentItem.texture=null

func useItem():
	#print(curItem)
	if curItem=="healPot":
		heal(itemList[curItem][0])
	if curItem=="manaPot":
		incMana(itemList[curItem][0])
	if curItem=="dmgPot":
		changeDmg(itemList[curItem][0])
	if curItem=="resisPot":
		changeResis(itemList[curItem][0])
	if inventory.size()>0:
		for i in range(inventory.size()):
			if inventory[i]==curItem:
				print(i, inventory[i])
				inventory.remove_at(i)
				break
	if inventory.size()>=1:
		curItem=inventory[0]
	else:
		curItem=""
	curItem=curItem
	setItem()
	




#change how much damage you do
func changeDmg(amt):
	dmgMultiplier=amt
	await get_tree().create_timer(5).timeout
	dmgMultiplier=1

#change the amt of damage you resist
func changeResis(amt):
	resistanceMultiplier=amt
	await get_tree().create_timer(5).timeout
	resistanceMultiplier=1






#decrease player mana
func decMana(m):
	if curArtifact=="mana":
		m*=0.5
	mana-=m
	for j in range(m):
		var highest = $mana.get_child(0)
		var empt = emptym.instantiate()
		for i in $mana.get_children():
			if (i.is_in_group("full")):
				if int(i.name.substr(1))>int(highest.name.substr(1)):
					highest=i
					empt.name="e"+str(i.name.substr(1))
		empt.position.x = highest.position.x
		empt.position.y = highest.position.y
		empt.add_to_group("empty")
		$mana.add_child(empt)
		highest.free()

#take player damage
func ouchie(source, dmgTaken):
	var arti=1
	if curArtifact=="res":
		arti=1.5
	var amt=floor(dmgTaken/(resistanceMultiplier*arti))
	#print(resistanceMultiplier)
	if amt>0:
		for j in amt:
			health-=1
			knockback_from(source)
			var highest = $hearts.get_child(0)
			var empt = emptyH.instantiate()
			for i in $hearts.get_children():
				if (i.is_in_group("full")):
					#print(i.name)
					if int(i.name.substr(1))>int(highest.name.substr(1)):
						highest=i
						empt.name="e"+str(i.name.substr(1))
			if health<maxHealth:
				empt.position.x = highest.position.x
				empt.position.y = highest.position.y
				empt.add_to_group("empty")
				$hearts.add_child(empt)
			else:
				curExtraHealth-=1
			#print(highest.name)
			highest.free()
			if health==0:
				if curArtifact!="revive":
					await get_tree().create_timer(0.01).timeout
					get_tree().change_scene_to_file("res://scenes/GameOver.tscn")
				else:
					heal(maxHealth)
					Global.collArtifacts.erase("revive")
					curArtifact="aa"

#increase player health
func heal(amt):
	for j in amt:
		if health<maxHealth:
			health+=1
			var lowest
			for i in $hearts.get_children():
				if i.is_in_group("empty"):
					lowest = i
					pass
			if lowest!=null:
				var full = fullH.instantiate()
				full.name="h"+str(lowest.name.substr(1))
				full.position.x = lowest.position.x
				full.position.y = lowest.position.y
				lowest.free()
				full.add_to_group("full")
				$hearts.add_child(full)

#increase player health above normal max
func extraHeal():
	curExtraHealth+=1
	health+=1
	var full = fullH.instantiate()
	var highest = $hearts.get_child($hearts.get_children().size()-1)
	full.name="h"+str(int(highest.name.substr(1))+1)
	full.position.x = highest.position.x + 15
	full.position.y = highest.position.y
	full.add_to_group("full")
	$hearts.add_child(full)

#increase player mana
func incMana(amt):
	for j in amt:
		if mana!=maxMana:
			mana+=1
			var lowest
			for i in $mana.get_children():
				if i.is_in_group("empty"):
					lowest = i
					pass
			var full = fullM.instantiate()
			full.name="m"+str(lowest.name.substr(1))
			#print(lowest.name)
			full.position.x = lowest.position.x
			full.position.y = lowest.position.y
			full.add_to_group("full")
			$mana.add_child(full)
			lowest.free()

#player knockback
func knockback_from(source: Node2D):
	#gets opposite direction from damage 
	#source and moves in that direction
	knockback=true
	var dir := (global_position - source.global_position).normalized()
	
	velocity = dir * knockback_strength
	await get_tree().create_timer(0.25).timeout
	knockback=false

#increase player gold count
func addGold(amt):
	gold+=amt
	$gold.text=str(gold)





#attack hit box calls
func _on_left_atk_body_entered(body: Node2D) -> void:
	damage(body) 

func _on_right_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.

func _on_up_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.

func _on_down_atk_body_entered(body: Node2D) -> void:
	damage(body) # Replace with function body.





func _on_mag_l_body_entered(body: Node2D) -> void:
	magDmg(body,$magL)

func _on_mag_r_body_entered(body: Node2D) -> void:
	magDmg(body,$magR)

func _on_mag_d_body_entered(body: Node2D) -> void:
	magDmg(body,$magD)

func _on_mag_u_body_entered(body: Node2D) -> void:
	magDmg(body,$magU)
