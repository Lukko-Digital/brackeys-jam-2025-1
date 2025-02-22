@tool
extends RichTextLabel
class_name LevelCode

@export_multiline var raw_code: String:
	set(str):
		raw_code = str
		if Engine.is_editor_hint():
			color_code()
		
@export var red_variable_name: String
@export var yellow_variable_name: String
@export var green_variable_name: String
@export var blue_variable_name: String

const LINE_SCROLL_TIME = 0.2

const VariableColors = {
	RED = "#FF0000",
	YELLOW = "#FFFF00",
	GREEN = "#00FF00",
	BLUE = "#0000FF",
}

var line_height: float

func _ready():
	line_height = get_theme_font("font", "font_height").get_height()
	color_code()

func advance_line():
	var scroll_bar = get_v_scroll_bar()
	var tween: Tween = create_tween()
	tween.tween_property(scroll_bar, "value", scroll_bar.value + line_height, LINE_SCROLL_TIME)
	
func color_code():
	clear()
	var lines = raw_code.split("\n")
	for line in lines:
		var color_line = line
		if "//" in line:
			color_line = "[color=#000000BB]" + line + "[/color]"
		
		elif not red_variable_name.is_empty() and red_variable_name in line:
			color_line = "[bgcolor=" + VariableColors.RED + "]" + color_line + "[/bgcolor]"
		elif not yellow_variable_name.is_empty() and yellow_variable_name in line:
			color_line = "[bgcolor=" + VariableColors.YELLOW + "]" + color_line + "[/bgcolor]"
		elif not green_variable_name.is_empty() and green_variable_name in line:
			color_line = "[bgcolor=" + VariableColors.GREEN + "]" + color_line + "[/bgcolor]"
		elif not blue_variable_name.is_empty() and blue_variable_name in line:
			color_line = "[bgcolor=" + VariableColors.BLUE + "]" + color_line + "[/bgcolor]"

		append_text(color_line + "\n")