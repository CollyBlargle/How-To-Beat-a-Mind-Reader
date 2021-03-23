extends Camera2D
#This camera is reliant on knowing the window size. ATM, it is (1024, 600).
#If this changes, remember to change the offset in the camera function to
#the window size divided by 2
var gridSize = Vector2()
var gridPosition = Vector2()

func _ready():
	gridSize = Vector2(1024, 640)
	set_as_toplevel(true)
	updateGridPosition()

func _physics_process(_delta):
	updateGridPosition()

#we need to change position 
func updateGridPosition():
	var x = floor(get_parent().position.x / gridSize.x)
	var y = floor(get_parent().position.y / gridSize.y)
	var newGridPosition = Vector2(x, y)
	if not gridPosition == newGridPosition:
		gridPosition = newGridPosition
		position = gridPosition * gridSize
