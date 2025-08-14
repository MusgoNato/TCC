extends Node

@onready var montagem: Montagem = $LayerMontagem/MontagemBackground/Montagem
@onready var mensagem: Label = $"../Mensagem"

# Configuração dos paineis
func _ready() -> void:
	montagem.add_theme_constant_override("separation", 32)	
	montagem.connect("mensagem_solicitada", Callable(self, "_on_mensagem_solicitada")) 

## Função responável por exibir dicas, mensagens, avisos, erros, etc.
func _on_mensagem_solicitada(texto: String):
	mensagem.text = texto
	mensagem.visible = true
	var tween := create_tween()
	mensagem.modulate.a = 0
	tween.tween_property(mensagem, "modulate:a", 1.0, 0.2)
	await get_tree().create_timer(2.0).timeout
	var fade_out := create_tween()
	fade_out.tween_property(mensagem, "modulate:a", 0.0, 0.3)
	await fade_out.finished
	mensagem.visible = false
