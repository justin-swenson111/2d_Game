extends Node2D

var weaponList =Global.weaponList

var w1 = Global.w1
var w2 = Global.w2


var weaponSelect =[]

func _ready() -> void:
	refresh()

func refresh():
	w1 = Global.w1
	w2 = Global.w2
	weaponSelect=[]
	for i in weaponList:
		if not (i==w1 or i ==w2):
			weaponSelect.append(i)
	var wep1 = $weapon1/MenuButton/wOption1
	var wep2 = $weapon2/MenuButton/wOption1
	wep1.clear()
	wep2.clear()
	wep1.add_item(w1)
	wep2.add_item(w2)
	for i in weaponSelect:
		wep1.add_item(i)
		wep2.add_item(i)
