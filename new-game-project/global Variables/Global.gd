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
	"healPot":[3,"sprite"],
	#charge gained
	"manaPot":[10,"sprite"],
	#dmg multiplier
	"dmgPot":[2,"sprite"],
	#fraction of dmg taken
	"resisPot":[2,"sprite"],
}

var inventory :=["healPot","manaPot","dmgPot","resisPot"]
