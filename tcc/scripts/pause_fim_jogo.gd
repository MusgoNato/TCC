class_name Pause_FimJogo
extends Node

@onready var layer_pause_fim_jogo: CanvasLayer = $LayerPause_FimJogo
@onready var texto: Label = $LayerPause_FimJogo/Pause_Fim_de_Jogo/VBoxContainer/HBoxContainer/Texto

var pausado : bool = false
var FimDeJogo : bool = false
var checkpoints_atingidos: bool = false

# Inputs do teclado
func _unhandled_input(event: InputEvent) -> void:
	
	# Bloquia pause do teclado caso o jogador tenha perdido ou ganho a partida, 
	# obrigando a ele reiniciar o jogo ou voltar ao menu principal
	if FimDeJogo || checkpoints_atingidos:
		return
	if event.is_action_pressed("pausar"):
		alternar_pause()

# Alternar entre o pause
func alternar_pause():
	pausado = !pausado
	get_tree().paused = pausado
	layer_pause_fim_jogo.visible = pausado
	if pausado:
		texto.text = "Jogo Pausado"
		
# Funcao para tornar visivel a tela de fim de jogo ao alcancar o checkpoint
func _on_checkpoint_alcancado(qtd_checkpoint: int):
	qtd_checkpoint = qtd_checkpoint
	checkpoints_atingidos = true
	layer_pause_fim_jogo.visible = true
	texto.text = "Parabéns!, você completou a fase"
	get_tree().paused = true
	
# Sinais dos botoes da interface de pause
func _on_btn_reiniciar_fase_button_down() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_menu_principal_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/fases.tscn")
