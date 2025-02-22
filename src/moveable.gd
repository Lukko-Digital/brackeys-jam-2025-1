extends Area2D
class_name Moveable

const MOVE_LERP_SPEED = 20

@onready var movement_ray: RayCast2D = %MovementRay

var INPUTS = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

var target_position: Vector2


func _ready() -> void:
	target_position = position


func _process(delta):
	if position != target_position:
		position = position.lerp(target_position, MOVE_LERP_SPEED * delta)


func move(dir: String) -> bool:
	movement_ray.target_position = INPUTS[dir] * Global.TILE_SIZE
	movement_ray.force_raycast_update()

	if movement_ray.is_colliding():
		var collider = movement_ray.get_collider()
		# If the collider isn't moveable don't move
		if not collider is Moveable:
			return false
		# If the collider is moveable, and it can't move, don't move
		if not collider.move(dir):
			return false
	
	target_position += INPUTS[dir] * Global.TILE_SIZE
	return true