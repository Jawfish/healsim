extends Control

onready var tween := $Tween as Tween
onready var mana := $ManaBar as ProgressBar

var transition_time := 0.5

#func _ready() -> void:
#	SignalManager.connect('player_used_mana', self, 'reduce')
#
#func reduce(amount: int) -> void:
#	var result = max(mana.value - amount, 0)
#	tween.interpolate_property(mana, "value", mana.value, result, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
#	tween.start()

# lazy
func _process(delta: float) -> void:
	tween.interpolate_property(mana, "value", mana.value, Globals.player_mana, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
