extends "res://Characters/CharacterPath.gd"

func _ready():
	myName = "Maple"
	point = get_node("MaplePoint")
	rayCast = get_node("MaplePoint/Maple/RayCast2D")
	sprite = get_node("MaplePoint/Maple/MapleSprite")
	particles = get_node("MaplePoint/Maple/Particles")
	animationPlayer = get_node("MaplePoint/Maple/MapleSprite/AnimationPlayer")
	##Get position of savedPosition or something

func _on_Player_initiateDialogue(name, directionFacing):
	if name == myName:
		facePlayer(directionFacing)

func _process(_delta):
	#A better way? Remember to test this later.
	updatePosition()

func _on_DialogueHUD_movement(name, movement):
	myMovement = movement
	if PathDictionary.mapleData[myMovement].has(myLocation + "2"):
		teleporting = true
	else:
		teleporting = false
	myLocation = PathDictionary.mapleData[movement]["location"]
	if name == myName:
		characterPath = PathDictionary.mapleData[movement]["path"]
		startPosition = PathDictionary.mapleData[movement]["startPosition"]
		endPosition = PathDictionary.mapleData[movement]["endPosition"]
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
		if location == PathDictionary.mapleData[myMovement][myLocation + "2"]:
			processNewPath(PathDictionary.mapleData[myMovement][myLocation + "2"]["startPosition"], PathDictionary.violetData[myMovement][myLocation + "2"]["characterPath"])
		else:
			position = hidePosition
	else:
		if myLocation == location:
			position = PathDictionary.mapletData[myMovement][myLocation]["endPosition"]
		else:
			position = hidePosition

