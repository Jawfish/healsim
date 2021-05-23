extends Ability
class_name BossAbility

func _ready() -> void:
	$Cooldown.wait_time = cooldown
	$CastTime.wait_time = cast_time
	$CastTime.start()

func cast_ability() -> void:
	(action as Action).publish(self, effects)

func _on_CastTime_timeout() -> void:
	print(get_parent().name + ' casted ' + name)
	cast_ability()
	$Cooldown.start()

func _on_Cooldown_timeout() -> void:
	$CastTime.start()
