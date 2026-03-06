extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if self.is_in_group("item"):
			addItem(body)
		else:
			addWeapon(body)
		self.get_parent().queue_free()
		
func addWeapon(player:Node2D):
	for i in Global.allWeapons:
		if self.name==i:
			player.weaponList[i]=Global.allWeapons[i]
			Global.weaponList[i]=Global.allWeapons[i]
			
	
func addItem(player:Node2D):
	for i in Global.items:
		if self.name==i:
			Global.inventory.append(i)
	if Global.inventory.size()==1:
		var sprite = load(Global.items[self.name][1])
		player.curItem=self.name
		player.find_child("currentItem").texture=sprite
