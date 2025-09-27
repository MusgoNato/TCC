extends Control

@onready var carregar: Button = $MarginContainer/VBoxContainer/VBoxContainer/carregar

func _ready() -> void:
	# Caso nao haja save, desabilito o botao
	var progresso = SaveManager.carregar_progresso()
	
	# Carrega os valores do save do disco para as variáveis globais.
	SaveManager.carregar_config_utilitarios()
	if progresso == 0:
		carregar.disabled = true
	else:
		carregar.disabled = false

# Comandos para quando os botões forem presisonados (começar jogo, configurações e saida do jogo)
func _on_play_pressed() -> void:
	# Um novo save criado, volta com o valor inicial (Liberado somente a fase 1)
	SaveManager.resetar_salvamento()
	SaveManager.salvar_progresso(0)
	get_tree().change_scene_to_file("res://scenes/fases.tscn")

# Carrega o jogo
func _on_carregar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fases.tscn")

# Configurações do jogo
func _on_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/config.tscn")

# Saida
func _on_quit_pressed() -> void:
	get_tree().quit()
