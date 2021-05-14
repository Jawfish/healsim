extends Node


onready var heart := preload('res://Heart/3D.tscn')
onready var main_menu := preload('res://Interface/Menus/MainMenu.tscn')
onready var game_over := preload('res://Interface/Menus/GameOver.tscn')
onready var tween := $TransitionTween
onready var color_rect := $TransitionFade
onready var slide_sound := $TransitionSound
onready var viewport_size := get_viewport().get_visible_rect().size

export var transition_speed: float = 0.6

var current_scene
var secret = '55'
enum SCENES {
	MAIN_MENU,
	GAME_OVER,
	HEART,
	MAIN_GAME
}

var scene_dictionary: Dictionary = {
			SCENES.MAIN_MENU: load("res://Interface/Menus/MainMenu.tscn"),
			SCENES.GAME_OVER: load("res://Interface/Menus/GameOver.tscn"),
			SCENES.HEART: load("res://Heart/3D.tscn"),
			SCENES.MAIN_GAME: load("res://World/MainGame.tscn")
}

func _ready() -> void:
	color_rect.rect_size = viewport_size
	color_rect.margin_bottom = -viewport_size.x

func reload_level() -> void:
	transition_to_scene(scene_dictionary[current_scene.level_name])

func start_game() -> void:
	transition_to_scene(scene_dictionary[SCENES.MAIN_GAME])

func transition_to_scene(scene: PackedScene) -> void:
	SignalManager.emit_signal("slide_down_start")
	slide_down()
	yield(tween, "tween_all_completed")
	SignalManager.emit_signal("slide_down_finish")
	get_tree().change_scene_to(scene)
	slide_up()
	yield(tween, "tween_all_completed")
	SignalManager.emit_signal("slide_up_finish")
	
func slide_down() -> void:
	tween.interpolate_property(color_rect, "margin_bottom", color_rect.margin_bottom, 0, transition_speed, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	slide_sound.pitch_scale = 1
	slide_sound.play()

func slide_up() -> void:
	tween.interpolate_property(color_rect, "margin_bottom", color_rect.margin_bottom, -viewport_size.y, transition_speed, Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()
	slide_sound.pitch_scale = 1.1
	slide_sound.play()
