extends Label

func _ready() -> void:
	SignalManager.connect('spell_hovered', self, '_on_spell_hovered')

func _on_spell_hovered(description: String) -> void:
	text = description
