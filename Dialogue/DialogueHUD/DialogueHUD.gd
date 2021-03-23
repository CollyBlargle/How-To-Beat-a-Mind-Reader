extends CanvasLayer

signal dialogueAdvancement

var dialogues := {}
var interactables := {}
var choicePresent := false
var printingText := false
var open := false

var dialoguesPath := "res://Dialogue/Dialogues.jscsrc"
var interactablesPath := "Interactables.jscsrc"
var location := "GamingClub"

func _ready():
	$DialoguePanel.hide()
	loadDialogues(dialoguesPath)
	loadInteractables(interactablesPath)

func _unhandled_input(event):
	if boxAnimating == false:
		if event.is_action_pressed("advance_dialogue"): #&& self.get_rect().has_point(get_global_mouse_position())):
			if (printingText):
				$DialoguePanel/Content.set_visible_characters(-1)
				printingText = false
				$DialoguePanel/Content/Timer.stop()
			else:
				if (choicePresent == false and open):
					print("advance dialogue")
					currentID += 1
					parseDialogues(actorScreenplay, currentID, dialoguePath)
					emit_signal("dialogueAdvancement")

#Loads a file and puts it into the "dialogues" variable
#https://itch.io/profile/insbilla
func loadDialogues(fname): 
	dialoguesPath = fname
	var file = File.new()
	if file.file_exists(dialoguesPath):
		file.open(dialoguesPath, file.READ)
		var jsonResult = parse_json(file.get_as_text())
		dialogues = jsonResult["Dialogues"]
	else:
		print("Dialogue: File Open Error")
	file.close()

func loadInteractables(fname): 
	interactablesPath = fname
	var file = File.new()
	if file.file_exists(interactablesPath):
		file.open(interactablesPath, file.READ)
		var jsonResult = parse_json(file.get_as_text())
		interactables = jsonResult["Interactables"]
	else:
		print("Interactables: File Open Error")
	file.close()

#Prints characters 1 by 1. Look at this later; seems like it prints letters.. jitterily
var textCount
func displayContent(text):
	$DialoguePanel/Content.set_bbcode(text)
	if (textSpeed != "instant"):
		textCount = 0
		$DialoguePanel/Content.set_visible_characters(0)
		while ($DialoguePanel/Content.get_visible_characters() < len(text)):
			printingText = true
			textCount += 1
			$DialoguePanel/Content/Timer.start()
			yield($DialoguePanel/Content/Timer, "timeout")
			$DialoguePanel/Content.set_visible_characters(textCount)
		printingText = false
		$DialoguePanel/Content/Timer.stop()

#If the text is clicked, advance dialogue
#func _on_Content_gui_input(_event):
#	if (Input.is_action_just_released("advance_dialogue")): ##&& self.get_rect().has_point(get_global_mouse_position())):
#		if (printingText):
#			$DialoguePanel/Content.set_visible_characters(-1)
#			printingText = false
#			$DialoguePanel/Content/Timer.stop()
#		else:
#			if (choicePresent == false):
#				currentID += 1
#				parseDialogues(actorScreenplay, currentID, dialoguePath)
#				emit_signal("dialogueAdvancement")

#Advances dialogue after a choice is made on the ChoiceButtons
var dialoguePath := "a"
func _on_ChoiceButtons_choiceMade(path):
	currentID += 1
	dialoguePath = path
	parseDialogues(actorScreenplay, currentID, dialoguePath)
	emit_signal("dialogueAdvancement")
	choicePresent = false

#Updates text speed based on settings
var textSpeed := "fast"
func _on_Settings_textSpeed(speed):
	match speed:
		"slow":
			textSpeed = speed
			$DialoguePanel/Content/Timer.set_wait_time(0.1)
		"medium":
			textSpeed = speed
			$DialoguePanel/Content/Timer.set_wait_time(0.05)
		"fast":
			textSpeed = speed
			$DialoguePanel/Content/Timer.set_wait_time(0.001)
		"instant":
			textSpeed = speed

var actorScreenplay := {}
var sceneNames :={
	"Maple": ["Awakening", "Title1", "Title2"],
	"Violet": ["Awakening", "Introduction", "Title2"],
	"Cauliflower": ["Introduction", "Title1", "Title2"]
}

var characterName
var content
var particles
var expression

const expressionDictionary ={
	"Maple":
	{
		"angry" : preload("res://Characters/Violet Portraits/Angry Violet.png"),
		"normal" : preload("res://Characters/Violet Portraits/Normal Violet.png"),
		"shocked" :  preload("res://Characters/Violet Portraits/Shocked Violet.png")
	},
	"Violet":
	{
		"angry" : preload("res://Characters/Violet Portraits/Angry Violet.png"),
		"normal" : preload("res://Characters/Violet Portraits/Normal Violet.png"),
		"shocked" :  preload("res://Characters/Violet Portraits/Shocked Violet.png")
	},
	"Forest":
	{
		"angry" : preload("res://Characters/Violet Portraits/Angry Violet.png"),
		"normal" : preload("res://Characters/Violet Portraits/Normal Violet.png"),
		"shocked" :  preload("res://Characters/Violet Portraits/Shocked Violet.png")
	},
	"Beret":
	{
		"angry" : preload("res://Characters/Violet Portraits/Angry Violet.png"),
		"normal" : preload("res://Characters/Violet Portraits/Normal Violet.png"),
		"shocked" :  preload("res://Characters/Violet Portraits/Shocked Violet.png")
	}
}

var animation
var movement
var choices
var advanceScene

var mapleScene := 0
var violetScene := 0
var cauliflowerScene := 0

var dialogueKey := "1a1"
var currentID := 1
var pathLength := 1

signal processScene
signal emote
signal movement
signal animation

var boxAnimating

func parseDialogues(screenplay, id, path):
	#First, receive dictionary of dialogue data
	if screenplay.has(str(id) + str(path) + str(pathLength)):
		dialogueKey = str(id) + str(path) + str(pathLength)
		pathLength += 1
	elif screenplay.has(str(id)):
		dialogueKey = str(id)
	elif not screenplay.has(str(id) + str(path) + str(pathLength)) and not screenplay.has(str(id)):
		print("reset")
		$DialoguePanel/AnimationPlayer.play_backwards("pop up")
		boxAnimating = true
		open = false
		yield($DialoguePanel/AnimationPlayer, "animation_finished")
		boxAnimating = false
		currentID = 1
		pathLength = 1
		get_tree().paused = false
		$DialoguePanel.hide()
	
	characterName = screenplay[dialogueKey]["name"]
	
	content = screenplay[dialogueKey]["content"]
	
	if (screenplay[dialogueKey].has("expression")):
		expression = screenplay[dialogueKey]["expression"]
	else:
		expression = ""
	
	if (screenplay[dialogueKey].has("animation")):
		animation = screenplay[dialogueKey]["animation"]
	else:
		animation = ""
	
	if (screenplay[dialogueKey].has("particles")):
		particles = screenplay[dialogueKey]["particles"]
	else:
		particles = ""
	
	if (screenplay[dialogueKey].has("movement")):
		movement = screenplay[dialogueKey]["movement"]
	else:
		movement = ""
	
	if (screenplay[dialogueKey].has("choices")):
		choices = screenplay[dialogueKey]["choices"]
	else:
		choices = []
	
	if (screenplay[dialogueKey].has("advanceScene")):
		advanceScene = screenplay[dialogueKey]["advanceScene"]
	else:
		advanceScene = ""
	
	#Second, send data to appropriate sections.
	if characterName == "customScene":
		emit_signal("processScene")
	else:
		$DialoguePanel/Name.set_text(characterName)
		if characterName == "Beret" or characterName == "Maple" or characterName == "Violet" or characterName == "Forest":
			$DialoguePanel/PortraitHolder.show()
			$DialoguePanel/PortraitHolder/Portrait.set_texture(expressionDictionary[characterName][expression])
		else:
			$DialoguePanel/PortraitHolder.hide()
	
	displayContent(content)
	
	if not animation.empty():
		emit_signal("animation", characterName, animation)
	
	if not particles.empty():
		emit_signal("emote", characterName, particles)
	
	if not choices.empty():
		$DialoguePanel/ChoiceButtons.showButtons(choices.size(), choices)
		choicePresent = true
	
	if movement and not content:
		currentID = 1
		pathLength = 1
		$DialoguePanel.hide()
		get_tree().paused = false
		emit_signal("movement", characterName, movement)
	elif movement and content:
		emit_signal("movement", characterName, movement)
	elif not movement:
		pass
	
	#if advance scene, then match name
	if not advanceScene.empty():
		match advanceScene:
			"Violet":
				violetScene += 1
			"Maple":
				mapleScene += 1
			"Cauliflower":
				cauliflowerScene += 1

func sendSaveData():
	SaveDataManager.currentSaveData["scenes"]["violetScene"] = violetScene
	SaveDataManager.currentSaveData["scenes"]["mapleScene"] = mapleScene
	SaveDataManager.currentSaveData["scenes"]["cauliflowerScene"] = cauliflowerScene
	SaveDataManager.currentSaveData["scenes"]["customScene"] = SaveDataManager.customScene

func receiveLoadData():
	violetScene = SaveDataManager.currentSaveData["scenes"]["violetScene"]
	mapleScene = SaveDataManager.currentSaveData["scenes"]["mapleScene"]
	cauliflowerScene = SaveDataManager.currentSaveData["scenes"]["cauliflowerScene"]
	SaveDataManager.customScene = SaveDataManager.currentSaveData["scenes"]["customScene"]
	
func _on_Player_initiateDialogue(name, _directionFacing):
	var sceneNumber
	var sceneName
	#If the thing you're talking to is a character, then send necessary character data
	if dialogues.has(name):
		sceneNumber = mapleScene
		sceneName = sceneNames[name][sceneNumber]
		actorScreenplay = dialogues[name][sceneName]
	#Otherwise send the interactables data
	else:
		actorScreenplay = interactables[location][str(name)]
	#If the "said" flag exists, and it's true, then instead take a different dialogue.
	if actorScreenplay.has("said"):
		if actorScreenplay["said"]:
			actorScreenplay = dialogues[name][sceneName + "2"]
		else:
			actorScreenplay["said"] = true
	parseDialogues(actorScreenplay, currentID, dialoguePath)
	$DialoguePanel.show()
	$DialoguePanel/AnimationPlayer.current_animation = "pop up"
	open = true
	boxAnimating = true
	yield($DialoguePanel/AnimationPlayer, "animation_finished")
	boxAnimating = false
	get_tree().paused = true

func _on_OOB_initiateDialogue(screenplay):
	parseDialogues(screenplay, currentID, null)
	$DialoguePanel.show()
	$DialoguePanel/AnimationPlayer.current_animation = "pop up"
	open = true
	boxAnimating = true
	yield($DialoguePanel/AnimationPlayer, "animation_finished")
	boxAnimating = false
	get_tree().paused = true
