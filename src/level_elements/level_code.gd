extends RichTextLabel
class_name LevelCode

@export_multiline var raw_code: String
@export var red_variable: String
@export var yellow_variable: String
@export var blue_variable: String
@export var teal_variable: String

const VariableColors = {
	RED = "#FF0000",
	YELLOW = "#FFFF00",
	BLUE = "#0000FF",
	TEAL = "#00FFFF"
}

func _ready():
	color_code()

func color_code():
	var lines = raw_code.strip_edges().split("\n")
	for line in lines:
		var color_line = line
		if "//" in line:
			color_line = "[color=#FFFFFFBB]" + line + "[/color]"
		
		if not red_variable.is_empty() and red_variable in line:
			color_line = "[bgcolor=" + VariableColors.RED + "]" + color_line + "[/bgcolor]"
		if not yellow_variable.is_empty() and yellow_variable in line:
			color_line = "[bgcolor=" + VariableColors.YELLOW + "]" + color_line + "[/bgcolor]"
		if not blue_variable.is_empty() and blue_variable in line:
			color_line = "[bgcolor=" + VariableColors.BLUE + "]" + color_line + "[/bgcolor]"
		if not teal_variable.is_empty() and teal_variable in line:
			color_line = "[bgcolor=" + VariableColors.TEAL + "]" + color_line + "[/bgcolor]"

		append_text(color_line + "\n")