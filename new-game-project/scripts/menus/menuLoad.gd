extends Node2D

var weaponList =Global.weaponList

var w1 = Global.w1
var w2 = Global.w2

var inventory = Global.inventory
var itemList = Global.items

var weaponSelect =[]

func _ready() -> void:
	wepRefresh()
	itemRefresh()


func wepRefresh():
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

func itemRefresh():
	for i in inventory:
		var itm= preload("res://objects/item.tscn")
		var item=itm.instantiate()
		item.get_child(0).name=i
		item.texture=load(itemList[i][1])
		$inventory.add_child(item)
	var child = $inventory.get_children()
	for i in range(child.size()):
		if child[i] is Sprite2D:
			child[i].position.x=-125+35*i
	
