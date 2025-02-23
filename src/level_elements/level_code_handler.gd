@tool
extends Control

const LINE_ADVANCE_TIME = 0.3

# Extra lines added to the top
const PADDING_LINES = 1

@export_multiline var raw_code: String:
	set(str):
		raw_code = str
		if Engine.is_editor_hint():
			label.set_code_with_color(("\n".repeat(PADDING_LINES) + raw_code).split("\n"), red_var, yellow_var, green_var, blue_var)
		
@export var red_var: Moveable
@export var yellow_var: Moveable
@export var green_var: Moveable
@export var blue_var: Moveable

@onready var label: LevelCodeLabel = %LevelCodeLabel
@onready var current_line_pointer: Sprite2D = %CurrentLinePointer

var raw_code_array: PackedStringArray
var current_line = 0

var stack = []

var vairables = {}

func _ready():
	raw_code_array = ("\n".repeat(PADDING_LINES) + raw_code).split("\n")
	label.set_code_with_color(raw_code_array, red_var, yellow_var, green_var, blue_var)
	for line in raw_code_array:
		print(line)
		print(line.strip_edges())

	if red_var != null:
		vairables[red_var.variable_name] = red_var
	if yellow_var != null:
		vairables[yellow_var.variable_name] = yellow_var
	if green_var != null:
		vairables[green_var.variable_name] = green_var
	if blue_var != null:
		vairables[blue_var.variable_name] = blue_var

	init_pointer()
	# advance_after_next_closed_curly()

	Global.turn_advanced.connect(advance_code)

# Line up pointer with first line of code
func init_pointer():
	current_line_pointer.position = Vector2(
		current_line_pointer.position.x,
		label.position.y + label.line_height * (PADDING_LINES + 0.5)
	)

func advance_code():
	move_pointer_n_lines(1, LINE_ADVANCE_TIME)
	parse_code_line(raw_code_array[current_line])
	print(raw_code_array[current_line], stack)


func parse_code_line(line: String):
	var tokens = line.strip_edges().split(" ")
	if tokens[0] == "if":
		evalute_if_line(tokens)
	elif tokens[0] == "while":
		evalute_while_line(tokens)
	elif tokens[0] == "return":
		assert(false)
	elif tokens[0] == "}":
		var tos = stack.pop_back()
		
		if tos > -1:
			move_pointer_n_lines(tos - current_line - 1, LINE_ADVANCE_TIME)
		if tos == -1:
			var next_line = raw_code_array[current_line + 1].strip_edges().split(" ")
			print(next_line)
			if next_line[0] == "else":
				advance_after_next_closed_curly()
				print("asdfasdfasdfasdfasdf")

	elif tokens[0] == "else":
		stack.append(-2)
	elif len(tokens) > 1 and tokens[1] == "=":
		assert(vairables[tokens[0]].value == evaluate_expression(tokens[2]))
	else:
		pass

	
func evaluate_expression(expression: String):
	expression = expression.replace(";", "")
	if expression.is_valid_int():
		return expression.to_int()
	elif expression == "true":
		return true
	elif expression == "false":
		return false

## Expects if lines to be in the following signature:
## if [variable] == [value] {
func evalute_if_line(tokens: Array[String]):
	if vairables[tokens[1]].value == evaluate_expression(tokens[3]):
		stack.append(-1)
	else:
		advance_after_next_closed_curly()


func evalute_while_line(tokens: Array[String]):
	if vairables[tokens[1]].value == evaluate_expression(tokens[3]):
		stack.append(current_line)
	else:
		advance_after_next_closed_curly()

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
	var curly_idx = current_line + 1
	while "}" not in raw_code_array[curly_idx]:
		curly_idx += 1
		if curly_idx >= raw_code_array.size():
			assert(false, "No closing curly brace found")
	move_pointer_n_lines(curly_idx - current_line, LINE_ADVANCE_TIME)
