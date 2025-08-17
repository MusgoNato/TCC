class_name Descarte extends Panel

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	at_position = at_position
	data = data
	
	# Somente sera descartado o bloco, evitando que seja descartado valores como no bloco de repeticao
	if data is Bloco:
		return true
	else:
		return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	at_position = at_position
	data = data
	if data is Bloco:
		if not data.estaNaPaleta:
			print("BLOCO EXCLUIDO: ", data.name, "\nNOME: ", data.name, "\nID : ", data.bloco_id, "\nTIPO DO BLOCO : ", data.tipo)
			data.queue_free()
			GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_BLOCO_DESCARTE)
