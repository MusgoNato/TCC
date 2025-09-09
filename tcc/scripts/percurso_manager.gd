class_name Percurso_Manager extends Node

@onready var montagem: Montagem = $"../PaineisManager/LayerMontagem/MontagemBackground/Montagem"
@onready var sub_viewport: SubViewport = $PercursoLayer/SubViewportContainer/SubViewport
@onready var pause_fim_jogo: Pause_FimJogo = $"../TemporizadorFase/Pause_FimJogo"
@onready var montagem_funcao: HBoxContainer = $"../LayerFuncao/MontagemFuncaoBackground/MontagemFuncao"

# Sinal criado para quando apertar o botao 'executar'
signal envia_blocos_percurso(blocos, blocos_internos_funcao)

func _ready() -> void:
	var percurso = null
	match GlobalScript.fase_selecionada:
		1:
			percurso = preload("res://scenes/percurso.tscn").instantiate()
		2:
			percurso = preload("res://scenes/percurso_fase_cond.tscn").instantiate()
		3:
			percurso = preload("res://scenes/percurso_fase_rep.tscn").instantiate()
		4:
			percurso = preload("res://scenes/percurso_fase_func.tscn").instantiate()
	
	sub_viewport.add_child(percurso)
	
	# Conecto o sinal para enviar os blocos ja montados
	self.connect("envia_blocos_percurso", Callable(percurso, "_on_envia_blocos_percurso"))
	
	# Conecto o sinal para o percurso, para chamar a funcao resposavel por mostrar a interface de fim de jogo
	percurso.connect("checkpoint_alcancado", Callable(pause_fim_jogo, "_on_checkpoint_alcancado"))

## Sinal conectado para emitir um sinal que envia os blocos montados no painel de montagem para a janela de percurso
func _on_executar_button_down() -> void:
	
	var blocos = montagem.get_children()
	var blocos_internos_funcao = montagem_funcao.get_children()
	
	if !blocos.is_empty():
		emit_signal("envia_blocos_percurso", blocos, blocos_internos_funcao)	
		
