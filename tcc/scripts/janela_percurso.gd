class_name Percurso
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var player: Player = $player
@onready var inimigo: Inimigo = $Inimigo


var celula_tile := Vector2i(0, 0)
var celula_tile_inimigo: Vector2i = Vector2i(0, 0)
var destino := Vector2i(0, 0)
var processando_blocos: bool = false
var tile_size: Vector2
var checkpoints: Array[Vector2i] = []
var ultimo_checkpoint_tile: Vector2i
var cont_chekpoints: int = 0
var cont_blocos: int = 0
var continuar_executando: bool
var cont_movimento_inimigo: int = 0
var linha_meio_jogador: int = 0
var linha_meio_inimigo: int = 0
var direcao_inimigo: int = 1
var existe_condicional: bool = false
var quant_checkpoint: int = GlobalScript.quant_checkpoints_fases[GlobalScript.fase_selecionada]
var ultima_direcao: Vector2i = Vector2i.ZERO

# O tamanho do tile é 32x32
# Para que seja centralizado o movimento do jogador de acordo com o tile y
const OFFSET_TILE_CENTRALIZADO: int = 16
const TAM_TILE_MUNDO: int = 32
const POSICAO_X_INICIAL_JOGADOR: int = TAM_TILE_MUNDO * 6
const POS_INICIAL_X_INIMIGO: int = 7
const DIFERENCA_RELATIVA_MUNDO: int = 1
const MOV_MAX_INIMIGO: int = 3
const DIRECAO_DIREITA_INICIAL_INIMIGO: int = 1

# Posicao inicial no mundo do jogador e inimigo
const POS_INICIAL_JOGADOR: Vector2i = Vector2i(4, 4)
const POS_INICIAL_INIMIGO: Vector2i = Vector2i(4, 4)

## Checkpoint alcancado
signal checkpoint_alcancado(qtd_checkpoint: int)

func _ready():
	
	player.position = Vector2.ZERO
	
	# Tamanho do tile map layer como um todo
	tile_size = Vector2(tile_map_layer.tile_set.tile_size)

	# Pega o tamanho como um retangulo
	var used = tile_map_layer.get_used_rect()

	# Calcula a linha do meio do tile map layer (Posicao inicial do personagem)
	linha_meio_jogador = used.position.y + int(used.size.y / 2)
	celula_tile = Vector2i(0, linha_meio_jogador-1) # -1 para encaixar 5 corretamente
	
	# DEFINICAO DA POSICAO INICIAL DO JOGADOR NO MUNDO
	# Calcula a posicao com base no tile map layer, canto superior direito
	var tile_position = tile_map_layer.map_to_local(celula_tile)

	# Calculo do centro do tile
	tile_position.x -= OFFSET_TILE_CENTRALIZADO
	tile_position.y += OFFSET_TILE_CENTRALIZADO

	# Centraliza a posicao do jogador ao centro do tile
	var centro = tile_position + (tile_size / 2)
	
	# Definindo posicao inicial do jogador e checkpoint inicial
	player.position = centro
		
	# DEFINICAO DA POSICAO INICIAL DO INIMIGO NO MUNDO
	# Calcula a linha do meio do tile map layer (Posicao inicial do inimigo)
	inimigo.position = Vector2.ZERO
	
	linha_meio_inimigo = used.position.y + int(used.size.y/2)
	celula_tile_inimigo = Vector2i(POS_INICIAL_X_INIMIGO, linha_meio_inimigo - 1)
	var pos_inicial_inimigo_mundo = tile_map_layer.map_to_local(celula_tile_inimigo)
	pos_inicial_inimigo_mundo.x -= OFFSET_TILE_CENTRALIZADO
	pos_inicial_inimigo_mundo.y += OFFSET_TILE_CENTRALIZADO
	var centro_inimigo = pos_inicial_inimigo_mundo + (tile_size / 2)
	inimigo.position = centro_inimigo
	
	# Guarda o ultimo checkpoint do jogador
	ultimo_checkpoint_tile = celula_tile
	
	# Definicao dos checkpoints com base na fase
	configurar_checkpoints(GlobalScript.fase_selecionada)

	
## Sinal conectado apos o envio dos blocos pelo botao de executar na interface da fase
func _on_envia_blocos_percurso(blocos, blocos_internos_funcao):
	if blocos.is_empty() or processando_blocos:
		if GlobalScript.info_debug:
			print("Painel de montagem vazio!")
		return
		
	processando_blocos = true
	existe_condicional = false
	
	if GlobalScript.info_debug:
		print(blocos_internos_funcao)
		
	# Faz uma copia dos blocos originais, para evitar que o jogador interfira na leitura dos blocos
	# caso seja retirado algum bloco da montagem em tempo de execucao
	var blocos_data = criar_estrutura_blocos(blocos, blocos_internos_funcao)
	
	if GlobalScript.info_debug:
		print(blocos_data)
		
	await executar_blocos_recursivamente(blocos_data)
	
	# Terminou de processar os blocos
	processando_blocos = false
	
	# Calculo para a posicao do jogador
	var posicao_jogador_celula = tile_map_layer.local_to_map(player.position)
	var novo_checkpoint_atingido = verificar_checkpoint_alcancado(posicao_jogador_celula)
	if not novo_checkpoint_atingido:
		if GlobalScript.info_debug:
			print("Nenhum checkpoint alcançado, reiniciando...")
		await get_tree().create_timer(0.5).timeout
		reiniciar_para_ultimo_checkpoint()
	
## Funcao responsavel por fazer uma copia dos blocos originais
func criar_estrutura_blocos(blocos_a_serem_copiados, blocos_internos_funcao = []):
	var estrutura: Array = []
	for bloco_node in blocos_a_serem_copiados:
		var data = {
			"tipo": bloco_node.tipo
		}
		if bloco_node.tipo == "repita_inicio":
			data["repeticoes"] = bloco_node.get_node("VBoxContainer/SpinBox").value
		
		# Se for um bloco de função, associo os blocos internos que foram passados
		elif bloco_node.tipo == "funcao":
			if !blocos_internos_funcao.is_empty():
				
				# Uso a lista de blocos_internos_funcao que chegou como argumento
				data["blocos_internos"] = criar_estrutura_blocos(blocos_internos_funcao)
			else:
				data["blocos_internos"] = []
		estrutura.append(data)
	
	return estrutura
	
## Execução dos blocos recursivamente
func executar_blocos_recursivamente(blocos_a_executar):
	var indice_atual = 0
	
	# Percorre os blocos
	while indice_atual < blocos_a_executar.size():
		var bloco_atual = blocos_a_executar[indice_atual]
		
		# Caso seja inicial, busca um fechamento
		if bloco_atual.tipo == "repita_inicio":
			var num_repeticoes = bloco_atual.repeticoes
			var indice_final_loop = encontrar_bloco_repita_fim(blocos_a_executar, indice_atual)
			
			if indice_final_loop == -1:
				GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_BLOCO_REPETICAO_SEM_FECHAMENTO)
				if GlobalScript.info_debug:
					print("Erro: Bloco de repetição sem fechamento correspondente")
				break
			
			var blocos_do_loop = blocos_a_executar.slice(indice_atual + 1, indice_final_loop)
			
			for i in range(num_repeticoes):
				continuar_executando = await executar_blocos_recursivamente(blocos_do_loop)
				if not continuar_executando:
					return false
			# Pula para o bloco depois do "repita_fim"
			indice_atual = indice_final_loop + 1
		else:
			continuar_executando = await executar_bloco_singular(bloco_atual)
			if not continuar_executando:
				return false
			indice_atual += 1
	return true

## Funcao responsavel por executar cada bloco de forma singular
func executar_bloco_singular(bloco):
	var direcao = Vector2i.ZERO
	match bloco.tipo:
		"funcao":
			if not bloco.has("blocos_internos") or bloco.blocos_internos.is_empty():
				if GlobalScript.info_debug:
					print("A funcao nao possui nenhum bloco")
				return true
			else:
				var sucesso = await executar_blocos_recursivamente(bloco.blocos_internos)
				if not sucesso:
					if GlobalScript.info_debug:
						print("Nao leu o bloco dentro da funcao")
					return false
			return true
		"condicional":
			# Verifico se a proxima posicao do meu jogador eh o inimigo, ao executar o bloco atual, no
			# caso condicional, apago o inimigo se a condicao for satisfeita, caso contrario o jogador colide com o inimigo
			# na verificacao final da funcao 
			var posicao_atual_jogador = tile_map_layer.local_to_map(player.global_position)
			var posicao_atual_inimigo = tile_map_layer.local_to_map(inimigo.global_position)
			
			var inimigo_a_frente = posicao_atual_jogador + ultima_direcao
			if inimigo_a_frente == posicao_atual_inimigo:
				inimigo.visible = false
				inimigo.process_mode = Node.PROCESS_MODE_DISABLED
			
			return true
		"esquerda":
			direcao = Vector2i(-1, 0)
			player.animation_player.flip_h = true
			player.animation_player.play("esq")
		"direita":
			player.animation_player.flip_h = false
			direcao = Vector2i(1, 0)
			player.animation_player.play("dir")
		"cima":
			direcao = Vector2i(0, -1)
			player.animation_player.play("up")
		"baixo":
			direcao = Vector2i(0, 1)
			player.animation_player.play("down")
	
	if direcao != Vector2i.ZERO:
		ultima_direcao = direcao
	
		# movimentação
		var novo_tile = celula_tile + direcao
		var bounds = tile_map_layer.get_used_rect()
		var dentro = (novo_tile.x >= bounds.position.x and
					  novo_tile.x < bounds.end.x and
					  novo_tile.y >= bounds.position.y - 1 and
					  novo_tile.y < bounds.end.y - 1)
		if dentro:
			var tile_data = tile_map_layer.get_cell_tile_data(Vector2i(novo_tile.x, novo_tile.y + DIFERENCA_RELATIVA_MUNDO))
			if tile_data != null and tile_data.has_custom_data("valido") and not tile_data.get_custom_data("valido"):
				if GlobalScript.info_debug:
					print("PRÓXIMO CAMINHO INVÁLIDO")
				return false
				
			celula_tile = novo_tile
			var nova_pos = tile_map_layer.map_to_local(celula_tile) + tile_size / 2
			nova_pos.x -= OFFSET_TILE_CENTRALIZADO
			nova_pos.y += OFFSET_TILE_CENTRALIZADO
			var tween = create_tween()
			tween.tween_property(player, "position", nova_pos, 0.2)
			await tween.finished
			
			if verificar_colisao_inimigo():
				GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_COLIDIU_INIMIGO)
				return false
			
		return true
	
	return false


## Funcao responsavel por verificar a colisao com o inimigo
func verificar_colisao_inimigo():
	# Antes de verificar a colisao do inimigo, verifica se ele existe dentro do percurso
	if !inimigo.visible:
		return false
	
	var posicao_jogador = tile_map_layer.local_to_map(player.global_position)
	var posicao_inimigo = tile_map_layer.local_to_map(inimigo.global_position)
	
	return posicao_inimigo == posicao_jogador

## Funcao responsável por configurar os checkpoints da fase selecionada
func configurar_checkpoints(fase: int):
	checkpoints.clear()
	match fase:
		# Fase 0 (Tutorial)
		0:
			checkpoints.append(POS_INICIAL_JOGADOR)
			inimigo.visible = false
			inimigo.process_mode = Node.PROCESS_MODE_DISABLED
		# Fase 1 (movimento)
		1:
			checkpoints.append(POS_INICIAL_JOGADOR)
			inimigo.visible = false
			inimigo.process_mode = Node.PROCESS_MODE_DISABLED
		# Fase 2 (condições)
		2:
			checkpoints.append(POS_INICIAL_JOGADOR)	
			inimigo.visible = true
		# Fase 3 (repita)
		3:
			checkpoints.append(POS_INICIAL_JOGADOR)
			inimigo.visible = true
		# Fase 4 (funções)
		4:
			checkpoints.append(POS_INICIAL_JOGADOR)
			inimigo.visible = true
		_:
			if GlobalScript.info_debug:
				print("Fase sem configuração")
			

## Funcao responsavel por encontrar um bloco repita_fim
func encontrar_bloco_repita_fim(blocos, indice_inicio):
	var contagem_loops = 0
	for i in range(indice_inicio + 1, blocos.size()):
		if blocos[i].tipo == "repita_inicio":
			contagem_loops += 1
		elif blocos[i].tipo == "repita_fim":
			if contagem_loops == 0:
				return i
			else:
				contagem_loops -= 1
	return -1

## Funcao responsável por verificar se o tile que o jogador parou é o checkpoint 
func verificar_checkpoint_alcancado(tile: Vector2i) -> bool:
	var tile_data = tile_map_layer.get_cell_tile_data(tile)
	if tile_data != null and tile_data.get_custom_data("checkpoint"):
		if checkpoints.has(tile):
			return false	
		checkpoints.append(tile)
		ultimo_checkpoint_tile.x = tile.x
		ultimo_checkpoint_tile.y = tile.y - 1
		cont_chekpoints += 1
		if GlobalScript.info_debug:
			print(cont_chekpoints, "a Checkpoint alcancado!!!")
		GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_CHECKPOINT_ALCANCADO)
		if cont_chekpoints >= quant_checkpoint:
			emit_signal("checkpoint_alcancado", cont_chekpoints)
		
		return true
	return false
	
## Função responsável por reiniciar a posição do jogador para o último checkpoint alcançado
func reiniciar_para_ultimo_checkpoint():
	celula_tile = ultimo_checkpoint_tile
	if GlobalScript.info_debug:
		print("Ultimo checkpoint alcancado : ", ultimo_checkpoint_tile)
	var pos = tile_map_layer.map_to_local(celula_tile) + tile_size / 2
	pos.x -= OFFSET_TILE_CENTRALIZADO
	pos.y += OFFSET_TILE_CENTRALIZADO
	player.position = pos
	if GlobalScript.info_debug:
		print("Reiniciado no checkpoint: ", celula_tile)
	GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_NENHUM_CHECKPOINT_ALCANCADO)
