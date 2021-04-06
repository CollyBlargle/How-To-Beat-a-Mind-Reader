extends Area2D
class_name NPC

export (String) var dialogueName

onready var player = get_parent().get_node("Player")
onready var sprite = get_node("Sprite")

func _ready():
	player.connect("initiate_dialogue", self, "_on_Player_initiate_dialogue")

func _on_Player_initiate_dialogue(dialogue, directionFacing):
	if dialogue == dialogueName:
		match directionFacing:
			Vector2(32, 0):
				sprite.animation = "idle_left"
			Vector2(-32, 0):
				sprite.animation = "idle_right"
			Vector2(0, 32):
				sprite.animation = "idle_up"
			Vector2(0, -32):
				sprite.animation = "idle_down"
			_:
				print("Raycast is longer/shorter than expected. See NPC script.")
