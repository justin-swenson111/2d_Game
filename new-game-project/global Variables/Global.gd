extends Node

var weaponList :={
	"sword" : [0.5,1.5,0.5,1,1],
	"spear" : [2,0.5,0.5,1,1],
	"axe" : [0.75,0.5,0.25,1.25,3],
	"mace" : [0.5,1,1,2,2]
}

var weaponSprites = {
	"sword":"res://sprites/weapon/Sword.png",
	"spear":"res://sprites/weapon/Spear.png",
	"axe":"res://sprites/weapon/Axe.png",
	"mace":"res://sprites/weapon/Mace.png"
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

var inventory :=["healPot","manaPot","resisPot"]

var curItem =""
