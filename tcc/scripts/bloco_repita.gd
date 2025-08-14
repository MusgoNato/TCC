extends "res://scripts/bloco.gd"


# Filhos dentro do bloco repita
var filhos = []

func _ready() -> void:
	
	self.tooltip_text = self.tipo
	
	# Como estou usando somente um script para os dois, melhor verificar se eh o repita inicio ou fim
	if self.has_node("VBoxContainer/SpinBox"):
		var spin_box = self.get_node("VBoxContainer/SpinBox")
		spin_box.min_value = 1
		spin_box.max_value = 10
		
		spin_box.update_on_text_changed = true	
