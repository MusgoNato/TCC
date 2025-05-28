class_name Bloco extends TextureRect

var estaNaAreaDisponivel = true
var arrastando = false
var of = Vector2(0,0)

# Essas variaveis serao carregadas dinamicamente atraves do json
var bloco_id = -1
var tipo = ""

# Carrega a cena em uma variavel
@export var blocoPadrao = preload("res://scenes/bloco.tscn")

# Responsavel por fazer o sistema de arrasto do objeto
func _get_drag_data(at_position: Vector2) -> Variant:
	# Evitar warnings	
	at_position = at_position
	
	# Preview do bloco sendo arrastado	
	var preview = TextureRect.new()
	preview.texture = texture
	preview.expand_mode = true
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size = custom_minimum_size
	set_drag_preview(preview)
		
	if estaNaAreaDisponivel:
		
		# Atualizo as propriedades do bloco		
		var novo_bloco = preload("res://scenes/bloco.tscn").instantiate()
		novo_bloco.estaNaAreaDisponivel = false
		novo_bloco.texture = self.texture
		novo_bloco.name = self.name
		novo_bloco.tipo = self.tipo
		novo_bloco.bloco_id = self.bloco_id
		
		novo_bloco.stretch_mode = self.stretch_mode
		novo_bloco.expand_mode = self.expand_mode
		novo_bloco.custom_minimum_size = self.custom_minimum_size
		
		# Atualizo o label		
		if self.has_node("Label") and novo_bloco.has_node("Label"):
			var original_label = self.get_node("Label")
			var novo_label = novo_bloco.get_node("Label")
			novo_label.text = original_label.text
		return novo_bloco
	else:
		return self
