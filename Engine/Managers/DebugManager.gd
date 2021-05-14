extends CanvasLayer

var secret = '55'
var showing = false
onready var viewport_size := get_viewport().get_visible_rect().size

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('debug') and not showing and not $Tween.is_active():
		$Tween.interpolate_property($LineEdit, "rect_position", $LineEdit.rect_position, $LineEdit.rect_position + Vector2(0, 24), 0.2, Tween.TRANS_EXPO)
		showing = true
		$Tween.start()
	elif event.is_action_pressed('debug') and showing and not $Tween.is_active():
		$Tween.interpolate_property($LineEdit, "rect_position", $LineEdit.rect_position, $LineEdit.rect_position - Vector2(0, 24), 0.2, Tween.TRANS_EXPO)
		showing = false
		$Tween.start()

func _on_LineEdit_text_entered(new_text: String) -> void:
	if $LineEdit.text == secret:
		SceneManager.transition_to_scene(SceneManager.scene_dictionary[SceneManager.SCENES.HEART])
	$LineEdit.text = ''

func _on_Tween_tween_all_completed() -> void:
	if showing:
		$LineEdit.grab_focus()
	else:
		$LineEdit.release_focus()
