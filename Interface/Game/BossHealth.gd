extends Control

onready var tween := $Tween as Tween
onready var health := $HealthBar as ProgressBar

var health_bar_shown := false
var transition_time := 0.5

func _ready() -> void:
	SignalManager.connect('boss_health_changed', self, '_on_boss_health_changed')

func _on_boss_health_changed(new_total: int) -> void:
	tween.interpolate_property(health, "value", health.value, new_total, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
