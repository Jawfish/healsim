extends Actor
class_name Boss

var dead := false

func _ready() -> void:
	SignalManager.connect('boss_attacked', self, '_on_boss_attacked')

func _on_boss_attacked(damage_done: int) -> void:
	health -= damage_done
	var num = Globals.damage_number.instance() as Label
	num.self_modulate = Color(1, .25, .25)
	num.text = str(damage_done)
	$DamageText.add_child(num)
	SignalManager.emit_signal('boss_health_changed', health / (max_health / 1000))
	if health <= 0 and not dead:
		dead = true
		Globals.win = true
		SceneManager.transition_to_scene(preload("res://Interface/GameOver.tscn"))
