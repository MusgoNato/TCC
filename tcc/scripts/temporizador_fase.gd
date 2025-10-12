class_name TemporizadorFase
extends Node

# Temporizador e o texto para o mesmo
@onready var timer: Timer = $Timer
@onready var label: Label = $Label

# Utilizando o temporizador para exibir a interface de pause, com o texto de 'Fim de jogo' ou 'jogo pausado',
# O outro script que faz o controle da alteracao de pause eh pauseFimJogo.gd
@onready var layer_pause_fim_jogo: CanvasLayer = $Pause_FimJogo/LayerPause_FimJogo
@onready var texto: Label = $Pause_FimJogo/LayerPause_FimJogo/Pause_Fim_de_Jogo/VBoxContainer/HBoxContainer/Texto

# Tempo de cada fase (8 = 8 segundos, 300 = 5 minutos), valor esta em segundos
# 10 minutos a duracao de cada fase (1m a mais para o tempo das instrucoes)
@export var tempo_restante: int = 660

func _ready():
	# Inicia o timer para contar a cada 1 segundo
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.start()
	
	# Atualiza o label logo no início
	atualizar_label()

## Sinal conectado, quando o timer acabar esta função será executada, mostrando o texto de fim de jogo
func _on_timer_timeout():
	if tempo_restante > 0:
		tempo_restante -= 1
		atualizar_label()
	else:
		timer.stop()
		exibe_fimDejogo("Fim de jogo!")

## Função responsável por atualizar o texto de tempo na tela
func atualizar_label():
	var minutos = tempo_restante / 60
	var segundos = tempo_restante % 60
	label.text = "%02d:%02d" % [minutos, segundos]
	
## Função responsável por exibir a mensagem de fim de jogo na tela
func exibe_fimDejogo(mensagem: String):
	
	# Exibo a interface de fim de jogo
	layer_pause_fim_jogo.visible = true
	texto.text = mensagem
	
	# Altero a variavel de controle se esta ou nao em fim de jogo ou pausado
	var pause_fim_jogo = $Pause_FimJogo
	pause_fim_jogo.FimDeJogo = true
	
	# Pausa o jogo em geral
	get_tree().paused = true
