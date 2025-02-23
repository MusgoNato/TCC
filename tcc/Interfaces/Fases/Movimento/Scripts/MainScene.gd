extends Control

var data = null
@onready var AreaBlocosDisponiveis = $AreaBlocosDisponiveis/GridAreaBlocosDisponiveis


func _ready() -> void:
	var arquivoJson = FileAccess.open("res://BD-JSON/Fase_1/BlocosDisponiveis.json", FileAccess.READ)
	var conteudoEmString = arquivoJson.get_as_text()
	var ConteudoJsonEmDicionario = JSON.parse_string(conteudoEmString)
	data = ConteudoJsonEmDicionario
	
	inserirBlocosEmAreaDisponivel(data)
	
func inserirBlocosEmAreaDisponivel(data):
	for bloco in data['blocos']:
		var botao = TextureButton.new()
		# Adiciono as informações do bloco ao botao
		botao.texture_normal = load(bloco['icone'])				
		botao.tooltip_text = bloco['nome']
		botao.custom_minimum_size = Vector2(100, 100)
		
		# Conecta o sinal de clique a uma função personalizada
		botao.set_script(preload("res://Interfaces/Fases/Movimento/Scripts/bloco.gd"))
		
		# Adiciono o botao (bloco) a area de blocos disponiveis na fase		
		AreaBlocosDisponiveis.add_child(botao)
		
		# Espero 1 frame para carregamento do layout e pegar a posição inicial do bloco		
		await get_tree().process_frame
		await get_tree().process_frame
		botao.set_meta("posicao_inicial", botao.global_position)

	
