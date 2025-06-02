class_name Percurso_Manager extends Node

@onready var sub_viewport_container: SubViewportContainer = $PercursoLayer/SubViewportContainer
@onready var montagem: Montagem = $"../PaineisManager/LayerMontagem/MontagemBackground/Montagem"
signal envia_blocos_percurso(blocos)

func _ready() -> void:
	var percurso = preload("res://scenes/percurso.tscn").instantiate()
	sub_viewport_container.add_child(percurso)
	
	# Conecto o sinal para enviar os blocos ja montados
	self.connect("envia_blocos_percurso", Callable(percurso, "_on_envia_blocos_percurso"))

func _on_executar_button_down() -> void:
	var blocos = montagem.get_children()
	if !blocos.is_empty():
		emit_signal("envia_blocos_percurso", blocos)
