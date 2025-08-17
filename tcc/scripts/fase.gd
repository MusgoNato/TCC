class_name Fase
extends Control

@onready var layer_instrucoes: CanvasLayer = $LayerInstrucoes
@onready var texto_instrucoes: RichTextLabel = $LayerInstrucoes/Panel/TextoInstrucoesIniciais
@onready var timer_instrucoes: Timer = $LayerInstrucoes/TimerInstrucoes

var etapa_atual: int = 0
const TEMPO_INSTRUCOES: int = 1

# Intruções carregadas do script global (O json, dados para pre-carregamento dos blocos funciona de forma diferente o acesso por indices, sendo o inicial 1 e nao 0 (EM STR)
var instrucoes = GlobalScript.texto_instrucoes_iniciais[GlobalScript.fase_selecionada - 1]

func _ready() -> void:
	
	timer_instrucoes.start(1.0)
	mostrar_instrucao()

## Função responsável por mostrar as intruções inicias para cada fase do jogo
func mostrar_instrucao() -> void:
	if etapa_atual < instrucoes.size():
		texto_instrucoes.text = instrucoes[etapa_atual]
		texto_instrucoes.show()
	else:
		texto_instrucoes.hide()
	timer_instrucoes.start(TEMPO_INSTRUCOES)
	etapa_atual += 1

## Sinal de timer conectado para controlar o tempo das instruções iniciais da fase na tela
func _on_timer_instrucoes_timeout() -> void:
	if etapa_atual >= instrucoes.size():
		layer_instrucoes.visible = false
		timer_instrucoes.stop()
		print("Timer de Instruções encerrado")
		return
	mostrar_instrucao()
