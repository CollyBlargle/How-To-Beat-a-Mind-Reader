extends Node

signal change_set

const schoolResource = "res://Overworld/Sets/Maps/Set1/S1Courtyard.tscn"

const outOfBoundsDialogue ={
	"SchoolOOBL1":
	{
		"1":
		{
			"name": "Asher",
			"content": "Isn't this the way to the 0-99 rooms..?"
		},
		"2":
		{
			"name": "Asher",
			"content": "I'm supposed to be in room 201, right?"
		}
	},
	"SchoolOOBL2":
	{
		"1":
		{
			"name": "Asher",
			"content": "Isn't this the way to the 0-99 rooms..?"
		},
		"2":
		{
			"name": "Asher",
			"content": "I'm supposed to be in room 201, right?"
		}
	},
	"OutOfBoundsRight":
	{
		"1":
		{
			"name": "Asher",
			"content": "I am [b]not[/b] going into the wrong class."
		},
		"2":
		{
			"name": "Asher",
			"content": "Not again.."
		},
		"3":
		{
			"name": "Asher",
			"content": "..Not again."
		},
	}
}
onready var spawnPosition = Vector2(448, 384)
var location
var currentPath

var teleportDictionary :={
	"SchoolTeleporter":
	{
		"location": schoolResource,
		"spawnPosition": Vector2(448, -320)
	},
}
func _ready():
	$Player/Camera2D.position = Vector2(0, 0)

func _on_Player_teleport(teleporter):
	location = teleportDictionary[teleporter]["location"]
	spawnPosition = teleportDictionary[teleporter]["spawnPosition"]
	currentPath = get_path()
	emit_signal("change_set", currentPath, location, spawnPosition)

func _on_Player_touchTrigger(triggerType, triggerName):
	match triggerType:
		"OutOfBoundsRight":
			$Player.targetPosition = $Player.position + Vector2(-64, 0)
			$Player/RayCast2D.cast_to = Vector2(-32, 0)
			$Player.moveDirection = Vector2(-1, 0)
		"OutOfBoundsLeft":
			$Player.targetPosition = $Player.position + Vector2(64, 0)
			$Player/RayCast2D.cast_to = Vector2(32, 0)
			$Player.moveDirection = Vector2(1, 0)
	$DialogueHUD.parseDialogues(outOfBoundsDialogue[triggerName], 1, null)
