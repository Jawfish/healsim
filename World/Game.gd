extends Control

var mana_potion := preload("res://Engine/Items/ManaPotion.tscn")
var fire := preload("res://Engine/Items/Fire.tscn")
var poison := preload("res://Engine/Items/Poison.tscn")
var zap := preload("res://Engine/Items/Zap.tscn")
onready var units = $UnitFrames.get_children()
var previous_attack: String
var superfire_count: int = 0
var pattern := 0
var dead_units := 0
func _ready() -> void:
	$Timers/AttackTimer.start()
	for unit in units:
		unit.connect('unit_died', self, '_on_unit_died')

func spawn_potion() -> void:
	var m = mana_potion.instance()
	add_child(m)
	m.position.x = rand_range(0, 720)

func spawn_poison() -> void:
	var p = poison.instance()
	$Attacks.add_child(p)
	p.position.x = rand_range(0, 720)

func spawn_fire(damage: int) -> void:
	var f = fire.instance()
	f.damage = damage
	$Attacks.add_child(f)
	f.position.x = rand_range(0, 720)

func spawn_superfire() -> void:
	superfire_count = 5
	$Timers/SuperFire.start()

func attack() -> void:
	units.shuffle()
	for unit in units:
		randomize()
		if randf() > 0.75:
			unit.damage(floor(rand_range(1, 20)))

func spawn_earthquake() -> void:
	var f = zap.instance()
	$Attacks.add_child(f)
	f.position.x = rand_range(0, 720)

func _on_PotionTimer_timeout() -> void:
	spawn_potion()

func _on_Area2D_area_entered(area: Area2D) -> void:
	for unit in units:
		if unit.dead:
			units.remove(units.find(unit))
	var item = area.get_parent()
	if 'fire' in item.name.to_lower():
		randomize()
		units.shuffle()
		var i = 4
		for unit in units:
			if i > 0:
				unit.damage(item.damage)
				i -= 1
	elif 'poison' in item.name.to_lower():
		randomize()
		units.shuffle()
		var i = 4		
		for unit in units:
			if i > 0:
				(unit as UnitFrame).apply_poison()
				i -= 1
	elif 'zap' in item.name.to_lower():
		for unit in units:
			(unit as UnitFrame).damage(30)
	item.destroy()

func _on_AttackTimer_timeout() -> void:
	$Timers/AttackTimer.stop()
	match pattern:
		0:
			pattern += 1
			spawn_fire(20)
			$Timers/AttackTimer.wait_time = 3
		1:
			pattern += 1
			spawn_poison()
			$Timers/AttackTimer.wait_time = 2
		2:
			pattern += 1
			spawn_fire(20)
			$Timers/AttackTimer.wait_time = 3
		3:
			pattern += 1
			spawn_earthquake()
			$Timers/AttackTimer.wait_time = 6
		4:
			pattern += 1
			spawn_superfire()
			$Timers/AttackTimer.wait_time = 5
		5:
			pattern += 1
			spawn_poison()
			$Timers/AttackTimer.wait_time = 2
		6:
			pattern += 1
			spawn_fire(20)
			$Timers/AttackTimer.wait_time = 3
		7:
			pattern = 0
			spawn_earthquake()
			$Timers/AttackTimer.wait_time = 6
		_:
			pattern = 0
			$Timers/AttackTimer.wait_time = 1
	$Timers/AttackTimer.start()

func _on_SuperFire_timeout() -> void:
	if superfire_count > 0:
		spawn_fire(10)
		superfire_count -= 1

func _on_unit_died() -> void:
	dead_units += 1
	if dead_units >= 10:
		Globals.win = false
		SceneManager.transition_to_scene(preload("res://Interface/GameOver.tscn"))
