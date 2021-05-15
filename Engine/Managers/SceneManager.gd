extends Node

onready var _transition_tween := $TransitionTween as Tween
onready var _transition_overlay := $TransitionOverlay as ColorRect
onready var _transition_sound := $TransitionSound as AudioStreamPlayer2D
onready var _viewport_size: Vector2 = get_viewport().get_visible_rect().size

export var _transition_speed: float = 0.6

var _current_scene: PackedScene

func _ready() -> void:
	var node := Node.new()
	get_tree().get_root().connect("size_changed", self, "_recalculate_resolution")
	_recalculate_resolution()

func reload_level() -> void:
	transition_to_scene(_current_scene)

func transition_to_scene(scene: PackedScene) -> void:
	_recalculate_resolution()
	SignalManager.emit_signal("slide_down_start")
	_slide_down()
	yield(_transition_tween, "tween_all_completed")
	SignalManager.emit_signal("slide_down_finish")
	get_tree().change_scene_to(scene)
	_slide_up()
	yield(_transition_tween, "tween_all_completed")
	SignalManager.emit_signal("slide_up_finish")
	_current_scene = scene

func _slide_down() -> void:
	_transition_tween.interpolate_property(_transition_overlay, "margin_bottom",
										   _transition_overlay.margin_bottom, 
										   0, 
										   _transition_speed, 
										   Tween.TRANS_EXPO,  
										   Tween.EASE_OUT)
	_transition_tween.start()
	_transition_sound.pitch_scale = 1
	_transition_sound.play()

func _slide_up() -> void:
	_transition_tween.interpolate_property(_transition_overlay, "margin_bottom",
										   _transition_overlay.margin_bottom, 
										   -_viewport_size.y, 
										   _transition_speed, 
										   Tween.TRANS_EXPO, 
										   Tween.EASE_OUT)
	_transition_tween.start()
	_transition_sound.pitch_scale = 1.1
	_transition_sound.play()

func _recalculate_resolution() -> void:
	_viewport_size = get_viewport().get_visible_rect().size
	_transition_overlay.rect_size = _viewport_size
	_transition_overlay.margin_bottom = -_viewport_size.y
