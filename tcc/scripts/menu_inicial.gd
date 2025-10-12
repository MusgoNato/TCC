extends Control

# Botao para carregar jogo
@onready var carregar: Button = $MarginContainer/VBoxContainer/VBoxContainer/carregar

func _ready() -> void:
	
	# Inicializacao do brilho da interface
	GlobalEffects.set_brilho(GlobalScript.valor_brilho_config)
	
	# Carrego o progesso, caso nao exista desabilito o botao de carregar
	var progresso = SaveManager.carregar_progresso()
	
	if progresso == 0:
		carregar.disabled = true
	else:
		carregar.disabled = false

## Sinal para o novo jogo
func _on_play_pressed() -> void:
	# Um novo save criado, volta com o valor inicial (Liberado somente a fase 1)
	SaveManager.resetar_salvamento()
	SaveManager.salvar_progresso(0)
	get_tree().change_scene_to_file("res://scenes/fases.tscn")

## Sinal para carregar o jogo
func _on_carregar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fases.tscn")

## Sinal para configurações do jogo
func _on_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/config.tscn")

## Sinal para saida
func _on_quit_pressed() -> void:
	get_tree().quit()
