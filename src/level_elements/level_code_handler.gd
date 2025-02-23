@tool
extends Control

const LINE_ADVANCE_TIME = 0.3

@export_multiline var raw_code: String:
	set(str):
		raw_code = str
		if Engine.is_editor_hint():
			label.set_code_with_color(raw_code, red_var_name, yellow_var_name, green_var_name, blue_var_name)
		
@export var red_var_name: String
@export var yellow_var_name: String
@export var green_var_name: String
@export var blue_var_name: String

@onready var label: LevelCodeLabel = %LevelCodeLabel
@onready var current_line_pointer: Sprite2D = %CurrentLinePointer

var current_line = 0
# The idx of the topmost line that can be seen
var top_line = 0


func _ready():
	label.set_code_with_color(raw_code, red_var_name, yellow_var_name, green_var_name, blue_var_name)
	init_pointer()
	# print(label.get_line_count())
	# print(label.get_visible_line_count())
	q()

func q():
	while (true):
		advance_line()
		await get_tree().create_timer(LINE_ADVANCE_TIME + 0.3).timeout

# Line up pointer with first line of code
func init_pointer():
	current_line_pointer.position = Vector2(
		current_line_pointer.position.x,
		label.position.y + label.line_height * (label.PADDING_LINES + 0.5)
	)

func advance_line():
	current_line += 1
	if top_line + label.get_visible_line_count() < label.get_line_count() - label.PADDING_LINES:
		top_line += 1
		label.scroll_one_line(LINE_ADVANCE_TIME)
	else:
		advance_pointer(LINE_ADVANCE_TIME)

func advance_pointer(time: float):
	var tween: Tween = create_tween()
	tween.tween_property(
		current_line_pointer,
		"position",
		Vector2(current_line_pointer.position.x, current_line_pointer.position.y + label.line_height),
		time
	)
