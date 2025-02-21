extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var movement_ray = %MovementRay

var INPUTS = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

func move(dir: String):
	movement_ray.target_position = INPUTS[dir] * Global.TILE_SIZE
	movement_ray.force_raycast_update()

	if !movement_ray.is_colliding():
		position += INPUTS[dir] * Global.TILE_SIZE
		# match dir:
		# 	"up", "down":
		# 		sprite.play(dir)
		# 	"left":
		# 		sprite.flip_h = true
		# 		sprite.play("right")
		# 	"right":
		# 		sprite.flip_h = false
		# 		sprite.play(dir)
	

func _unhandled_input(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			move(dir)