extends Node

var startX=0
var startY=0
var startHealth=5
var startGold=0

var allWeapons:={
#"weapon":[dist away, dist sides, time atking, atkdelay, dmg]
	"sword" : [0.5,1.5,0.5,1,1],
	"spear" : [2,0.5,0.5,1,1],
	"axe" : [0.75,0.5,0.25,1.5,1],
	"mace" : [0.5,1,1,2,2],
	"axeStrong" : [0.75,0.5,0.25,1.5,3],
}

var allMagWeapons :={
	#mana cost, destruction value, 
	#right hitbox postion x,y and scale x,y, 
	#and the shape of the hitbox
	"fireRod":[5,10, 40, 0, 1.5, 1.5,CircleShape2D],
	"iceRod":[2,8],
	"shockRod":[3,5]
}

var weaponList :={
#"weapon":[dist away, dist sides, time atking, atkdelay, dmg]
	"sword" : [0.5,1.5,0.5,1,1],
	"spear" : [2,0.5,0.5,1,1]
}

var magWeaponList:={}

var weaponSprites = {
	"sword":"res://sprites/weapon/Sword.png",
	"spear":"res://sprites/weapon/Spear.png",
	"axe":"res://sprites/weapon/Axe.png",
	"mace":"res://sprites/weapon/Mace.png",
	"axeStrong":"res://sprites/weapon/Axe.png",
}
var w1 = "sword"
var w2 = "spear"

var items :={
	#amt healed
	"healPot":[3,"res://sprites/items/healPot.png"],
	#charge gained
	"manaPot":[10,"res://sprites/items/manaPot.png"],
	#dmg multiplier
	"dmgPot":[2,"res://sprites/items/dmgPot.png"],
	#fraction of dmg taken
	"resisPot":[2,"res://sprites/items/resisPot.png"],
}

var artifacts :={
	#revive once on death
	"revive":"res://sprites/items/healPot.png",
	#extra atk dmg on taking dmg
	"dmg":["res://sprites/items/manaPot.png"],
	#resistance
	"res":[""],
	#less mana use
	"mana":[""]
}

var collArtifacts =[]
var curArtifact =""
var checkpoints={}

var paused=false

var inventory :=["healPot","manaPot","resisPot"]

var curItem =""

func save(player: Node2D):
	var data = [
		player.position.x,
		player.position.y,
		player.health,
		player.weaponList,
		player.inventory,
		checkpoints,
		player.gold,
		collArtifacts,
		curArtifact
	]
	var saveFile = FileAccess.open("user://saveFile.save", FileAccess.WRITE)
	saveFile.store_line(JSON.stringify(data))
