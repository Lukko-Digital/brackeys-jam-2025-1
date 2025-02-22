extends Moveable
class_name Player

const COYOTE_TIME = 0.1

@onready var coyote_timer: Timer = %CoyoteTimer

var buffered_input: String = ""

func _ready() -> void:
	super()
	coyote_timer.wait_time = COYOTE_TIME

func movement_ended():
	super()
	if not coyote_timer.is_stopped():
		move(buffered_input)

func move_input(dir: String):
	coyote_timer.start()
	buffered_input = dir

	if not is_moving:
		move(dir)

func _unhandled_input(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			move_input(dir)