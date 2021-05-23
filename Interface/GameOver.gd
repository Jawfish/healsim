extends Control


func _ready() -> void:
	SignalManager.connect('slide_up_finish', self, '_on_slide_up_finish')
	if Globals.win:
		$Label.text = 'Victory'
		$ColorRect.color = Color(0.5, 1, 0.5)
	else:
		$Label.text = 'Defeat'
		$ColorRect.color = Color(1, 0.5, 0.5)

func _on_Replay_pressed() -> void:
	SceneManager.transition_to_scene(load("res://World/Game.tscn"))

func _on_slide_up_finish() -> void:
	if not Globals.win:
		$AudioStreamPlayer.stream = load("res://Assets/Sounds/Music/Fanfare_04_Long_Version_01.wav")
	else:
		$AudioStreamPlayer.stream = load("res://Assets/Sounds/Music/Fanfare_06_Short_Version_01.wav")
	$AudioStreamPlayer.play()
