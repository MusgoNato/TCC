class_name Bloco
extends Control

var estaNaPaleta: bool = true
var arrastando: bool = false
var bloco_id: int = -1
var tipo: String = ""

@export var blocoPadrao = preload("res://scenes/bloco.tscn") # padrão fallback


func _ready() -> void:
	
	# Texto quando o mouse esta sobre o bloco
	self.tooltip_text = self.tipo
	

func _get_drag_data(at_position: Vector2) -> Variant:
	at_position = at_position
	
	var preview_bloco = self.duplicate()
	
	set_drag_preview(preview_bloco)
	
	if estaNaPaleta:
		# Clona o próprio bloco
		var novo_bloco = self.duplicate()
		
		novo_bloco.estaNaPaleta = false

		# Copia valores principais
		novo_bloco.tipo = self.tipo
		novo_bloco.bloco_id = self.bloco_id
		novo_bloco.name = self.name
		novo_bloco.custom_minimum_size = self.custom_minimum_size

		# Copia Texture (se houver)
		if self.has_node("TexturaBloco") and novo_bloco.has_node("TexturaBloco"):
			novo_bloco.get_node("TexturaBloco").texture = self.get_node("TexturaBloco").texture

		# Copia Label (se houver)
		if self.has_node("Label") and novo_bloco.has_node("Label"):
			novo_bloco.get_node("Label").text = self.get_node("Label").text

		# Copia valor do SpinBox, se for um bloco de repetição
		if self.has_node("VBoxContainer/SpinBox") and novo_bloco.has_node("VBoxContainer/SpinBox"):
			var valor = self.get_node("VBoxContainer/SpinBox").value
			novo_bloco.get_node("VBoxContainer/SpinBox").value = valor
		
		print("VINDO DA PALETA : PAI : ", novo_bloco.get_parent())
		return novo_bloco
	else:
		
		return self
