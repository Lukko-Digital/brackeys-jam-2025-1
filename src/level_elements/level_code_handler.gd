extends Control


@export_multiline var raw_code: String
		
@export var red_var_name: String
@export var yellow_var_name: String
@export var green_var_name: String
@export var blue_var_name: String

@onready var label: LevelCodeLabel = %LevelCodeLabel

func _ready():
	label.set_code_with_color(raw_code, red_var_name, yellow_var_name, green_var_name, blue_var_name)