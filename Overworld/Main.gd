extends Node

#const setResources := {
#	0: preload("res://Sets/Cutscenes/WalkSchool/WalkSchool.tscn"),
#	1: preload("res://Sets/Maps/Scene1/Scene1.tscn"),
#	2: preload("res://Sets/Cutscenes/Classroom/Classroom.tscn"),
#	3: preload("res://Sets/Cutscenes/WalkHome/WalkHome.tscn")
#}

#var setNumber = 0
#onready var setResource = setResources[0]
#onready var newSet = setResource.instance()

onready var transitionLayer = get_node("TransitionLayer/Fade")
onready var firstSet = "res://Overworld/Sets/Cutscenes/S0WalkSchool/WalkSchool.tscn"

func _ready():
	receiveLoadData()
	initializeSet(firstSet, null)

func receiveLoadData():
#	setResource = setResources[SaveDataManager.scene]
#	newSet = setResource.instance()
#	add_child(newSet)
	pass

func sendSaveData():
	pass
#	setNumber = setResource.setNumber

func initializeSet(setReference, startPosition):
	var newSetResource = load(setReference)
	var newSet = newSetResource.instance()
	add_child(newSet)
	transitionLayer.current_animation = "fade in"
	newSet.connect("change_set", self, "_on_Set_change_set")
	if not startPosition == null:
		var player = newSet.find_node("Player")
		player.position = startPosition
		player.teleporting = false

func _on_Set_change_set(currentSetReference, newSetReference, startPosition):
	transitionLayer.current_animation = "fade out"
	yield(transitionLayer, "animation_finished")
	get_node(currentSetReference).queue_free()
	initializeSet(newSetReference, startPosition)
