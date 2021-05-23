extends Node


signal scene_loaded
signal scene_unloaded
signal slide_down_start
signal slide_down_finish
signal slide_up_start
signal slide_up_finish
signal toggle_boss_health
signal boss_killed
signal player_used_mana(amount)
# Sends the newly calculated health total of the boss
signal boss_health_changed(new_health)
signal player_started_casting
signal player_casting_finished
signal unit_selected(unit)
signal trigger_global_cooldown
signal unit_died
signal boss_attacked
signal spell_hovered(description)
signal prayer_cast
