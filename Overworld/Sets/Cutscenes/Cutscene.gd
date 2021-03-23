extends Node2D

var nextSet

var expressionDictionary := {}
var dialogues := {}

var dialoguePanel
var content
var timer
var myName
var panelAnimator
var camera
var startPosition

signal change_set

func setUp():
	dialoguePanel.hide()
	camera.current = true
	timer.start()
	yield(timer, "timeout")
	dialoguePanel.show()
	panelAnimator.current_animation = "pop up"

var dialogueID = 0
var changedSet = false
func advanceDialogue():
	dialogueID += 1
	if dialogues.has(dialogueID):
		myName.text = dialogues[dialogueID]["name"]
		displayContent(dialogues[dialogueID]["content"])
	else:
		if not changedSet:
			emit_signal("change_set", self.get_path(), nextSet, startPosition)
			changedSet = true

var count = 0
var printingText = false

func displayContent(text):
	count = 0
	content.set_visible_characters(count)
	printingText = true
	content.set_bbcode(text)
	timer.start()
	while (content.get_visible_characters() < len(text)):
		printingText = true
		count += 1
		timer.start()
		yield(timer, "timeout")
		content.set_visible_characters(count)
	printingText = false
	count = 0 
	timer.stop()

