extends Node2D

onready var _cam := $Camera2D as Camera2D
var _camera_progression_amount := Vector2(1920, 0)
var _camera_position_one = Vector2(970, 210)
var _camera_position_two = _camera_position_one + Vector2(1920, 0)
var _camera_position_three= _camera_position_two + Vector2(1920, 0)
var _camera_position_four = _camera_position_three + Vector2(1920, 0)
onready var _player := $Player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('debug_1'):
		_progress_camera()

func _progress_camera() -> void:
	SignalManager.emit_signal('camera_progress')
	# If the camera has progressed 3 times or less, progress camera
	if _cam.position.x < (_camera_position_one.x + (_camera_progression_amount.x * 3)):
		_cam.position += _camera_progression_amount
	# Otherwise, reset to  the original spot
	else:
		_cam.position = _camera_position_one
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	_move_player_to_next_screen()	
	yield(t, 'timeout')
	SignalManager.emit_signal('camera_progress_finished')

func _move_player_to_next_screen() -> void:
	$Tween.interpolate_property(_player, 'position', _player.position, Vector2(_cam.position.x - 800 , _player.position.y), 1, Tween.TRANS_EXPO)
	$Tween.start()
