extends Area2D
class_name Moveable

const MOVE_LERP_SPEED = 20
# Threshold between current position and target position that the moveable with stop moving if within
const MOVE_DISTANCE_THRESHOLD = 2

@onready var push_ray: RayCast2D = %PushRay
@onready var walkable_ray: RayCast2D = %WalkableRay

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
	if is_moving():
		position = position.lerp(target_position, MOVE_LERP_SPEED * delta)


func is_moving() -> bool:
	return abs(position.distance_to(target_position)) > MOVE_DISTANCE_THRESHOLD


func move(dir: String) -> bool:
	push_ray.target_position = INPUTS[dir] * Global.TILE_SIZE
	push_ray.force_raycast_update()
	
	if !is_walkable(dir):
		return false

	if push_ray.is_colliding():
		var collider = push_ray.get_collider()
		# If the pushed object can't move, don't move
		if not collider.move(dir):
			return false
	
	target_position += INPUTS[dir] * Global.TILE_SIZE
	return true

func is_walkable(dir: String) -> bool:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = target_position + INPUTS[dir] * Global.TILE_SIZE
	query.collision_mask = 1
	var result = space.intersect_point(query)
	return !result.is_empty()