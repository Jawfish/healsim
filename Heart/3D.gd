extends Spatial


onready var heart = $Heart

func _process(delta: float) -> void:
	heart.rotate_y(0.2 * delta)
