@tool
extends RichTextLabel
class_name LevelCodeLabel

# Extra lines added to the top and bottom
const PADDING_LINES = 2

const LineColors = {
	COMMENT = "#000000BB",
	RED = "#FF0000",
	YELLOW = "#FFFF00",
	GREEN = "#00FF00",
	BLUE = "#0000FF",
}

var line_height: float

func _ready():
	line_height = get_theme_font("normal_font").get_height(get_theme_font_size("normal_font_size"))

func scroll_one_line(time: float):
	var scroll_bar = get_v_scroll_bar()
	var tween: Tween = create_tween()
	tween.tween_property(scroll_bar, "value", scroll_bar.value + line_height, time)
	
func set_code_with_color(
	raw_code: String,
	red_var_name: String,
	yellow_var_name: String,
	green_var_name: String,
	blue_var_name: String
):
	clear()
	var lines = ("\n".repeat(PADDING_LINES) + raw_code + "\n".repeat(PADDING_LINES)).split("\n")
	for line in lines:
		var color_line = line
		if "//" in line:
			color_line = "[color=" + LineColors.COMMENT + "]" + line + "[/color]"
		
		elif not red_var_name.is_empty() and red_var_name in line:
			color_line = "[bgcolor=" + LineColors.RED + "]" + color_line + "[/bgcolor]"
		elif not yellow_var_name.is_empty() and yellow_var_name in line:
			color_line = "[bgcolor=" + LineColors.YELLOW + "]" + color_line + "[/bgcolor]"
		elif not green_var_name.is_empty() and green_var_name in line:
			color_line = "[bgcolor=" + LineColors.GREEN + "]" + color_line + "[/bgcolor]"
		elif not blue_var_name.is_empty() and blue_var_name in line:
			color_line = "[bgcolor=" + LineColors.BLUE + "]" + color_line + "[/bgcolor]"

		append_text(color_line + "\n")