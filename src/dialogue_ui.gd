extends CanvasLayer
class_name DialogueUI

# Seconds between character
const TEXT_SPEED = 0.03

@onready var label: RichTextLabel = %DialogueLabel
@onready var text_timer: Timer = %TextTimer

var player: Player

var display_in_progress: bool = false
var dialogue_lines: Array
var current_line: int

func _ready() -> void:
	hide()

func begin_dialogue(interactable: InteractableComponent):
	dialogue_lines = interactable.dialogue_lines
	current_line = -1
	advance_dialogue()

## When player inputs [interact]
func advance_dialogue():
	if display_in_progress:
		# fast forward dialogue readout
		display_in_progress = false
		label.visible_characters = len(strip_bbcode(label.text))
	else:
		current_line += 1
		if current_line >= len(dialogue_lines):
			player.exit_dialogue()
		else:
			next_line()

## Show the next line with correct portrait
func next_line():
	var speaker_name = dialogue_lines[current_line].get_slice(": ", 0)
	label.text = dialogue_lines[current_line].get_slice(": ", 1)
	
	if speaker_name == "narrator":
		# center dialogue, reshape label
		label.text = "[center]" + label.text + "[/center]"
	else:
		# reshape label back to default
		pass
	
	animate_display()

func animate_display():
	label.visible_characters = 0
	display_in_progress = true
	while label.visible_characters < len(strip_bbcode(label.text)):
		# play talk audio
		label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
	display_in_progress = false

func strip_bbcode(string: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(string, "", true)
