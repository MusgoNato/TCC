extends Control

var last_unlocked_level: int = 0

@onready var btn_fase_1: Button = $Container_fases/HBoxContainer/VBoxContainer/btnFase1
@onready var btn_condições: Button = $Container_fases/HBoxContainer2/VBoxContainer/btn_condições
@onready var btn_repetições: Button = $Container_fases/HBoxContainer3/VBoxContainer/btn_repetições
@onready var btn_funções: Button = $Container_fases/HBoxContainer4/VBoxContainer/btn_funções

@onready var pontuacaoFase1: RichTextLabel = $Container_fases/HBoxContainer/VBoxContainer/pontuacaoFase1
@onready var pontuacaoFase2: RichTextLabel = $Container_fases/HBoxContainer2/VBoxContainer/pontuacaoFase2
@onready var pontuacaoFase3: RichTextLabel = $Container_fases/HBoxContainer3/VBoxContainer/pontuacaoFase3
@onready var pontuacaoFase4: RichTextLabel = $Container_fases/HBoxContainer4/VBoxContainer/pontuacaoFase4


# Configurações do carregamento
func _ready() -> void:
	# 1. Carrega o progresso do jogador
	last_unlocked_level = SaveManager.carregar_progresso()
	
	# impressao para o ultimo nivel desbloqueado
	if GlobalScript.info_debug:
		print(last_unlocked_level)
	atualizar_botoes()
	
	# 2. Carrega as pontuações da fase DENTRO do _ready()
	var pontuacoes = SaveManager.carregar_todas_pontuacoes()
	if GlobalScript.info_debug:
		print("Pontuacoes do jogador : ", pontuacoes)
	# 3. Atualiza as pontuações na tela
	atualizar_pontuacoes(pontuacoes)
	
func atualizar_pontuacoes(pontuacoes):
	
	var labels = {
		1: pontuacaoFase1,
		2: pontuacaoFase2,
		3: pontuacaoFase3,
		4: pontuacaoFase4
	}
	
	# Cores das estrelas
	var cor_estrela_cheia = "[color=#FFD700]★[/color]" # Dourado
	var cor_estrela_vazia = "[color=#808080]☆[/color]" # Cinza
	
	for num_fase in labels.keys():
		var richt_text_alvo: RichTextLabel = labels[num_fase]
		
		# 1. Verifica se a fase está desbloqueada antes de exibir as estrelas
		if num_fase <= last_unlocked_level:
			var pontuacao = pontuacoes.get(str(num_fase), 0)
			
			richt_text_alvo.bbcode_enabled = true
			richt_text_alvo.fit_content = true
			
			var texto_estrelas: String = ""
			for i in range(1, 4):
				if i <= pontuacao:
					texto_estrelas += cor_estrela_cheia
				else:
					texto_estrelas += cor_estrela_vazia
			richt_text_alvo.text = texto_estrelas
		else:
			# 2. Se a fase não está desbloqueada, não exibe estrelas.
			richt_text_alvo.text = ""
			
func atualizar_botoes():
	btn_fase_1.disabled = (last_unlocked_level < 1)
	btn_condições.disabled = (last_unlocked_level < 2)
	btn_repetições.disabled = (last_unlocked_level < 3)
	btn_funções.disabled = (last_unlocked_level < 4)

# Volta ao menu inicial
func _on_label_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

# Entra na fase de tutorial
func _on_btn_fase_tutorial_pressed() -> void:
	GlobalScript.fase_selecionada = 0
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Entra na fase de movimento
func _on_btn_fase_1_pressed() -> void:
	GlobalScript.fase_selecionada = 1
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Entra na fase de condições    
func _on_btn_condições_button_down() -> void:
	GlobalScript.fase_selecionada = 2
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Entra na fase de repetições
func _on_btn_repetições_pressed() -> void:
	GlobalScript.fase_selecionada = 3
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Entra na fase de funções
func _on_btn_funções_button_down() -> void:
	GlobalScript.fase_selecionada = 4
	get_tree().change_scene_to_file("res://scenes/game.tscn")
