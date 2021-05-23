extends Node2D
class_name Fire

export var speed = 0
export var spin_speed = 0
var damage := 0

func _ready() -> void:
	$Spawn.play()

func _process(delta: float) -> void:
	rotate(spin_speed * delta)
	position.y += delta * speed

func destroy() -> void:
	$Area2D.queue_free()
	$AnimationPlayer.play('Destroy')
	$Impact.play()


func _on_Impact_finished() -> void:
	queue_free()
