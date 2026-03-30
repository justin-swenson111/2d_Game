extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if self.is_in_group("item"):
			addItem(body)
		elif self.is_in_group("weapon"):
			addWeapon(body)
		elif self.is_in_group("artifact"):
			addArtifact(body)
		elif self.is_in_group("magWeap"):
			addMag(body)
		self.get_parent().queue_free()
		
func addWeapon(player:Node2D):
	print(self.name)
	for i in Global.allWeapons:
		if self.name==i:
			player.weaponList[i]=Global.allWeapons[i]
			Global.weaponList[i]=Global.allWeapons[i]
			
func addArtifact(player:Node2D):
	for i in Global.artifacts:
		if self.name==i:
			Global.collArtifacts.append(i)
	if Global.collArtifacts.size()==1:
		Global.curArtifact=self.name
		player.curArtifact=self.name

func addItem(player:Node2D):
	for i in Global.items:
		if self.name==i:
			Global.inventory.append(i)
	if Global.inventory.size()==1:
		var sprite = load(Global.items[self.name][1])
		player.curItem=self.name
		player.find_child("currentItem").texture=sprite

func addMag(player:Node2D):
	for i in Global.allMagWeapons:
		if self.name==i:
			Global.magWeaponList[i]=Global.allMagWeapons[i]
			player.magWeaponList[i]=Global.allMagWeapons[i]
	if Global.magWeaponList.size()==1:
		player.curMagWeapon=self.name
		Global.curMagWeapon=self.name
