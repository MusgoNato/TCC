class_name Descarte extends Panel

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	at_position = at_position
	data = data
	
	# Somente sera descartado o bloco, evitando que seja descartado valores como no bloco de repeticao
	if data is Bloco:
		Input.set_custom_mouse_cursor(GlobalScript.textura_mouse_area_pra_soltar_bloco, Input.CURSOR_CAN_DROP, Vector2(16,16))
		return true
	else:
		return false
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	at_position = at_position
	data = data
	
	if data is Bloco:
		if not data.estaNaPaleta:
			if GlobalScript.info_debug:
				print("BLOCO EXCLUIDO: ", data.name, "\nNOME: ", data.name, "\nID : ", data.bloco_id, "\nTIPO DO BLOCO : ", data.tipo)
			
			# Libero o bloco apos o descarte
			data.queue_free()
