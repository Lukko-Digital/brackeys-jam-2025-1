@tool
extends Control

const LINE_ADVANCE_TIME = 0.3

# Extra lines added to the top
const PADDING_LINES = 1

@export_multiline var raw_code: String:
	set(str):
		raw_code = str
		if Engine.is_editor_hint():
			label.set_code_with_color(("\n".repeat(PADDING_LINES) + raw_code).split("\n"), red_var_name, yellow_var_name, green_var_name, blue_var_name)
		
@export var red_var_name: String
@export var yellow_var_name: String
@export var green_var_name: String
@export var blue_var_name: String

@export var red_var_obj: Moveable
@export var yellow_var_obj: Moveable
@export var green_var_obj: Moveable
@export var blue_var_obj: Moveable

@onready var label: LevelCodeLabel = %LevelCodeLabel
@onready var current_line_pointer: Sprite2D = %CurrentLinePointer

var raw_code_array: PackedStringArray
var current_line = 0

func _ready():
	raw_code_array = ("\n".repeat(PADDING_LINES) + raw_code).split("\n")
	label.set_code_with_color(raw_code_array, red_var_name, yellow_var_name, green_var_name, blue_var_name)
	for line in raw_code_array:
		print(line)
		print(line.strip_edges())
	# init_pointer()
	# advance_after_next_closed_curly()

# Line up pointer with first line of code
func init_pointer():
	current_line_pointer.position = Vector2(
		current_line_pointer.position.x,
		label.position.y + label.line_height * (PADDING_LINES + 0.5)
	)

func advance_code():
	pass

func parse_code_line():
	var strip_line = line.strip_edges()
	if strip_line.left(2) == "if":
		pass

## Expects if lines to be in the following signature:
## if [variable] == [value] {
func evalute_if_line():
	pass

func move_pointer_n_lines(lines: int, time: float):
	var tween: Tween = create_tween()
	current_line += lines
	tween.tween_property(
		current_line_pointer,
		"position",
		Vector2(current_line_pointer.position.x, current_line_pointer.position.y + (label.line_height * lines)),
		time
	)

func advance_after_next_closed_curly():
	var curly_idx = current_line
	while "}" not in raw_code_array[curly_idx]:
		curly_idx += 1
		if curly_idx >= raw_code_array.size():
			assert(false, "No closing curly brace found")
	move_pointer_n_lines(curly_idx - current_line, LINE_ADVANCE_TIME)
