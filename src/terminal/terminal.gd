extends TextureRect

@onready var label: Label = %Label
@onready var user_prompt: String = OS.get_user_data_dir().replace(" ", "-") + "> "

var width = 118
var rng = RandomNumberGenerator.new()

func _ready():
	await loading_bar(user_prompt + "Loading...")

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

func add_text(text: String):
	for c in text:
		label.text += c
		await get_tree().create_timer(0.01).timeout