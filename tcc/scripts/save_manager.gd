extends Node

const SAVE_PATH = "user://progresso.json"
const SAVE_SETTINGS_PATH = "user://settings.json"
const PONTUACAO_PATH = "user://pontuacoes.json"

# Salva a última fase desbloqueada como um número inteiro.
func salvar_progresso(last_unlocked_level: int):
	var progresso_atual = carregar_progresso()
	
	if last_unlocked_level > progresso_atual:
		
		var save_data = {
			"last_unlocked_level": last_unlocked_level
		}
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if file == null:
			print("Erro ao abrir arquivo para salvar!")
			return
		var json_string = JSON.stringify(save_data)
		file.store_string(json_string)
		file.close()
		print("Progresso salvo: Fase ", last_unlocked_level)
	else:
		print("Novo progresso não é maior que o atual, nada foi salvo!")

# Carrega a última fase desbloqueada. Retorna 0 se não houver save.
func carregar_progresso() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		print("Nenhum arquivo de progresso encontrado.")
		return 0
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		print("Erro ao abrir arquivo para carregar!")
		return 0
	var content = file.get_as_text()
	file.close()
	var json_result = JSON.parse_string(content)
	if not json_result:
		print("Erro ao analisar o arquivo de salvamento!")
		return 0
	return int(json_result.get("last_unlocked_level", 0))

# --- Novas funções para salvar e carregar a pontuação ---

# Salva a pontuação (estrelas) para uma fase específica.
# Só salva se a nova pontuação for maior que a anterior.
func salvar_pontuacao_fase(fase: int, pontuacao: int):
	var data: Dictionary = {}
	
	# 1. Carrega os dados de pontuação existentes, se o arquivo existir.
	if FileAccess.file_exists(PONTUACAO_PATH):
		var file = FileAccess.open(PONTUACAO_PATH, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		var json_result = JSON.parse_string(content)
		if json_result:
			data = json_result
	
	# 2. Converte a chave da fase para uma string para usar no dicionário
	var fase_key = str(fase)
	
	# 3. Verifica se a nova pontuação é maior que a anterior.
	# O `get` retorna 0 se a chave não existir.
	var pontuacao_anterior: int = data.get(fase_key, 0)
	if pontuacao > pontuacao_anterior:
		data[fase_key] = pontuacao
		
		# 4. Salva o dicionário de volta no arquivo.
		var file = FileAccess.open(PONTUACAO_PATH, FileAccess.WRITE)
		if file == null: return
		var json_string = JSON.stringify(data)
		file.store_string(json_string)
		file.close()
		print("Pontuação da fase ", fase, " salva: ", pontuacao, " estrelas.")

# Carrega a pontuação de uma fase específica.
func carregar_pontuacao_fase(fase: int) -> int:
	if not FileAccess.file_exists(PONTUACAO_PATH):
		return 0
	
	var file = FileAccess.open(PONTUACAO_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var json_result = JSON.parse_string(content)
	if not json_result: return 0
	
	# Retorna a pontuação da fase, ou 0 se a fase não tiver pontuação salva.
	return int(json_result.get(str(fase), 0))
	
func carregar_todas_pontuacoes() -> Dictionary:
	if not FileAccess.file_exists(PONTUACAO_PATH):
		return {} # Retorna um dicionário vazio se o arquivo não existir.
	
	var file = FileAccess.open(PONTUACAO_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var json_result = JSON.parse_string(content)
	if not json_result:
		return {}
	
	return json_result
	

func resetar_salvamento():
	var dir = DirAccess.open("user://")
	if dir == null:
		print("Erro ao abrir diretório do usuário para resetar o save.")
		return
		
	# Apaga o arquivo de progresso
	if dir.file_exists("progresso.json"):
		dir.remove("progresso.json")
		print("Arquivo de progresso resetado.")
	
	# Apaga o arquivo de pontuações
	if dir.file_exists("pontuacoes.json"):
		dir.remove("pontuacoes.json")
		print("Arquivo de pontuações resetado.")
		

# Salva as configurações de brilho, som e dicas em um arquivo JSON.
func salvar_config_utilitarios():
	# Cria um dicionário com os dados a serem salvos
	var config_data = {
		"brilho": GlobalScript.valor_brilho_config,
		"som": GlobalScript.valor_som_config,
		"dicas_ativas": GlobalScript.dicas_config
	}

	# Tenta abrir o arquivo para escrita
	var file = FileAccess.open(SAVE_SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		print("Erro ao abrir arquivo para salvar as configurações!")
		return

	# Converte o dicionário para uma string JSON e salva no arquivo
	var json_string = JSON.stringify(config_data)
	file.store_string(json_string)
	file.close()
	print("Configurações salvas com sucesso!")

# Carrega as configurações do arquivo JSON. Se o arquivo não existir, usa os valores padrão.
func carregar_config_utilitarios():
	# Verifica se o arquivo de save existe
	if not FileAccess.file_exists(SAVE_SETTINGS_PATH):
		print("Arquivo de configurações não encontrado. Usando valores padrão.")
		return

	# Tenta abrir o arquivo para leitura
	var file = FileAccess.open(SAVE_SETTINGS_PATH, FileAccess.READ)
	if file == null:
		print("Erro ao abrir arquivo para carregar as configurações!")
		return

	# Lê o conteúdo do arquivo
	var content = file.get_as_text()
	file.close()

	# Analisa a string JSON para converter em um dicionário
	var json_result = JSON.parse_string(content)
	if not json_result is Dictionary:
		print("Erro ao analisar o arquivo de configurações JSON!")
		return

	var config_data = json_result as Dictionary
	
	# Atualiza as variáveis globais com os valores do arquivo, se existirem
	if config_data.has("brilho"):
		GlobalScript.valor_brilho_config = float(config_data["brilho"])
	if config_data.has("som"):
		GlobalScript.valor_som_config = float(config_data["som"])
	if config_data.has("dicas_ativas"):
		GlobalScript.dicas_config = bool(config_data["dicas_ativas"])

	print("Configurações carregadas com sucesso.")
