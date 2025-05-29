class_name JsonManager extends Node

var data = null
var bloco_modelo = preload("res://scenes/bloco.tscn")
@onready var paleta: GridContainer = $"../PaineisManager/LayerPaleta/PainelDisponivel/ScrollContainer/Paleta"

func _ready() -> void:
	data = get_dados_blocos()
	inserirBlocosEmAreaDisponivel(data)

func get_dados_blocos():
	var arquivoJson = FileAccess.open("res://utils/dados.json", FileAccess.READ)
	var conteudoEmString = arquivoJson.get_as_text()
	var ConteudoJsonEmDicionario = JSON.parse_string(conteudoEmString)
	data = ConteudoJsonEmDicionario
	return data

func inserirBlocosEmAreaDisponivel(dados: Variant):
	for item in dados:
		var bloco = bloco_modelo.instantiate()
		bloco.name = item["name"]
		bloco.texture = load(item["image"])
		bloco.bloco_id = item["id"]
		bloco.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		bloco.expand = true
		bloco.custom_minimum_size = Vector2(64,64)
		var label = bloco.get_node("Label")
		label.text = item["tipo"]
		bloco.tipo = item["tipo"]
		bloco.estaNaAreaDisponivel = true
		paleta.add_child(bloco)
