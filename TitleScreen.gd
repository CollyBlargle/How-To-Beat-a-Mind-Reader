extends Node

const mainScenePath = "res://Main.tscn"
onready var mainSceneResource = preload(mainScenePath)
onready var mainScene = mainSceneResource.instance()

func _on_NewGame_pressed():
	get_tree().change_scene(mainScenePath)
