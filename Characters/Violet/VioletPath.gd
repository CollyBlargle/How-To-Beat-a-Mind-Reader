extends "res://Characters/CharacterPath.gd"

func _ready():
	myName = "Violet"
	point = get_node("VioletPoint")
	rayCast = get_node("VioletPoint/Violet/RayCast2D")
	sprite = get_node("VioletPoint/Violet/VioletSprite")
	particles = get_node("VioletPoint/Violet/Particles")
	animationPlayer = get_node("VioletPoint/Violet/VioletSprite/AnimationPlayer")
	##Get position of savedPosition or something

func _on_Player_initiateDialogue(name, directionFacing):
	if name == myName:
		facePlayer(directionFacing)

func _process(_delta):
	#A better way? Remember to test this later.
	updatePosition()

func _on_DialogueHUD_movement(name, movement):
	myMovement = movement
	if PathDictionary.violetData[myMovement].has(myLocation + "2"):
		teleporting = true
	else:
		teleporting = false
	myLocation = PathDictionary.violetData[movement]["location"]
	if name == myName:
		characterPath = PathDictionary.violetData[movement]["path"]
		startPosition = PathDictionary.violetData[movement]["startPosition"]
		endPosition = PathDictionary.violetData[movement]["endPosition"]
		processNewPath(startPosition, characterPath)
		moving = true

func _on_DialogueHUD_emote(name, emote):
	if name == myName:
		particles.animation = emote

func _on_DialogueHUD_animation(name, animation):
	if name == myName:
		animationPlayer.play(animation)

func _on_Main_newLocation(location):
	if teleporting:
		if location == PathDictionary.violetData[myMovement][myLocation + "2"]:
			processNewPath(PathDictionary.violetData[myMovement][myLocation + "2"]["startPosition"], PathDictionary.violetData[myMovement][myLocation + "2"]["characterPath"])
		else:
			position = hidePosition
	else:
		if myLocation == location:
			position = PathDictionary.violetData[myMovement][myLocation]["endPosition"]
		else:
			position = hidePosition

