extends Node2D
class_name Actor

export var max_health = 100
export(Array, PackedScene) var abilities
export(int) var damage_per_attack := 1
export(int) var seconds_per_attack := 1

onready var health = max_health


func add_effect(effect: Effect) -> void:
	$Effects.add_child(effect)

func damage(amount: int) -> void:
	if health - amount <= 0:
		health = 0
	else:
		health -= amount
	SignalManager.emit_signal('boss_health_changed', health)
