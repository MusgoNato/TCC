class_name Montagem extends HBoxContainer

const MAX_BLOCOS = 2
signal mensagem_solicitada(texto: String)

# Retorna se pode ser solto ou nao o bloco (Aqui é a area da montagem como um todo)
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	at_position = at_position
	data = data
	return true

# Drop data somente acontece uma vez, quando é dropado
func _drop_data(at_position: Vector2, data: Variant) -> void:
	# Evitar warnings	
	at_position = at_position
	
	if data is Bloco:
		if get_child_count() >= MAX_BLOCOS and data.get_parent() != self:
			emit_signal("mensagem_solicitada", "Limite de blocos atingido!")
			data.estaNaAreaDisponivel = false
			return
			
		# Se o bloco estiver vindo da area de blocos disponiveis, adiciono a montagem		
		if data.get_parent() != self:
			add_child(data)

		var global_pos = get_global_mouse_position()
		var lista_filhos = get_children()

		for i in lista_filhos.size():
			var filho = lista_filhos[i]

			# Ignora o próprio bloco
			if filho == data:
				continue

			# Se o mouse está sobre outro bloco, pego o indice
			# dentro dele na lista pra fazer a troca
			if filho.get_global_rect().has_point(global_pos):
				
				# Troca a posicao dos blocos apos o drop estando na area de montagem				
				var posicao_de_troca = i
				var bloco_temp = get_child(posicao_de_troca)
				var bloco_original = data.get_index()
								
				move_child(data, posicao_de_troca)
				move_child(bloco_temp, bloco_original)
				
				break
				
		# Area de montagem agora
		data.estaNaAreaDisponivel = false
		
		# Debug do bloco
		print("\n\n-----INFO DO BLOCO-----\n\n")
		print("NOME DO BLOCO: ", data.name, "\nID DO BLOCO: ", data.bloco_id, "\nIMAGEM DO BLOCO: ", data.texture.get_image(), "\nTIPO DO BLOCO: ", data.tipo, "\n")
	else:
		print("Blocos não são iguais")

	# Em modo remoto, os blocos que sao colocados tem nomes diferentes do original,
	# pela propria Godot criar nomes unicos e nao mesclar os nos entre si
