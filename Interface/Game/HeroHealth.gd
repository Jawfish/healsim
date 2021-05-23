extends ProgressBar

onready var tween := $Tween as Tween

var transition_time := 0.5

func reduce(amount: int) -> void:
	var result = value - amount
	# Guard so that health can't drop below zero
	if result < 0:
		result = 0
	animate(result)

func increase(amount: int) -> void:
	var result = value + amount	
	# Guard so that health can't increase above 100
	if result > max_value:
		result = max_value
	animate(result)

func animate(new_value: int) -> void:
	tween.interpolate_property(self, "value", value, new_value, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, 'tween_all_completed')

func set_max_value(new_value: int) -> void:
	max_value = new_value
	value = max_value
