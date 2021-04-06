extends Node

class_name Map

onready var player = get_node("Player")
onready var dialogueUI = get_node("DialogueUI")

func _ready():
	player.connect("initiate_dialogue", dialogueUI, "_on_Player_initiate_dialogue")
