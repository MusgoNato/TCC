class_name Montagem extends HBoxContainer

# Para nao quebrar a area de montagem no maximo podem ser 13 blocos colocados
const MAX_BLOCOS = 13
var montagem_principal: bool = true

func _ready() -> void:
	self.add_theme_constant_override("separation", 32)

# Retorna se pode ser solto ou nao o bloco (Aqui é a area da montagem como um todo)
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	
	if data is Bloco:
		if GlobalScript.info_debug:
			print("Tipo do bloco: ", data.tipo)
		if not montagem_principal and data.tipo == "funcao":
			if GlobalScript.info_debug:
				print("nao e possivel soltar blocos funcao na area de funcao")
			return false
			
		if data.estaNaPaleta:
			if GlobalScript.info_debug:
				print("Esta na paleta? ", data.estaNaPaleta)
		else: 
			if GlobalScript.info_debug:
				print("Esta na paleta? ", data.estaNaPaleta)	
		
		Input.set_custom_mouse_cursor(GlobalScript.textura_mouse_area_pra_soltar_bloco, Input.CURSOR_CAN_DROP, Vector2(16, 16))	
		return true
	else:
		if GlobalScript.info_debug:
			print_debug("\n=>>Bloco nao e do tipo Bloco!!!!")
		return false

# Drop data somente acontece uma vez, quando é dropado
func _drop_data(at_position: Vector2, data: Variant) -> void:
	# Evitar warnings	
	at_position = at_position

	if data is Bloco:
		if data.get_parent() != null and data.get_parent() != self:
			data.get_parent().remove_child(data)
			
		if get_child_count() >= MAX_BLOCOS and data.get_parent() != self:
			GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_LIMITE_BLOCOS_ATINGIDO)
			data.estaNaPaleta = false
			return
			
		# Se o bloco estiver vindo da area de blocos disponiveis, adiciono a montagem		
		if data.get_parent() != self:
			if GlobalScript.info_debug:
				print("O pai do bloco eh este : ", data.get_parent())
			add_child(data)
		else:
			if GlobalScript.info_debug:
				print("O pai do bloco eh este : ", data.get_parent())

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
		data.estaNaPaleta = false
		
		if GlobalScript.info_debug:
			print("Esta na paleta? ", data.estaNaPaleta)
		
			# Debug do bloco
			print("\n\n-----INFO DO BLOCO-----\n\n")
			print("NOME DO BLOCO: ", data.name, "\nID DO BLOCO: ", data.bloco_id, "\n", "\nTIPO DO BLOCO: ", data.tipo, "\n")
	else:
		if GlobalScript.info_debug:
			print("Blocos não eh do tipo BLOCO")
