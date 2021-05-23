extends Node

var player_target
var portraits: Array = ["res://Assets/Images/Portraits/Female_01.png","res://Assets/Images/Portraits/Female_02.png","res://Assets/Images/Portraits/Female_03.png","res://Assets/Images/Portraits/Female_04.png","res://Assets/Images/Portraits/Female_05.png","res://Assets/Images/Portraits/Female_06.png","res://Assets/Images/Portraits/Female_07.png","res://Assets/Images/Portraits/Female_08.png","res://Assets/Images/Portraits/Female_09.png","res://Assets/Images/Portraits/Female_10.png","res://Assets/Images/Portraits/Female_11.png","res://Assets/Images/Portraits/Female_12.png","res://Assets/Images/Portraits/Male_01.png","res://Assets/Images/Portraits/Male_02.png","res://Assets/Images/Portraits/Male_03.png","res://Assets/Images/Portraits/Male_04.png","res://Assets/Images/Portraits/Male_05.png","res://Assets/Images/Portraits/Male_06.png","res://Assets/Images/Portraits/Male_07.png","res://Assets/Images/Portraits/Male_08.png","res://Assets/Images/Portraits/Male_09.png","res://Assets/Images/Portraits/Male_10.png","res://Assets/Images/Portraits/Male_11.png","res://Assets/Images/Portraits/Male_12.png","res://Assets/Images/Portraits/Male_13.png","res://Assets/Images/Portraits/Male_14.png","res://Assets/Images/Portraits/Male_15.png","res://Assets/Images/Portraits/Male_16.png","res://Assets/Images/Portraits/Male_17.png","res://Assets/Images/Portraits/Male_18.png"]
var used_portraits: Array
var damage_number = preload('res://Interface/DamageNumber/DamageNumber.tscn')
var player_mana: int = 100 setget set_player_mana
var win := true

func _init() -> void:
	set_cursor_to_default()

func _ready() -> void:
	SignalManager.connect('player_used_mana', self, '_on_player_used_mana')
	SignalManager.connect('scene_unloaded', self, '_on_scene_unloaded')

func set_cursor_to_hand() -> void:
	Input.set_custom_mouse_cursor(load("res://Assets/UI/cursorHand_beige.png"))

func set_cursor_to_default() -> void:
	Input.set_custom_mouse_cursor(load("res://Assets/UI/arrowBeige_left.png"))

func _on_player_used_mana(amount: int) -> void:
	set_player_mana(player_mana - amount)

func _on_scene_unloaded() -> void:
	player_target = null
	player_mana = 100
	used_portraits = []

func set_player_mana(value) -> void:
	player_mana = clamp(value, 0, 100)

func get_unused_portrait() -> Texture:
	portraits.shuffle()
	for portrait in portraits:
		if not portrait in used_portraits:
			used_portraits.append(portrait)
			return load(portrait) as Texture
	return null
