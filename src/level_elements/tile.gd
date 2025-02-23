extends Area2D
class_name Tile

var holding: Moveable


func _ready() -> void:
    Global.turn_advanced.connect(_on_turn_advance)


func _on_area_entered(area: Area2D) -> void:
    print(area)
    if area is Moveable:
        # print(area)
        holding = area


func _on_turn_advance() -> void:
    pass