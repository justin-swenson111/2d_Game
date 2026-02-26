extends OptionButton


func _on_item_selected(i: int) -> void:
	Global.w1=self.get_item_text(i)
	self.clear()
	self.owner.wepRefresh()
