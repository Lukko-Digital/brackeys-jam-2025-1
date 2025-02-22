extends Area2D
class_name InteractableComponent

@export_file("*.txt") var dialogue_file
@export_multiline var dialogue_text: String

var dialogue_lines: Array[String]

func _ready() -> void:
	load_dialogue()

## Read dialogue from [dialogue_file]. If [dialogue_file] is empty, read from [dialogue_text]
func load_dialogue():
	var text = dialogue_text
	if dialogue_file != "<null>":
		text = FileAccess.open(
			dialogue_file,
			FileAccess.READ
		).get_as_text()

	dialogue_lines = Array(text.strip_edges().split("\n")).filter(
		func(line): if line == "": return false else: return true
	)
