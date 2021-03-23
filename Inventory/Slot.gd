extends CenterContainer

var inventory = preload("res://Inventory/Inventory.tres")

onready var itemTextureRect = $TextureRect
onready var description = $Description
onready var descriptionTimer = $Description/Timer

func _ready():
	description.hide()

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = load("res://Inventory/Items/ItemTextures/Empty.png")

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		return data

func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")

func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	inventory.swap_items(my_item_index, data.item_index)
	inventory.set_item(my_item_index, data.item)
	inventory.drag_data = null

func _on_SlotDisplay_mouse_entered():
	descriptionTimer.start()
	yield(descriptionTimer, "timeout")
	description.show()

func _on_SlotDisplay_mouse_exited():
	descriptionTimer.stop()
	description.hide()
