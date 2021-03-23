extends Node
const filePath = "res://Saves/SaveData.jscsrc"

var scene = 0
var currentSaveFile = 1

var saveData :={
	"File 1": {},
	"File 2": {},
	"File 3": {}
}

var savedMain

var currentSaveData := {
	"position":
	{
		"location": "Courtyard",
		"x": 0,
		"y": 0
	},
	"dialogueInfo":
	{
		"id": 1,
		"choices": [],
	},
	"settings": 
	{
		"sfx" : 1.0,
		"music": 1.0,
		"textSpeed": "fast"
	},
	"scene": 1
}

func saveFile(fileNumber):
	var saveLoadNodes = get_tree().get_nodes_in_group("SaveLoad")
	for node in saveLoadNodes:
		get_tree().call_group("SaveLoad", "sendSaveData")
	var file = File.new()
	if file.file_exists(filePath):
		file.open(filePath, File.WRITE)
		saveData["File " + str(fileNumber)] = currentSaveData
		file.store_string(to_json(saveData))
		file.close()
	print(currentSaveData)

func loadFile(fileNumber):
	var saveLoadNodes = get_tree().get_nodes_in_group("SaveLoad")
	
	var file = File.new()
	if file.file_exists(filePath):
		file.open(filePath, File.READ)
		saveData = parse_json(file.get_as_text())
		currentSaveData = saveData["File " + str(fileNumber)]
	
	for node in saveLoadNodes:
		get_tree().call_group("SaveLoad", "receiveLoadData")
