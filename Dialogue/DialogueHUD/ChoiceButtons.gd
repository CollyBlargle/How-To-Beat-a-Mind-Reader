extends Control
var dialoguePath = "a" #doesn't matter why it's a, i just need something other than nil in the beginning
signal choiceMade
var decisionsMade := {}
var choiceCounter := 0
var branchingDialogue := {"Name": "", "Content": "", "Choices": ""}

func _ready():
	hideButtons()

func hideButtons():
	$ChoiceButton1.hide()
	$ChoiceButton2.hide()
	$ChoiceButton3.hide()
	$ChoiceButton4.hide()

func showButtons(amount, buttonText):
	var buttonList = [$ChoiceButton1, $ChoiceButton2, $ChoiceButton3, $ChoiceButton4]
	var count = 0
	while amount > count:
		buttonList[count].show()
		buttonList[count].set_text(buttonText[count])
		count += 1

#Store decisions in a dictionary
func _on_ChoiceButton1_pressed():
	dialoguePath = "a" #used to concatenate to currentID in DialogueHUD
	emit_signal("choiceMade", dialoguePath)
	print(decisionsMade)
	choiceCounter += 1
	hideButtons()

func _on_ChoiceButton2_pressed():
	dialoguePath = "b"
	emit_signal("choiceMade", dialoguePath)
	print(decisionsMade)
	choiceCounter += 1
	hideButtons()

func _on_ChoiceButton3_pressed():
	dialoguePath = "c"
	emit_signal("choiceMade", dialoguePath)
	print(decisionsMade)
	choiceCounter += 1
	hideButtons()

func _on_ChoiceButton4_pressed():
	dialoguePath = "d"
	emit_signal("choiceMade", dialoguePath)
	choiceCounter += 1
	hideButtons()
