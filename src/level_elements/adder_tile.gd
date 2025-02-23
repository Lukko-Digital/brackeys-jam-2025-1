extends Tile
class_name AdderTile

func _on_turn_advance() -> void:
	super()
	if holding is IntegerVariable:
		holding.value += 1