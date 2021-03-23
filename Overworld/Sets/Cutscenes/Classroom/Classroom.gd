extends "res://Sets/Cutscenes/Cutscene.gd"

func _ready():
	expressionDictionary = {
		"angry" : preload("res://Characters/Violet Portraits/Angry Violet.png"),
		"normal" : preload("res://Characters/Violet Portraits/Normal Violet.png"),
		"shocked" :  preload("res://Characters/Violet Portraits/Shocked Violet.png")
	}
	
	dialogues = {
		1:
		{
			"name": "Beret",
			"content": "I love eating food. I love eating food. I love eating food. I love eating food. I love eating food. I love eating food. I love eating food. I love eating food. I love eating food. ",
			"expression": "normal",
		},
		2:
		{
			"name": "Beret",
			"content": "I'm having a lot of fun.",
			"expression": "angry",
		},
		3:
		{
			"name": "Beret",
			"content": "Programming is so easy,",
			"expression": "shocked",
		}
	}
	
	dialoguePanel = get_node("DialogueHUD/DialoguePanel")
	panelAnimator = get_node("DialogueHUD/DialoguePanel/AnimationPlayer")
	content = get_node("DialogueHUD/DialoguePanel/Content")
	timer = get_node("DialogueHUD/DialoguePanel/Content/Timer")
	myName = get_node("DialogueHUD/DialoguePanel/Name")
	camera = get_node("Camera2D")
	setUp()

func _process(_delta):
	if Input.is_action_just_pressed("advance_dialogue") and printingText:
		printingText = false
		content.set_visible_characters(-1)
		timer.stop()
	elif Input.is_action_just_pressed("advance_dialogue") and printingText == false:
		advanceDialogue()
