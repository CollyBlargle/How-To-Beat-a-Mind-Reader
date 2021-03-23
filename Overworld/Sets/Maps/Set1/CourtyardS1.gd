extends Node

signal change_set

const schoolResource = "res://Overworld/Sets/Maps/Set1/S1School.tscn"

onready var spawnPosition = Vector2(-1024, 832)
var location
var currentPath

var teleportDictionary :={
	"CourtyardTeleporter2":
	{
		"location": schoolResource,
		"spawnPosition": Vector2(512, 384)
	},
}

const outOfBoundsDialogue ={
	"CourtyardOOBR":
	{
		"1":
		{
			"name": "Asher",
			"content": "Somehow I managed to go past my school."
		},
	}
}
func _ready():
	$Player/Camera2D.gridPosition = Vector2(-1, 1)

func _on_Player_teleport(teleporter):
	location = teleportDictionary[teleporter]["location"]
	spawnPosition = teleportDictionary[teleporter]["spawnPosition"]
	currentPath = get_path()
	emit_signal("change_set", currentPath, location, spawnPosition)

signal initiateDialogue
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
	emit_signal("initiateDialogue", outOfBoundsDialogue[triggerName])
