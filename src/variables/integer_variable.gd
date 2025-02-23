extends Moveable
class_name IntegerVariable

var value: int = 0:
	set(val):
		value = val
		$Label.text = str(value)