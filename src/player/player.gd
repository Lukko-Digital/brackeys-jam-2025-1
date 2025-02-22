extends Moveable
class_name Player

const COYOTE_TIME = 0.1
const EYES_X_OFFSET = 15

@onready var interact_ray: RayCast2D = %InteractRay
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var dialogue_ui: CanvasLayer = %DialogueUi
@onready var eyes_sprite: AnimatedSprite2D = $PlayerEyes

var in_dialogue = false
var buffered_input: String = ""

func _ready() -> void:
	super()
	dialogue_ui.player = self
	coyote_timer.wait_time = COYOTE_TIME

func _unhandled_input(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			move_input(dir)
	if event.is_action_pressed("interact"):
		interact_pressed()

## ------------------ MOVEMENT ------------------

func movement_ended():
	super()
	if not coyote_timer.is_stopped():
		move(buffered_input)

func move(dir: String) -> bool:
	interact_ray.target_position = INPUTS[dir] * Global.TILE_SIZE
	interact_ray.force_raycast_update()

	match dir:
		"up":
			eyes_sprite.play("up")
		"down":
			eyes_sprite.play("down")
		"left":
			eyes_sprite.play("right")
			eyes_sprite.flip_h = true
			eyes_sprite.offset.x = - EYES_X_OFFSET
		"right":
			eyes_sprite.play("right")
			eyes_sprite.flip_h = false
			eyes_sprite.offset.x = EYES_X_OFFSET

	return super(dir)

func move_input(dir: String):
	if in_dialogue:
		return
		
	coyote_timer.start()
	buffered_input = dir

	if not is_moving:
		move(dir)

## ------------------ MOVEMENT ------------------

func interact_pressed():
	if in_dialogue:
		dialogue_ui.advance_dialogue()
	elif interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		if collider is InteractableComponent:
			enter_dialogue(collider)

func enter_dialogue(interactable: InteractableComponent):
	in_dialogue = true
	dialogue_ui.begin_dialogue(interactable)
	dialogue_ui.show()

func exit_dialogue():
	in_dialogue = false
	dialogue_ui.hide()