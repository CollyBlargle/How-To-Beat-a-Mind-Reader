extends Area2D

export (int) var speed = 256
var tileSize = 64

var lastPosition = Vector2()
var targetPosition = Vector2()
var moveDirection = Vector2()

onready var rayCast = get_node("RayCast2D")

func _ready():
	position = position.snapped(Vector2(tileSize, tileSize))
	lastPosition = position
	targetPosition = position

func _process(delta):
	if rayCast.is_colliding():
		position = lastPosition
		targetPosition = lastPosition
	else:
		position += moveDirection * speed * delta
		#if moved more than 64 pixels, snap back to target position
		if position.distance_to(lastPosition) >= tileSize - speed * delta:
			position = targetPosition
	
	if position == targetPosition:
		get_moveDirection()
		lastPosition = position
		targetPosition += moveDirection * tileSize

var LEFT = false
var RIGHT = false
var UP = false
var DOWN = false
func _unhandled_input(event):
	LEFT = Input.is_action_pressed("move_left")
	RIGHT = Input.is_action_pressed("move_right")
	UP = Input.is_action_pressed("move_up")
	DOWN = Input.is_action_pressed("move_down")
	if event.is_action_pressed("interact"):
		check_for_interactables()
		#If left is being pressed, move direction will be negative.
		#If right is being pressed as well, move direction will cancel out.

func get_moveDirection():
	moveDirection.x = -int(LEFT) + int(RIGHT)
	moveDirection.y = -int(UP) + int(DOWN)
	
	if not moveDirection.x == 0 and not moveDirection.y == 0:
		moveDirection = Vector2.ZERO
	
	if not moveDirection == Vector2.ZERO:
		rayCast.cast_to = moveDirection * tileSize / 2

signal initiate_dialogue(dialogueName)
var collisionLayer
func check_for_interactables():
	if not $RayCast2D.get_collider() == null:
		collisionLayer = $RayCast2D.get_collider().get_collision_layer()
		match collisionLayer:
			#NPCs
			2:
				var dialogueName = $RayCast2D.get_collider().dialogueName
				emit_signal("initiate_dialogue", dialogueName, rayCast.cast_to)
			#Items
			4:
				pass
#func get_moveDirection():
#	var LEFT = Input.is_action_pressed("move_left")
#	var RIGHT = Input.is_action_pressed("move_right")
#	var UP = Input.is_action_pressed("move_up")
#	var DOWN = Input.is_action_pressed("move_down")
#	#If left is being pressed, move direction will be negative.
#	#If right is being pressed as well, move direction will cancel out.
#	moveDirection.x = -int(LEFT) + int(RIGHT)
#	moveDirection.y = -int(UP) + int(DOWN)
#
#	if moveDirection.x != 0 and moveDirection.y != 0:
#		moveDirection = Vector2.ZERO
#
#	if moveDirection != Vector2.ZERO:
#		$RayCast2D.cast_to = moveDirection * tileSize/2








#https://www.youtube.com/watch?v=JtnnKVxoH5k&t=25s
#export (int) var speed := 256 * 5
#const tileSize := 64
#
#var lastPosition := Vector2()
#var targetPosition := Vector2()
#var moveDirection := Vector2()
#var directionFacing = "down"
#
#var teleporting := false
#
#func _ready():
#	position = position.snapped(Vector2(tileSize, tileSize))
#	lastPosition = position
#	targetPosition = position
#
#func _process(delta):
#	if $RayCast2D.is_colliding():
#		position = lastPosition
#		targetPosition = lastPosition
#	else:
#		position += speed * moveDirection * delta
#		#if moved more than 64 pixels, snap back to target position
#		if position.distance_to(lastPosition) >= tileSize - speed * delta:
#			position = targetPosition
#	#IDLE
#	if position == targetPosition:
#		get_move_direction()
#		lastPosition = position
#		targetPosition += moveDirection * tileSize
#
#	match moveDirection:
#		Vector2(-1, 0):
#			directionFacing = "left"
#		Vector2(1, 0):
#			directionFacing = "right"
#		Vector2(0, -1):
#			directionFacing = "up"
#		Vector2(0, 1):
#			directionFacing = "down"
#
			
#func collisionChecks():
#	if not $RayCast2D.get_collider() == null:
#		collisionLayer = $RayCast2D.get_collider().get_collision_layer()
#	match collisionLayer:
#		#NPCs
#		2:
#			if Input.is_action_just_pressed("interact"):
#				var dialogueName = $RayCast2D.get_collider().dialogueName
#				emit_signal("initiate_dialogue", dialogueName)
#		#Items
#		4:
#			pass
#		#Interactables
#		8:
#			if Input.is_action_just_pressed("interact"):
#				var interactable = $RayCast2D.get_collider().get_name()
#				emit_signal("initiate_dialogue", interactable, "")
#				set_process_unhandled_input(false)
#		#Tilemap
#		16:
#			pass
#		#Teleporter
#		32:
#			var teleporter = $RayCast2D.get_collider().get_name()
#			if not teleporting:
#				emit_signal("teleport", teleporter)
#			teleporting = true
#		#Touch Triggers
#		64:
#			#For some reason, the string "root_canvas135" is in my groups.
#			#Remember to remove it before sending which trigger.#			var touchTriggers = $RayCast2D.get_collider().get_groups()
#			pass
#
#func get_move_direction():
#	var LEFT = Input.is_action_pressed("move_left")
#	var RIGHT = Input.is_action_pressed("move_right")
#	var UP = Input.is_action_pressed("move_up")
#	var DOWN = Input.is_action_pressed("move_down")
#	#If left is being pressed, move direction will be negative.
#	#If right is being pressed as well, move direction will cancel out.
#	moveDirection.x = -int(LEFT) + int(RIGHT)
#	moveDirection.y = -int(UP) + int(DOWN)
#
#	if moveDirection.x != 0 and moveDirection.y != 0:
#		moveDirection = Vector2.ZERO
#
#	if moveDirection != Vector2.ZERO:
#		$RayCast2D.cast_to = moveDirection * tileSize / 2
