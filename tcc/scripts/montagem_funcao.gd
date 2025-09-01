extends "res://scripts/montagem.gd"

func _ready() -> void:
	self.add_theme_constant_override("separation", 32)
	montagem_principal = false
