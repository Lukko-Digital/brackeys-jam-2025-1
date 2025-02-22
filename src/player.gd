extends Moveable
class_name Player
	

func _unhandled_input(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			move(dir)