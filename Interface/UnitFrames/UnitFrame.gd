extends TextureButton
class_name UnitFrame

signal unit_selected
signal unit_died
onready var health = $HealthBar
onready var shield = $ShieldBar
var dead := false
var has_hot := false
var has_dot := false
var shielded := false

func _ready() -> void:
	SignalManager.connect('prayer_cast', self, '_on_prayer_cast')
	randomize()
	$EffectTicker.wait_time = rand_range(0.75,1.25)	
	SignalManager.connect('unit_selected', self, '_on_unit_selected')
	randomize()
	texture_normal = Globals.get_unused_portrait()
	$AttackTimer.wait_time = rand_range(1,5)
	$AttackTimer.start()

func _process(delta: float) -> void:
	$HoT/CooldownProgress.value = $HoTTimer.time_left * 10
	$DoT/CooldownProgress.value = $DoTTimer.time_left * 10

func _on_UnitFrame_pressed() -> void:
	if not Globals.player_target == self:
		print(name + ' selected')
		SignalManager.emit_signal('unit_selected', self)
		select()
		$AudioStreamPlayer2D.pitch_scale = rand_range(0.9, 1.1)
		$AudioStreamPlayer2D.play()

func deselect() -> void:
	$Tween.interpolate_property($ColorRect, 'modulate', Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func select() -> void:
	Globals.player_target = self
	$Tween.interpolate_property($ColorRect, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func damage(amount: int) -> void:
	if dead:
		return
	var num = Globals.damage_number.instance() as Label
	num.text = str(amount)
	num.self_modulate = Color(1, .25, .25)
	if not has_hot:
		add_child(num)
	if not shielded:
		var new_health = max(health.value - amount, 0)
		if new_health <= 30:
			$Tween.interpolate_property(self, 'self_modulate', self_modulate, Color(1, 0.5, 0.5), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.interpolate_property(health, 'value', health.value, new_health, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
		if new_health <= 0:
			die()
	else:
		var new_health = max(shield.value - amount, 0)
		$Tween.interpolate_property(shield, 'value', shield.value, new_health, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()
		if new_health <= 0:
			remove_shield()

func heal(amount: int) -> void:
	if dead:
		return
	var num = Globals.damage_number.instance() as Label
	num.self_modulate = Color(.25, 1, .25)
	var new_health = min(health.value + amount, 100)
	num.text = str(amount)
	add_child(num)
	if new_health > 30:
		$Tween.interpolate_property(self, 'self_modulate', self_modulate, Color(1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property(health, 'value', health.value, new_health, 0.2, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()

func cure() -> void:
	$Tween.interpolate_property($DoT, 'modulate', $DoT.modulate, Color(1, 1, 1, 0), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	has_dot = false

func apply_heal_over_time_effect() -> void:
	has_hot = true
	$Tween.interpolate_property($HoT, 'modulate', $HoT.modulate, Color(1, 1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$HoTTimer.wait_time = 10
	$HoTTimer.start()

func apply_poison() -> void:
	has_dot = true
	$Tween.interpolate_property($DoT, 'modulate', $DoT.modulate, Color(1, 1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$DoTTimer.wait_time = 10
	$DoTTimer.start()
	$AnimationPlayer.play('Poison')

func apply_shield() -> void:
	shield.value = shield.max_value
	$Tween.interpolate_property(shield, 'modulate', shield.modulate, Color(1, 1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	shielded = true

func remove_shield() -> void:
	$Tween.interpolate_property(shield, 'modulate', shield.modulate, Color(1, 1, 1, 0), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	shielded = false

func _on_unit_selected(unit: UnitFrame) -> void:
	if not unit == self and Globals.player_target == self:
		deselect()

func die() -> void:
	emit_signal('unit_died')
	dead = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$HoverRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$HoverRect.visible = false
	$HealthBar.visible = false
	self_modulate = Color(0.5, 0.5, 0.5)
	$Tween.interpolate_property($Skull, 'modulate', Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	if Globals.player_target == self:
		deselect()
	$AttackTimer.stop()
	SignalManager.emit_signal('unit_died')

func _on_AttackTimer_timeout() -> void:
	randomize()
	SignalManager.emit_signal('boss_attacked', floor(rand_range(10, 100)))


func _on_DoTTimer_timeout() -> void:
	cure()


func _on_HoTTimer_timeout() -> void:
	$Tween.interpolate_property($HoT, 'modulate', $HoT.modulate, Color(1, 1, 1, 0), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	has_hot = false


func _on_EffectTicker_timeout() -> void:
	if has_dot:
		damage(7)
		yield($Tween, 'tween_all_completed')
	if has_hot:
		heal(5)

func _on_prayer_cast() -> void:
	heal(50)
