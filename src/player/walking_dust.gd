extends Node2D
class_name WalkingDust

@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D

func play_animation(dir: String):
	match dir:
		"up":
			sprite.play("vertical_dust")
		"down":
			sprite.play("vertical_dust")
			sprite.flip_v = true
		"right":
			sprite.play("horizontal_dust")
		"left":
			sprite.play("horizontal_dust")
			sprite.flip_h = true

func _on_animated_sprite_2d_animation_finished():
	queue_free()
