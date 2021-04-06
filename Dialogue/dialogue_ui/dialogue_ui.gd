extends CanvasLayer

onready var Story_Reader_Class = preload("res://addons/EXP-System-Dialog/Reference_StoryReader/EXP_StoryReader.gd")
onready var storyReader = Story_Reader_Class.new()
export (Resource) var story

onready var animationPlayer = get_node("DialoguePanel/AnimationPlayer")
onready var dialoguePanel = get_node("DialoguePanel")
onready var speakerLabel = get_node("DialoguePanel/SpeakerLabel")
onready var bodyLabel = get_node("DialoguePanel/BodyLabel")
onready var portrait = get_node("DialoguePanel/PortraitHolder/Portrait")

var did = 0
var nid = 0
var final_nid = 0 
var open 

func _ready():
#	storyReader.read(story)
	pass

func _on_Player_initiate_dialogue(dialogueName, _directionFacing):
	animationPlayer.current_animation = "pop_up"
	open = true
	play_dialogue(dialogueName)
	print()

#Remember to change alignment of text!!
func _input(_event):
	if Input.is_action_just_pressed("move_up"):
		animationPlayer.current_animation = "pop_up"
	if Input.is_action_just_pressed("move_down"):
		animationPlayer.current_animation = "left_switch_hide"
		yield(animationPlayer, "animation_finished")
		speakerLabel.text = "My new name"
		bodyLabel.text = "See, I can change my body as well! I just want to show you my cool features."
		portrait.texture = load("res://overworld/violet_portraits/Angry Violet.png")
		animationPlayer.current_animation = "left_switch_show"
	if open:
		get_tree().set_input_as_handled()
		if Input.is_action_just_pressed("interact"):
			if is_waiting():
				get_next_node()
				if is_playing():
					play_node()

func play_dialogue(recordName):
	did = storyReader.get_did_via_record_name(recordName)
	nid = storyReader.get_nid_via_exact_text(did, "<start>")
	final_nid = storyReader.get_nid_via_exact_text(did, "<end>")
	get_next_node()
	play_node()
	dialoguePanel.show()

func is_playing() -> bool:
	return dialoguePanel.visible

func is_waiting() -> bool:
	return true

func get_next_node():
	nid = storyReader.get_nid_from_slot(did, nid, 0)
	if nid == final_nid:
		open = false
		dialoguePanel.hide()

func get_tagged_text(tag : String, text : String) -> String:
	var start_tag = "<" + tag + ">"
	var end_tag = "</" + tag + ">"
	var start_index = text.find(start_tag) + start_tag.length()
	var end_index = text.find(end_tag)
	var substring_length = end_index - start_index
	return text.substr(start_index, substring_length)

func play_node():
	var text = storyReader.get_text(did, nid)
	var speaker = get_tagged_text("speaker", text)
	var body = get_tagged_text("body", text)
	print(speaker)
	
	speakerLabel.text = speaker
	bodyLabel.text = body
