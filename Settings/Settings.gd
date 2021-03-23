extends CanvasLayer
var onMusicOne := true
var musicOne
var musicTwo
var menuIsOpen := false
var saving := false

func _input(event):
	if (event.is_action_pressed("open_menu")):
			if (menuIsOpen == false):
				$Menu.popup()
				menuIsOpen = true
			else:
				$Menu.hide()

func _on_Menu_popup_hide():
	saving = false
	$SaveLoadMenu.hide()

func _on_Menu_hide():
	menuIsOpen = false

func _on_MusicSlider_value_changed(value):
	$Music.set_volume_db(linear2db(value))

func _on_SaveButton_pressed():
	$SaveLoadMenu/MenuMargin/ScrollContainer.set_v_scroll(0)
	$SaveLoadMenu/MenuMargin/ScrollContainer/SaveFileButtons/SaveLoadLabel.set_text("Save")
	$SaveLoadMenu.popup()
	saving = true

func _on_LoadButton_pressed():
	$SaveLoadMenu/MenuMargin/ScrollContainer.set_v_scroll(0)
	$SaveLoadMenu/MenuMargin/ScrollContainer/SaveFileButtons/SaveLoadLabel.set_text("Load")
	$SaveLoadMenu.popup()
	saving = false

func _on_SaveFileButton1_pressed():
	if saving:
		SaveDataManager.saveFile(SaveDataManager.currentSaveFile)
	else:
		SaveDataManager.loadFile(SaveDataManager.currentSaveFile)

#var buttonCount = 1
#func makeButton():
#	var button = Button.new()
#	$SaveLoadMenu/MenuMargin/ScrollContainer/SaveFileButtons.add_child(button)
#	button.set_name("SaveFileButton" + str(buttonCount))
#	button.set_text("File " + str(buttonCount))
#	button.set_text_align(button.ALIGN_LEFT)
#	button.connect("pressed", self, "_on_SaveFileButton_pressed")

#FILENUMBER VS BUTTONCOUNT PLEASE FIX I'M CRYING
#signal sendData
#func _on_SaveFileButton_pressed():
#	if (saving):
#		saveFile(buttonCount)
#		print("saving...")
#		if (SaveDataManager.saveData["File " + str(buttonCount)] == emptySaveData):
#			makeButton()
#	else:
#		loadFile(buttonCount)

signal textSpeed()
var textSpeed = "fast"
func _on_CheckBox_button_down():
	textSpeed = "slow"
	emit_signal("textSpeed", textSpeed)

func _on_CheckBox2_button_down():
	textSpeed = "medium"
	emit_signal("textSpeed", textSpeed)

func _on_CheckBox3_button_down():
	textSpeed = "fast"
	emit_signal("textSpeed", textSpeed)

func _on_CheckBox4_button_down():
	textSpeed = "instant"
	emit_signal("textSpeed", textSpeed)

#var filePath = "SaveData.jscsrc"
#func saveFile(fileNumber):
#	emit_signal("sendData", fileNumber)
#	var saveFile = File.new()
#	if saveFile.file_exists(filePath):
#		saveFile.open(filePath, File.WRITE)
#		saveFile.store_string(to_json(SaveDataManager.saveData["File " + str(fileNumber)]))
#		print("printing", SaveDataManager.saveData["File " + str(fileNumber)], "to file", str(fileNumber))
#		saveFile.close()
#	else:
#		print("Error in finding path to Saves folder.")

#func loadFile(fileNumber):
#	var loadFile = File.new()
#	if loadFile.file_exists(filePath):
#		loadFile.open(filePath, loadFile.READ)
#		print(loadFile.get_as_text())
#		var jsonResult = parse_json(loadFile.get_as_text())
#		print(jsonResult)
##		saveData = jsonResult["Saves"]["File " + str(fileNumber)]
#	else:
#		print("Dialogue: File Open Error")
#	loadFile.close()

#var fileNumber = 1
#func _on_Settings_sendData(fileNumber):
#	var SFXSlider = get_node("Menu/MarginContainer/VBoxContainer/SlidersLabels/SFXSlider")
#	SaveDataManager.saveData["File " + str(fileNumber)]["settings"]["sfx"] = SFXSlider.get_value()
#	var musicSlider = get_node("Menu/MarginContainer/VBoxContainer/SlidersLabels/MusicSlider")
#	SaveDataManager.saveData["File " + str(fileNumber)]["settings"]["music"] = musicSlider.get_value()
#	SaveDataManager.saveData["File " + str(fileNumber)]["settings"]["textSpeed"] = textSpeed

func sendSaveData():
	var SFXSlider = get_node("Menu/MarginContainer/VBoxContainer/SlidersLabels/SFXSlider")
	SaveDataManager.currentSaveData["settings"]["sfx"] = SFXSlider.get_value()
	var musicSlider = get_node("Menu/MarginContainer/VBoxContainer/SlidersLabels/MusicSlider")
	SaveDataManager.currentSaveData["settings"]["music"] = musicSlider.get_value()
	SaveDataManager.currentSaveData["settings"]["textSpeed"] = textSpeed

func receiveLoadData():
	var SFXSlider = get_node("Menu/MarginContainer/VBoxContainer/SlidersLabels/SFXSlider")
	SFXSlider.set_value(SaveDataManager.currentSaveData["settings"]["sfx"])
#	_on_SFXSlider_value_changed(SaveDataManager.currentFileData["File "+ str(SaveDataManager.currentSaveFile)]["settings"]["sfx"])
	
	var musicSlider = get_node("Menu/MarginContainer/VBoxContainer/SlidersLabels/MusicSlider")
	musicSlider.set_value(SaveDataManager.currentSaveData["settings"]["music"])
	_on_MusicSlider_value_changed(SaveDataManager.currentSaveData["settings"]["music"])
	
	textSpeed = SaveDataManager.currentSaveData["settings"]["textSpeed"]
	emit_signal("textSpeed", textSpeed)

func _on_Settings_textSpeed(speed):
	match speed:
		"slow":
			$Menu/MarginContainer/VBoxContainer/SlidersLabels/TextSpeedButtons/CheckBox.pressed = true
		"medium":
			$Menu/MarginContainer/VBoxContainer/SlidersLabels/TextSpeedButtons/CheckBox2.pressed = true
		"fast":
			$Menu/MarginContainer/VBoxContainer/SlidersLabels/TextSpeedButtons/CheckBox3.pressed = true
		"instant":
			$Menu/MarginContainer/VBoxContainer/SlidersLabels/TextSpeedButtons/CheckBox4.pressed = true
