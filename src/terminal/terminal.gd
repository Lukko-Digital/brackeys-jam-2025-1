extends TextureRect

@onready var label: Label = %Label
@onready var user_prompt: String = OS.get_user_data_dir().replace(" ", "-") + "> "

var width = 118
var rng = RandomNumberGenerator.new()

func _process(_delta):
	label.lines_skipped = label.get_line_count() - label.max_lines_visible

func _ready():
	await loading_bar(user_prompt + "Loading...")
	await add_text("\n")

	await add_text(FileAccess.open("res://src/player/player.tscn", FileAccess.READ).get_as_text(), 0.00001)

	for i in range(10):
		await add_text("\n")
		await loading_bar("Loading " + str(i + 1) + " of 10")

func loading_bar(text: String):
	await add_text(text)

	var bar_width = width - len(text) - 8

	label.text += " [" + " ".repeat(bar_width) + "]    %"

	for i in range(bar_width):
		label.text[- bar_width + i - 6] = "="
		var percent = str(int(((i + 1) * 100.0) / bar_width)) + "%"

		label.text = label.text.erase(label.text.length() - len(percent), len(percent))
		label.text += percent

		await get_tree().create_timer(rng.randfn(0.01, 0.01)).timeout

func add_text(text: String, delay: float = 0.01):
	var line_len = 0
	for c in text:
		line_len += 1

		if c == "\n":
			line_len = 0
		elif line_len >= width:
			label.text += "\n"
			line_len = 0

		label.text += c
		if delay < 0.01 and line_len % int(0.01 / delay) != 0:
			continue

		await get_tree().create_timer(delay).timeout