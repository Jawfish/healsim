extends Resource
class_name PlayerAbility

export (String) var ability_name
export (String, MULTILINE) var description
export (Array, PackedScene) var effects
export (float) var cast_time
export (Texture) var icon
export (int) var mana_cost
export (AudioStreamOGGVorbis) var sound_effect
