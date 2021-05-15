extends KinematicBody2D

export (int) var speed = 400
export (int) var jump_speed = -1000
export (float, 0, 1.0) var friction = 0.2
export (float, 0, 1.0) var acceleration = 0.25
onready var _scale_x = scale.x
var velocity := Vector2.ZERO
var camera_progressing := false

func _ready() -> void:
	SignalManager.connect('camera_progress', self, '_on_camera_progress')
	SignalManager.connect('camera_progress_finished', self, '_on_camera_progress_finished')

func get_input():
	var dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	if dir < 0:
		$AnimatedSprite.flip_h = true
	elif dir > 0:
		$AnimatedSprite.flip_h = false
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _process(delta):
	if camera_progressing:
		velocity = Vector2.ZERO
	else:
		get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
	if abs(velocity.x) >= 100:
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")

func _on_camera_progress() -> void:
	camera_progressing = true

func _on_camera_progress_finished() -> void:
	camera_progressing = false
