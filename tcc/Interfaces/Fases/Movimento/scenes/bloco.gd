class_name Bloco
extends TextureRect

# --- Configurações do Bloco ---
@export var blocoPadrao: PackedScene = preload("res://Interfaces/Fases/Movimento/scenes/bloco.tscn")  # Referência a si mesmo
var estaNaAreaDisponivel: bool = true
var arrastando: bool = false

# --- Identificação única por instância ---
var instancia_id: int
static var id_sequencial: int = 0

# Dados do JSON
var bloco_id: int = -1
var bloco_nome: String = ""
var bloco_imagem: Texture

func _ready() -> void:
	if not estaNaAreaDisponivel:
		instancia_id = id_sequencial
		id_sequencial += 1

	# Exibe informações para depuração
	print("Bloco instanciado: ", name, " | ID json: ", bloco_id, " | ID instância: ", instancia_id)

# --- Sistema de Arrastar ---
func _get_drag_data(at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.texture = self.texture
	preview.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	preview.custom_minimum_size = self.size
	set_drag_preview(preview)

	if estaNaAreaDisponivel:
		# Clona o bloco base (instancia nova cópia)
		var novo_bloco: Bloco = blocoPadrao.instantiate()
		novo_bloco.estaNaAreaDisponivel = false

		# Copia os dados JSON para o novo bloco
		novo_bloco.texture = self.texture
		novo_bloco.name = self.name
		novo_bloco.bloco_id = self.bloco_id
		novo_bloco.bloco_nome = self.bloco_nome
		novo_bloco.bloco_imagem = self.bloco_imagem

		return novo_bloco
	else:
		arrastando = false
		return self
