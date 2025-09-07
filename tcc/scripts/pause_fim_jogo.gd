class_name Pause_FimJogo
extends Node

@onready var layer_pause_fim_jogo: CanvasLayer = $LayerPause_FimJogo
@onready var texto: Label = $LayerPause_FimJogo/Pause_Fim_de_Jogo/VBoxContainer/HBoxContainer/Texto
@onready var timer: Timer = $"../Timer"
@onready var temporizador_fase: TemporizadorFase = $".."
@onready var pontuacao: RichTextLabel = $LayerPause_FimJogo/Pause_Fim_de_Jogo/VBoxContainer/HBoxContainer2/pontuacao

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
	var estrelas_ganhas: int = 0
	if temporizador_fase.tempo_restante >= GlobalScript.PONTUACAO_3_ESTRELAS:
		estrelas_ganhas = 3
	elif temporizador_fase.tempo_restante >= GlobalScript.PONTUACAO_2_ESTRELAS:
		estrelas_ganhas = 2
	elif temporizador_fase.tempo_restante >= GlobalScript.PONTUACAO_1_ESTRELA:
		estrelas_ganhas = 1
	else:
		estrelas_ganhas = 0
		
	# Salva o progresso e pontuacao
	SaveManager.salvar_pontuacao_fase(GlobalScript.fase_selecionada, estrelas_ganhas)
	SaveManager.salvar_progresso(GlobalScript.fase_selecionada + 1)
	
	
	texto.text = "Parabéns!, você completou a fase"
	pontuacao.text += str(estrelas_ganhas)
	get_tree().paused = true
	
# Sinais dos botoes da interface de pause
func _on_btn_reiniciar_fase_button_down() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_menu_principal_button_down() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/fases.tscn")
