extends Control

@onready var layer_instrucoes: CanvasLayer = $LayerInstrucoes
@onready var texto_instrucoes: RichTextLabel = $LayerInstrucoes/Panel/TextoInstrucoesIniciais
@onready var timer_instrucoes: Timer = $LayerInstrucoes/TimerInstrucoes
@onready var layer_funcao: CanvasLayer = $LayerFuncao
@onready var layer_tutorial: CanvasLayer = $LayerTutorial
@onready var texto_tutorial: RichTextLabel = $LayerTutorial/TextoTutorial  # Label central invisível no editor

var etapa_atual: int = 0
const FASE_FUNCAO: int = 4
const FASE_TUTORIAL_: int = 0

var instrucoes = GlobalScript.texto_instrucoes_iniciais[GlobalScript.fase_selecionada]

var nos_destaques_tutorial = []
var indice_destaque: int = 0
var indice_instrucao: int = 0
var tutorial_ativo: bool = false
var destaque_anterior: Node = null

func _ready() -> void:
	if GlobalScript.fase_selecionada == FASE_FUNCAO:
		layer_funcao.visible = true
		
	texto_instrucoes.bbcode_enabled = true
	texto_tutorial.bbcode_enabled = true
	texto_tutorial.hide()
	timer_instrucoes.start(1.0)
	mostrar_instrucao()

func mostrar_instrucao() -> void:
	if etapa_atual < instrucoes.size():
		texto_instrucoes.text = instrucoes[etapa_atual]
		texto_instrucoes.show()
		timer_instrucoes.start(GlobalScript.TEMPO_INSTRUCOES_INICIAS)
		etapa_atual += 1
	else:
		layer_instrucoes.visible = false
		texto_instrucoes.hide()
		
		if GlobalScript.fase_selecionada == FASE_TUTORIAL_:
			layer_tutorial.visible = true
			nos_destaques_tutorial = layer_tutorial.get_children()
			tutorial_ativo = true
			indice_destaque = 0
			indice_instrucao = 0
			mostrar_destaque()
			mostrar_instrucao_tutorial()

func _on_timer_instrucoes_timeout() -> void:
	mostrar_instrucao()

func mostrar_destaque() -> void:
	if destaque_anterior:
		destaque_anterior.visible = false
		destaque_anterior = null
	
	if indice_destaque < nos_destaques_tutorial.size():
		var node = nos_destaques_tutorial[indice_destaque]
		node.visible = true
		node.scale = Vector2(0.5, 0.5)

		var tween = create_tween()
		tween.tween_property(node, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		destaque_anterior = node
	else:
		tutorial_ativo = false
		texto_tutorial.hide()
		if GlobalScript.info_debug:
			print("Tutorial finalizado.")

func mostrar_instrucao_tutorial() -> void:
	if indice_instrucao < GlobalScript.msg_tutorial.size():
		texto_tutorial.text = GlobalScript.msg_tutorial[indice_instrucao]
		texto_tutorial.show()
	else:
		texto_tutorial.hide()

func _input(event: InputEvent) -> void:
	if tutorial_ativo and event.is_action_pressed("ui_accept"):
		indice_destaque += 1
		mostrar_destaque()

		if indice_instrucao < GlobalScript.msg_tutorial.size():
			indice_instrucao += 1
			mostrar_instrucao_tutorial()
