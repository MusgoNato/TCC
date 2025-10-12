extends "res://scripts/montagem.gd"

func _ready() -> void:
	# Separacao entre os blocos da interface de montagem
	self.add_theme_constant_override("separation", 32)
	montagem_principal = false
