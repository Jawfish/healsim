extends ColorRect

export(float) var transition_time := 0.15

func hover() -> void:
	Globals.set_cursor_to_hand()
	play_hover_sound()
	$Tween.interpolate_property(self, "color", color, Color(1, 1, 1, 0.25), transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func unhover() -> void:
	Globals.set_cursor_to_default()
	$Tween.interpolate_property(self, "color", color, Color(1, 1, 1, 0), transition_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _on_HoverRect_mouse_entered() -> void:
	hover()

func _on_HoverRect_mouse_exited() -> void:
	unhover()

func play_hover_sound() -> void:
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.8, 1.2)
	$AudioStreamPlayer2D.play()
