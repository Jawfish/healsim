extends Node2D
class_name Potion

func _process(delta: float) -> void:
	position.y += 2

func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		$AnimationPlayer.play('Consume')
		_action()

func destroy() -> void:
	$AnimationPlayer.play('Destroy')

func _action() -> void:
	push_error("POTION MISSING ACTION")
	printerr("POTION MISSING ACTION")
