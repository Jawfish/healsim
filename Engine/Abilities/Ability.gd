extends Node
class_name Ability

export (Array, UnitType) var targets
export (Array, PackedScene) var effects
var action: Action = load("res://Engine/Actions/CastAction.tres") as Action
export (float) var cooldown
export (float) var cast_time

func _ready() -> void:
	$Cooldown.wait_time = cooldown
	$CastTime.wait_time = cast_time
	$CastTime.start()

func cast_ability() -> void:
	(action as Action).publish(self, {'targets': targets, 'effects': effects})


func _on_CastTime_timeout() -> void:
	print(get_parent().name + ' casted ' + name)
	cast_ability()
	$Cooldown.start()


func _on_Cooldown_timeout() -> void:
	$CastTime.start()
