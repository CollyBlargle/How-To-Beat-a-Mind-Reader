extends Node

enum {
	ARG_INT,
	ARG_STRING,
	ARG_BOOL,
	ARG_FLOAT
}
const valid_commands = [
	["set_speed", [ARG_INT]],
	["get_save_dictionary", []],
	["help", []]
	]

onready var player = get_tree().get_root().get_node("Main/Player")
onready var main = get_tree().get_root().get_node("Main")

func help():
	return str("set_speed(INT), get_save_dictionary(), help()")

func set_speed(speed):
	player.speed = speed
	return str("Successfully entered command set_speed ", speed)

func get_save_dictionary():
	return SaveDataManager.currentSaveData
