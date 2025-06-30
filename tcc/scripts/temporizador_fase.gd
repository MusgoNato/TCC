class_name TemporizadorFase
extends Node

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

# Utilizando o temporizador para exibir a interface de pause, com o texto de 'Fim de jogo' ou 'jogo pausado',
# O outro script que faz o controle da alteracao de pause eh pauseFimJogo.gd
@onready var layer_pause_fim_jogo: CanvasLayer = $Pause_FimJogo/LayerPause_FimJogo
@onready var texto: Label = $Pause_FimJogo/LayerPause_FimJogo/Pause_Fim_de_Jogo/VBoxContainer/HBoxContainer/Texto

# Tempo de cada fase (8 = 8 segundos, 300 = 5 minutos), valor esta em segundos
var tempo_restante: int = 300

func _ready():
	# Inicia o timer para contar a cada 1 segundo
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.start()
	
	# Atualiza o label logo no início
	atualizar_label()

# Quando o tempo acabar, este sinal eh executado
func _on_timer_timeout():
	if tempo_restante > 0:
		tempo_restante -= 1
		atualizar_label()
	else:
		timer.stop()
		exibe_fimDejogo("Fim de jogo!")

func atualizar_label():
	var minutos = tempo_restante / 60
	var segundos = tempo_restante % 60
	label.text = "%02d:%02d" % [minutos, segundos]
	
func exibe_fimDejogo(mensagem: String):
	
	# Exibo a interface de fim de jogo
	layer_pause_fim_jogo.visible = true
	texto.text = mensagem
	
	# Altero a variavel de controle se esta ou nao em fim de jogo ou pausado
	var pause_fim_jogo = $Pause_FimJogo
	pause_fim_jogo.FimDeJogo = true
	
	# Pausa o jogo em geral
	get_tree().paused = true
