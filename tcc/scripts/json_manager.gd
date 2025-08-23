class_name JsonManager extends Node

var data = null

# Modelo dos blocos (movimento, repita, condicionais, funcoes)
var bloco_modelo = preload("res://scenes/bloco.tscn")
var bloco_repita_inic_modelo = preload("res://scenes/bloco_repita_inic.tscn")
var bloco_repita_fim_modelo = preload("res://scenes/bloco_repita_fim.tscn")
var bloco_condicao_modelo = preload("res://scenes/bloco_condicao.tscn")

var fase_selecao: String = "0"
@onready var paleta: GridContainer = $"../PaineisManager/LayerPaleta/PainelDisponivel/ScrollContainer/Paleta"

func _ready() -> void:
	data = get_dados_blocos()
	fase_selecao = str(GlobalScript.fase_selecionada)
	inserirBlocosEmAreaDisponivel(data, fase_selecao)

## Funcao responsavel por extrair informacoes do arquivo JSON para
## que estas sejam usadas para popular a interface do jogo
func get_dados_blocos():
	
	var arquivoJson = FileAccess.open("res://utils/dados.json", FileAccess.READ)
	var conteudoEmString = arquivoJson.get_as_text()
	var ConteudoJsonEmDicionario = JSON.parse_string(conteudoEmString)
	data = ConteudoJsonEmDicionario
	return data

## Funcao responsavel por popular a paleta de blocos de acordo com a fase selecionada
func inserirBlocosEmAreaDisponivel(dados: Variant, fase_atual: String):
	for item in dados[fase_atual]:
		var bloco: Control 
		match item["tipo"]:
			"repita_inicio":
				# Instancia o tipo Control (estrutura mais complexa)
				bloco = bloco_repita_inic_modelo.instantiate()
						
			"repita_fim":
				bloco = bloco_repita_fim_modelo.instantiate()
		
			"cima", "baixo", "esquerda", "direita":
				bloco = bloco_modelo.instantiate()
				
			"condicional":
				bloco = bloco_condicao_modelo.instantiate()
				
		if bloco:
			
			# Defino o tamanho padrao do asset e verifico se o node de textura existe ou nao
			# para aplica-lo.
			bloco.custom_minimum_size = Vector2(64,64)	
			if bloco.has_node("TexturaBloco"):
				var tex_rect = bloco.get_node("TexturaBloco")
				tex_rect.texture = load(item["image"])					
				tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				tex_rect.expand = true
				tex_rect.custom_minimum_size = Vector2(64, 64)
				
			bloco.name = item["name"]
			bloco.tipo = item["tipo"]
			bloco.bloco_id = item["id"]
			bloco.estaNaPaleta = true
			paleta.add_child(bloco)
