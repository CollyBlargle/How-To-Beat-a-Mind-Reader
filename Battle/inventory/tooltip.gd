extends Node2D

var description = ""

func _ready():
	$Label.hide()

func show_tooltip():
	$Label.text = description
	$Label.show()

func hide_tooltip():
	$Label.hide()
