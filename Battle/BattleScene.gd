extends Node

func _ready():
	initialize_scene()

func initialize_scene():
	$CinematicAspectRatio/AnimationPlayer.current_animation = "Squeeze"
