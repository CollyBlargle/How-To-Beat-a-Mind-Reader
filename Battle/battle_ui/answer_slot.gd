extends CenterContainer

var inventory = preload("res://Battle/Inventory/Inventory.tres")

onready var itemTextureRect = $TextureRect

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	itemTextureRect.texture = data["item"].texture
	print(data["item"].name)
#	var my_item_index = get_index()
#	var my_item = inventory.items[my_item_index]
#	inventory.swap_items(my_item_index, data.item_index)
#	inventory.set_item(my_item_index, data.item)
#	inventory.drag_data = null
