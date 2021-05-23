extends TextureButton

export(String) var spell_number = '0'
export(Resource) var ability

var castable := true

func _ready() -> void:
	texture_normal = (ability as PlayerAbility).icon
	$SpellNumber.text = str(spell_number)
	SignalManager.connect('trigger_global_cooldown', self, '_on_global_cooldown_triggered')
	$SpellSFX.stream = (ability as PlayerAbility).sound_effect

func _process(delta: float) -> void:
	$CooldownProgress.value = $GCD.time_left * 100
	check_mana()

func _input(event: InputEvent) -> void:
	# this is crap but i'm running out of time
	if Globals.player_target:
		if event.is_action_pressed('cast_spell_1') and spell_number == '1' and castable:
			cast()
			Globals.player_target.heal(25)
		elif event.is_action_pressed('cast_spell_2') and spell_number == '2' and castable:
			cast()
			Globals.player_target.apply_heal_over_time_effect()
		elif event.is_action_pressed('cast_spell_3') and spell_number == '3' and castable:
			cast()
			Globals.player_target.cure()
		elif event.is_action_pressed('cast_spell_4') and spell_number == '4' and castable:
			cast()
			Globals.player_target.apply_shield()
		elif event.is_action_pressed('cast_spell_5') and spell_number == '5' and castable:
			cast()
			SignalManager.emit_signal('prayer_cast')

func disable() -> void:
	castable = false

func enable() -> void:
	castable = true

func _on_TextureButton_pressed() -> void:
	cast()

func _on_GCD_timeout() -> void:
	check_mana()

func _on_global_cooldown_triggered() -> void:
	disable()
	$Tween.interpolate_property($CooldownProgress, 'modulate', Color(0, 0, 0, 0), Color(0, 0, 0, 0.5), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	$GCD.start()

func cast() -> void:
	if not castable or not Globals.player_target:
		return
	randomize()
	$AudioStreamPlayer.pitch_scale = rand_range(0.9, 1.1)
	$AudioStreamPlayer.play()
	$SpellSFX.pitch_scale = rand_range(0.97, 1.03)
	$SpellSFX.play()
	for effect in (ability as PlayerAbility).effects:
		(Globals.player_target as Actor).add_effect(effect)
	SignalManager.emit_signal('player_used_mana', (ability as PlayerAbility).mana_cost)
	SignalManager.emit_signal('trigger_global_cooldown')
	print('Casted ' + (ability as PlayerAbility).ability_name + ' on ' + Globals.player_target.name)

func check_mana() -> void:
	if Globals.player_mana < (ability as PlayerAbility).mana_cost:
		$Tween.interpolate_property(self, 'self_modulate', self.self_modulate, Color(0.5, 0.5, 2), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		disable()
	else:
		$Tween.interpolate_property(self, 'self_modulate', self.self_modulate, Color(1, 1, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		if $GCD.is_stopped() and not castable:
			enable()


func _on_TextureButton_mouse_entered() -> void:
	SignalManager.emit_signal('spell_hovered', (ability as PlayerAbility).description)


func _on_TextureButton_mouse_exited() -> void:
		SignalManager.emit_signal('spell_hovered', '')
