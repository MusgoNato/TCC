class_name Fase
extends Control

@onready var layer_instrucoes: CanvasLayer = $LayerInstrucoes
@onready var texto_instrucoes: RichTextLabel = $LayerInstrucoes/Panel/TextoInstrucoesIniciais
@onready var timer_instrucoes: Timer = $LayerInstrucoes/TimerInstrucoes

var etapa_atual: int = 0
const TEMPO_INSTRUCOES: int =  3

var instrucoes = [
	"Bem-vindo à fase de movimento!",
	"Arraste e solte os blocos disponiveis na area de montagem",
	"Clique em executar para visualizar o percuso do personagem",
	"Boa sorte!"
]

func _ready() -> void:
	timer_instrucoes.start(1.0)
	mostrar_instrucao()

func mostrar_instrucao() -> void:
	if etapa_atual < instrucoes.size():
		texto_instrucoes.text = instrucoes[etapa_atual]
		texto_instrucoes.show()
	else:
		texto_instrucoes.hide()
	timer_instrucoes.start(TEMPO_INSTRUCOES)
	etapa_atual += 1

func _on_timer_instrucoes_timeout() -> void:
	if etapa_atual >= instrucoes.size():
		layer_instrucoes.visible = false
		timer_instrucoes.stop()
		print("Timer de Instruções encerrado")
		return
	mostrar_instrucao()
