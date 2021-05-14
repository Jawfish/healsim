extends Node


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('reload'):
		SceneManager.transition_to_scene(SceneManager.current_scene)
