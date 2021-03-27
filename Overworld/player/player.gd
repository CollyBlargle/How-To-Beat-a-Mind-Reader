extends Area2D

#https://www.youtube.com/watch?v=JtnnKVxoH5k&t=25s
#const speed := 256
var speed := 256 * 5
const tileSize := 64

var lastPosition := Vector2()
var targetPosition := Vector2()
var moveDirection := Vector2()
var directionFacing

var teleporting := false

func _ready():
	position = position.snapped(Vector2(tileSize, tileSize))
	lastPosition = position
	targetPosition = position

func _process(delta):
	if $RayCast2D.is_colliding():
		position = lastPosition
		targetPosition = lastPosition
		collisionChecks()
	else:
		if not teleporting:
			position += speed * moveDirection * delta
			#if moved more than 64 pixels, snap back to target position
			if position.distance_to(lastPosition) >= tileSize - speed * delta:
				position = targetPosition
	#IDLE
	if position == targetPosition:
		getMoveDirection()
		lastPosition = position
		targetPosition += moveDirection * tileSize
	
	match moveDirection:
		Vector2(-1, 0):
			directionFacing = "left"
		Vector2(1, 0):
			directionFacing = "right"
		Vector2(0, -1):
			directionFacing = "up"
		Vector2(0, 1):
			directionFacing = "down"

signal teleport
signal initiateDialogue
signal touchTrigger

var collisionLayer
func collisionChecks():
	if not $RayCast2D.get_collider() == null:
		collisionLayer = $RayCast2D.get_collider().get_collision_layer()
	match collisionLayer:
		#NPCs
		2:
			if Input.is_action_just_pressed("advance_dialogue"):
				var name = $RayCast2D.get_collider().get_name()
				match name:
					"Violet":
						var violetPath = get_parent().get_node("VioletPath")
						if not violetPath.moving:
							show()
							emit_signal("initiateDialogue", name, directionFacing)
					"Maple":
						var maplePath = get_parent().get_node("MaplePath")
						if not maplePath.moving:
							show()
							emit_signal("initiateDialogue", name, directionFacing)
					"Cauliflower":
						pass
		#Items
		4:
			pass
		#Interactables
		8:
			if Input.is_action_just_pressed("advance_dialogue"):
				var interactable = $RayCast2D.get_collider().get_name()
				emit_signal("initiateDialogue", interactable, "")
				set_process_unhandled_input(false)
		#Tilemap
		16:
			pass
		#Teleporter
		32:
			var teleporter = $RayCast2D.get_collider().get_name()
			if not teleporting:
				emit_signal("teleport", teleporter)
			teleporting = true
		#Touch Triggers
		64:
			#For some reason, the string "root_canvas135" is in my groups.
			#Remember to remove it before sending which trigger.
			var touchTriggers = $RayCast2D.get_collider().get_groups()
			touchTriggers.erase("root_canvas135")
			var touchTriggerType = touchTriggers[0]
			var touchTriggerName = $RayCast2D.get_collider().get_name()
			emit_signal("touchTrigger", touchTriggerType, touchTriggerName)

func getMoveDirection():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	#If left is being pressed, move direction will be negative.
	#If right is being pressed as well, move direction will cancel out.
	moveDirection.x = -int(LEFT) + int(RIGHT)
	moveDirection.y = -int(UP) + int(DOWN)
	
	if moveDirection.x != 0 and moveDirection.y != 0:
		moveDirection = Vector2.ZERO
	
	if moveDirection != Vector2.ZERO:
		$RayCast2D.cast_to = moveDirection * tileSize / 2

func sendSaveData():
	position = position.snapped(Vector2(tileSize, tileSize))
	SaveDataManager.currentSaveData["position"]["x"] = position.x
	SaveDataManager.currentSaveData["position"]["y"] = position.y

func receiveLoadData():
	position = Vector2(SaveDataManager.currentSaveData["position"]["x"], SaveDataManager.currentSaveData["position"]["y"])
	lastPosition = position
	targetPosition = position
