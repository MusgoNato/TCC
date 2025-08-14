class_name Percurso_Manager extends Node

@onready var montagem: Montagem = $"../PaineisManager/LayerMontagem/MontagemBackground/Montagem"
@onready var sub_viewport: SubViewport = $PercursoLayer/SubViewportContainer/SubViewport
@onready var pause_fim_jogo: Pause_FimJogo = $"../TemporizadorFase/Pause_FimJogo"

signal envia_blocos_percurso(blocos)

func _ready() -> void:
	var percurso = preload("res://scenes/percurso.tscn").instantiate()
	sub_viewport.add_child(percurso)
	
	# Conecto o sinal para enviar os blocos ja montados
	self.connect("envia_blocos_percurso", Callable(percurso, "_on_envia_blocos_percurso"))
	
	# Conecto o sinal para o percurso, para chamar a funcao resposavel por mostrar a interface de fim de jogo
	percurso.connect("checkpoint_alcancado", Callable(pause_fim_jogo, "_on_checkpoint_alcancado"))

## Sinal conectado para emitir um sinal que envia os blocos montados no painel de montagem para a janela de percurso
func _on_executar_button_down() -> void:
	
	#var blocos = []
	
	# Serializo cada bloco para evitar que o jogo 'quebre' em caso do jogador retirar blocos em tempo
	# de processamento da execução do percurso do personagem
	#for bloco in montagem.get_children():
		#blocos.append(serializar_bloco(bloco))
	var blocos = montagem.get_children()
	
	if !blocos.is_empty():
		emit_signal("envia_blocos_percurso", blocos)	
		
#### Função responsável por serielizar cada bloco com suas respectivas propriedades
#func serializar_bloco(bloco) -> Dictionary:
	#
	#return {
		#"tipo": bloco.tipo, # Modificar + pra frente, colocando outras propriedades dos blocos
	#}
	
