class_name Percurso
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var player: Player = $player

var celula_tile := Vector2i(0, 0)
var destino := Vector2i(0, 0)
var processando_blocos: bool = false
var tile_size: Vector2
var checkpoints: Array[Vector2i] = []
var ultimo_checkpoint_tile: Vector2i
var cont_chekpoints: int = 0
var cont_blocos: int = 0
var continuar_executando: bool

# O tamanho do tile é 32x32
# Para que seja centralizado o movimento do jogador de acordo com o tile, y
const OFFSET_TILE_CENTRALIZADO: int = 16
const TAM_TILE_MUNDO: int = 32
const POSICAO_X_INICIAL_JOGADOR: int = TAM_TILE_MUNDO * 6
const QUANT_CHECKPOINT: int = 2
const DIFERENCA_RELATIVA_MUNDO: int = 1
const POS_INICIAL_JOGADOR: Vector2i = Vector2i(4, 4) # Posicao inicial do jogador na fase

## Checkpoint alcancado
signal checkpoint_alcancado(qtd_checkpoint: int)

func _ready():
	player.position = Vector2.ZERO
	
	# Tamanho do tile map layer como um todo
	tile_size = Vector2(tile_map_layer.tile_set.tile_size)

	# Pega o tamanho como um retangulo
	var used = tile_map_layer.get_used_rect()

	# Calcula a linha do meio do tile map layer (Posicao inicial do personagem)
	var linha_meio = used.position.y + int(used.size.y / 2)
	celula_tile = Vector2i(0, linha_meio-1) # -1 para encaixar 5 corretamente

	# Calcula a posicao com base no tile map layer, canto superior direito
	var tile_position = tile_map_layer.map_to_local(celula_tile)

	# Calculo do centro do tile
	tile_position.x -= OFFSET_TILE_CENTRALIZADO
	tile_position.y += OFFSET_TILE_CENTRALIZADO

	# Centraliza a posicao do jogador ao centro do tile
	var centro = tile_position + (tile_size / 2)
	
	# Definindo posicao inicial do jogador e checkpoint inicial
	player.position = centro
	ultimo_checkpoint_tile = celula_tile
	
	# Definicao dos checkpoints com base na fase
	configurar_checkpoints(GlobalScript.fase_selecionada)
	
## Sinal conectado apos o envio dos blocos pelo botao de executar na interface da fase
func _on_envia_blocos_percurso(blocos):
	if blocos.is_empty() or processando_blocos:
		print("Painel de montagem vazio!")
		return
		
	processando_blocos = true
	
	# Faz uma copia dos blocos originais, para evitar que o jogador interfira na leitura dos blocos
	# caso seja retirado algum bloco da montagem em tempo de execucao
	var blocos_data = get_copia_blocos(blocos)
	
	await executar_blocos_recursivamente(blocos_data)
	
	# Terminou de processar os blocos
	processando_blocos = false
	
	# Calculo para a posicao do jogador
	var posicao_jogador_celula = tile_map_layer.local_to_map(player.position)
	var novo_checkpoint_atingido = verificar_checkpoint_alcancado(posicao_jogador_celula)
	if not novo_checkpoint_atingido:
		print("Nenhum checkpoint alcançado, reiniciando...")
		await get_tree().create_timer(0.5).timeout
		reiniciar_para_ultimo_checkpoint()
	
func get_copia_blocos(blocos_a_serem_copiados):
	var blocos_copiados: Array = []
	for blocos_node in blocos_a_serem_copiados:
		var data = {
			"tipo": blocos_node.tipo
		}
		if blocos_node.tipo == "repita_inicio":
			data["repeticoes"] = blocos_node.get_node("VBoxContainer/SpinBox").value
		
		blocos_copiados.append(data)
	
	return blocos_copiados
	
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

# Executa cada bloco
func executar_bloco_singular(bloco):
	var direcao = Vector2i.ZERO
	match bloco.tipo:
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
		"_":
			print("Direcao invalida")
			return false
			
	# Restante da sua lógica de movimento e verificação
	var novo_tile = celula_tile + direcao
	var bounds = tile_map_layer.get_used_rect()
	var dentro = (novo_tile.x >= bounds.position.x and
				  novo_tile.x < bounds.end.x and
				  novo_tile.y >= bounds.position.y - 1 and
				  novo_tile.y < bounds.end.y - 1)
	if dentro:
		var tile_data = tile_map_layer.get_cell_tile_data(Vector2i(novo_tile.x, novo_tile.y + DIFERENCA_RELATIVA_MUNDO))
		if tile_data != null and tile_data.has_custom_data("valido"):
			if not tile_data.get_custom_data("valido"):
				print("PRÓXIMO CAMINHO INVALIDO")
				return false
			else:
				print("CAMINHO VALIDO")
			
		celula_tile = novo_tile
		var nova_pos = tile_map_layer.map_to_local(celula_tile) + tile_size / 2
		nova_pos.x -= OFFSET_TILE_CENTRALIZADO
		nova_pos.y += OFFSET_TILE_CENTRALIZADO
		var tween = create_tween()
		tween.tween_property(player, "position", nova_pos, 0.2)
		await tween.finished
		return true

	# Se nao estiver dentro dos limites do mundo
	return false

## Funcao responsável por configurar os checkpoints da fase selecionada
func configurar_checkpoints(fase: int):
	checkpoints.clear()
	match fase:
		# Fase 1 (movimento)
		1:
			checkpoints.append(POS_INICIAL_JOGADOR)
		# Fase 2 (condições)
		2:
			checkpoints.append(POS_INICIAL_JOGADOR)	
		# Fase 3 (repita)
		3:
			checkpoints.append(POS_INICIAL_JOGADOR)
		# Fase 4 (funções)
		4:
			checkpoints.append(POS_INICIAL_JOGADOR)
		_:
			print("Fase sem configuração")

func executar_blocos(blocos_a_executar):
	for bloco in blocos_a_executar:
		await executar_bloco_singular(bloco)
		
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
		print(cont_chekpoints, "a Checkpoint alcancado!!!")
		GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_CHECKPOINT_ALCANCADO)
		if cont_chekpoints >= QUANT_CHECKPOINT:
			emit_signal("checkpoint_alcancado", cont_chekpoints)
		
		return true
	return false
	
## Função responsável por reiniciar a posição do jogador para o último checkpoint alcançado
func reiniciar_para_ultimo_checkpoint():
	celula_tile = ultimo_checkpoint_tile
	print(ultimo_checkpoint_tile)
	var pos = tile_map_layer.map_to_local(celula_tile) + tile_size / 2
	pos.x -= OFFSET_TILE_CENTRALIZADO
	pos.y += OFFSET_TILE_CENTRALIZADO
	player.position = pos
	print("Reiniciado no checkpoint: ", celula_tile)
	GlobalScript.enviar_mensagem_ao_jogador(GlobalScript.MSG_NENHUM_CHECKPOINT_ALCANCADO)
	
