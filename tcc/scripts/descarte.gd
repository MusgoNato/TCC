class_name Descarte extends Panel

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	at_position = at_position
	data = data
	return true
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	at_position = at_position
	data = data
	if data is Bloco:
		if not data.estaNaAreaDisponivel:
			print("BLOCO EXCLUIDO: ", data.name, "\nNOME: ", data.name, "\nID : ", data.bloco_id, "\nTIPO DO BLOCO : ", data.tipo)
			data.queue_free()
