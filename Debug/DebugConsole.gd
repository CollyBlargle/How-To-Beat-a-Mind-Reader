extends CanvasLayer

#https://www.youtube.com/watch?v=80cwYGvKB9U

onready var vBoxContainer = get_node("VBoxContainer")
onready var command_handler = get_node("CommandHandler")
onready var output_box = get_node("VBoxContainer/Output")
onready var input_box = get_node("VBoxContainer/Input")

var showing = false
func _input(event):
	if event.is_action_pressed("open_debug_console"):
		if showing == false:
			vBoxContainer.show()
			showing = true
		else:
			vBoxContainer.hide()
			showing = false

func _ready():
	vBoxContainer.hide()

func process_command(text):
	var words = text.split(" ")
	words = Array(words)
	
	for _i in range(words.count("")):
		words.erase("")
	
	if words.size() == 0:
		return
	
	var command_word = words.pop_front()
	
	for c in command_handler.valid_commands:
		if c[0] == command_word:
			if words.size() != c[1].size():
				output_text(str('Failure executing command"', command_word, '", expected ', c[1].size(), ' parameters'))
				return
			for i in range(words.size()):
				if not check_type(words[i], c[1][i]):
					output_text(str('Failure executing command "', command_word, '", parameter ', (i + 1), ' ("', words[i], '") is of the wrong type'))
					return
			output_text(command_handler.callv(command_word, words))
			return
	output_text(str('Command "', command_word, '" does not exist.'))
			

func check_type(string, type):
	if type == command_handler.ARG_INT:
		return string.is_valid_integer()
	if type == command_handler.ARG_FLOAT:
		return string.is_valid_float()
	if type == command_handler.ARG_STRING:
		return true
	if type == command_handler.ARG_BOOL:
		return (string == "true" or string == "false")
	return false
func output_text(text):
	output_box.text = str(output_box.text, "\n", text)

func _on_Input_text_entered(new_text):
	input_box.clear()
	process_command(new_text)
