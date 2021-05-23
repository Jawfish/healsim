extends Node
class_name Effect

export (int) var duration = 0

func _process(delta: float) -> void:
	duration -= delta
	if duration <= 0:
		queue_free()
#	print('Executing ' + name + ' effect on ' + get_parent().get_parent().name)
	execute(get_parent().get_parent())

func execute(target) -> void:
	push_error("EFFECT NOT IMPLEMENTED")
	printerr("EFFECT NOT IMPLEMENTED")
	queue_free()
