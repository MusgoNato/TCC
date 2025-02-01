extends Control

# Dicionario global
var data = {}


func _on_btn_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://Interfaces/Menu_fases/View_fases.tscn")


# Aqui vai carregar minha base de dados (JSON) contendo os blocos disponiveis para esta fase
func _ready() -> void:
	carregar_json()
	
# Responsavel pelo carregamento do JSON e transformar ele em um dicionario para ser reutilizado em outras funções
func carregar_json():
	# Caso o arquivo nao seja carregado, saio da funcao	
	if not FileAccess.file_exists("res://BD-JSON/Fase_1/BlocosDisponiveis.json"):
		return
	
	# Leio o conteudo do arquivo e passo ele como texto a variavel	
	var arquivo = FileAccess.open("res://BD-JSON/Fase_1/BlocosDisponiveis.json", FileAccess.READ)
	var conteudoArquivo = arquivo.get_as_text()
	arquivo.close()
	
	var json = JSON.new()
	var parse_result = json.parse(conteudoArquivo)
	
	if parse_result != OK:
		print("Erro ao carregar o arquivo json")
		return
	
	data = json.data
	
	if(typeof(data) != TYPE_DICTIONARY):
		print("Formato invalido")
		return


func get_blocos_disponiveis() -> Array:
	if data.has("blocos"):
		return data['blocos']
	else:
		return []
