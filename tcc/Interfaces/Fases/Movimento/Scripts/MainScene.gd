extends Control

var data = null
@onready var paleta: GridContainer = $Paleta/ScrollContainer/BlocosDisponiveis
const BLOCO_CENA := preload("res://Interfaces/Fases/Movimento/scenes/bloco.tscn")

func _ready() -> void:
	var arquivoJson = FileAccess.open("res://BD-JSON/Fase_1/BlocosDisponiveis.json", FileAccess.READ)
	var conteudoEmString = arquivoJson.get_as_text()
	var ConteudoJsonEmDicionario = JSON.parse_string(conteudoEmString)
	data = ConteudoJsonEmDicionario
	print(data)
	inserirBlocosEmAreaDisponivel(data)

#
func inserirBlocosEmAreaDisponivel(data):
	for item in data:
		var bloco = BLOCO_CENA.instantiate()
		if bloco is Bloco:
			push_error("Instancia invalida do bloco")
			continue
			
		if item.has("name"):
			bloco.name = item["name"]
		if item.has("id"):
			bloco.set_meta("_ID", item["id"])
		if item.has("image"):
			var image = load(item["image"])
			if image:
				bloco.texture = image
			else:
				printerr("Erro ao carregar a imagem : ", item["image"])
		bloco.estaNaAreaDisponivel = true
		paleta.add_child(bloco)
