extends RichTextLabel

# Configuração dos paineis
func _ready() -> void:
	
	# Habilita as cores da mensagem
	self.bbcode_enabled = true
	
	# Conecta sinal global
	GlobalScript.connect("mensagem_para_jogador", Callable(self, "_on_mensagem_para_jogador"))

## Função responável por exibir dicas, mensagens, avisos, erros, etc.
func _on_mensagem_para_jogador(texto: String):
	if GlobalScript.dicas_config:
		self.text = texto
		self.visible = true
		var tween := create_tween()
		self.modulate.a = 0
		tween.tween_property(self, "modulate:a", 1.0, 0.2)
		await get_tree().create_timer(2.0).timeout
		var fade_out := create_tween()
		fade_out.tween_property(self, "modulate:a", 0.0, 0.3)
		await fade_out.finished
		self.visible = false
		
func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	Input.set_custom_mouse_cursor(GlobalScript.textura_mouse_arrastando_bloco, Input.CURSOR_CAN_DROP, Vector2(16,16))
	return true 
	
