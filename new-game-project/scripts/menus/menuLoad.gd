extends Node2D

var weaponList =Global.weaponList

var w1 = Global.w1
var w2 = Global.w2

var inventory = Global.inventory
var itemList = Global.items

var weaponSelect =[]

func _ready() -> void:
	self.z_index=10
	wepRefresh()
	itemRefresh()
	artiRefresh()
	magRefresh()
	


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

func artiRefresh():
	var artifact=$artifact/MenuButton/wOption1
	Global.collArtifacts.sort()
	artifact.clear()
	artifact.add_item(Global.curArtifact)
	var items=Global.collArtifacts.duplicate()
	var pos = items.find(Global.curArtifact)
	items.remove_at(pos)
	for i in items:
		#if i!=Global.curArtifact or !first:
			artifact.add_item(i)
	
func magRefresh():
	var mag = $magWeapon/MenuButton/wOption1
	mag.clear()
	var l = Global.magWeaponList.duplicate()
	var pos = l.find_key(Global.curMagWeapon)
	if Global.curMagWeapon in l:
		l.erase(Global.curMagWeapon)
	mag.add_item(Global.curMagWeapon)
	for i in l:
		mag.add_item(i)
	

func itemRefresh():
	for i in inventory:
		var itm= preload("res://objects/worldItems/item.tscn")
		var item=itm.instantiate()
		item.get_child(0).name=i
		item.texture=load(itemList[i][1])
		$inventory.add_child(item)
	var child = $inventory.get_children()
	for i in range(child.size()):
		if child[i] is Sprite2D:
			child[i].position.x=-125+35*i
	
