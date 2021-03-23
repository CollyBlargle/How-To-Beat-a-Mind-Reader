extends Path2D

const hidePosition := Vector2(1280, 1280)

var myName = "DefaultName"

var point
var rayCast
var sprite
var particles
var animationPlayer

const gridSize = 64
var pathOffset = 0
var moving = false

export var speed = 4.6
var direction
var directionBeforeCollision = Vector2.ZERO
var looking = "down"

func updatePosition():
	#A better way? Remember to test this later.
	if moving:
		var oldPosition = point.global_position
		yield(get_tree(), "idle_frame") #advance one frame to get new position 
		direction = point.global_position - oldPosition
		direction = direction.normalized()
		
		if not direction.x == 0:
			if direction.x > 0:
				looking = "left"
			else:
				looking = "right"
		elif not direction.y == 0:
			if direction.y > 0:
				looking = "up"
			else: 
				looking = "down"
		else:
			pass
		
		match looking:
			"left":
				 rayCast.cast_to = Vector2.LEFT * gridSize/2
			"right":
				rayCast.cast_to = Vector2.RIGHT * gridSize/2
			"up":
				 rayCast.cast_to = Vector2.UP * gridSize/2
			"down":
				 rayCast.cast_to = Vector2.DOWN * gridSize/2
		
		if rayCast.is_colliding():
			pass
		else:
			pathOffset += speed
			point.set_offset(pathOffset)
			if point.offset == 1:
				moving = false
		
		sprite.animation = looking + "Move"
	else:
		sprite.animation = looking + "Idle"
		if teleporting:
			position = hidePosition

var characterPath
var startPosition
var endPosition

var myMovement
var myLocation

var teleporting = false

func processNewPath(startingPosition, path):
	curve.clear_points()
	curve.add_point(startingPosition)
	for coordinate in path:
		curve.add_point(startingPosition + coordinate * gridSize)
	moving = true

func facePlayer(directionFacing):
	if (not moving):
		match directionFacing:
			"right":
				sprite.animation = "left" + "Idle"
			"left":
				sprite.animation = "right" + "Idle"
			"down":
				sprite.animation = "up" + "Idle"
			"up":
				sprite.animation = "down" + "Idle"
