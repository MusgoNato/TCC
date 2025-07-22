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

# O tamanho do tile é 32x32
# Para que seja centralizado o movimento do jogador de acordo com o tile, y
const OFFSET_TILE_CENTRALIZADO: int = 16
const TAM_TILE_MUNDO: int = 32
const POSICAO_X_INICIAL_JOGADOR: int = TAM_TILE_MUNDO * 6
const QUANT_CHECKPOINT: int = 2

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
	configurar_checkpoints(1)
	
func _on_envia_blocos_percurso(blocos):
	blocos = blocos
	if blocos.is_empty() or processando_blocos:
		print("Painel de montagem vazio!")
		return
		
	processando_blocos = true
	
	for bloco in blocos:
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
				continue
	
		var novo_tile = celula_tile + direcao

		# Verifica se o movimento é válido dentro do TileMap com base nas coordenadas do retangulo
		var bounds = tile_map_layer.get_used_rect()
		var dentro = (novo_tile.x >= bounds.position.x and
					  novo_tile.x < bounds.end.x and
					  novo_tile.y >= bounds.position.y - 1 and
					  novo_tile.y < bounds.end.y - 1)

		if dentro:
			celula_tile = novo_tile
			
			var nova_pos = tile_map_layer.map_to_local(celula_tile) + tile_size / 2
			
			nova_pos.x -= OFFSET_TILE_CENTRALIZADO
			nova_pos.y += OFFSET_TILE_CENTRALIZADO
			
			var tween = create_tween()
			tween.tween_property(player, "position", nova_pos, 0.2)
			await tween.finished
		else:
			print("Movimento ignorado, fora dos limites: ", novo_tile)

	processando_blocos = false
	
	var posicao_jogador_celula = tile_map_layer.local_to_map(player.position)
	if not verificar_checkpoint_alcancado(posicao_jogador_celula):
		print("Nenhum checkpoint alcançado, reiniciando...")
		await get_tree().create_timer(0.5).timeout
		reiniciar_para_ultimo_checkpoint()
		
func configurar_checkpoints(fase: int):
	checkpoints.clear()
	match fase:
		1:
			checkpoints.append(Vector2i(4, 4))
		_:
			print("Fase sem configuração")

func verificar_checkpoint_alcancado(tile: Vector2i) -> bool:
	var tile_data = tile_map_layer.get_cell_tile_data(tile)
	if tile_data != null and tile_data.get_custom_data("checkpoint"):
		if not checkpoints.has(tile):
			checkpoints.append(tile)
		ultimo_checkpoint_tile.x = tile.x
		ultimo_checkpoint_tile.y = tile.y - 1
		cont_chekpoints += 1
		print(cont_chekpoints, "a Checkpoint alcancado!!!")
		if cont_chekpoints >= QUANT_CHECKPOINT:
			emit_signal("checkpoint_alcancado", cont_chekpoints)
		return true
	return false
	
func reiniciar_para_ultimo_checkpoint():
	celula_tile = ultimo_checkpoint_tile
	print(ultimo_checkpoint_tile)
	var pos = tile_map_layer.map_to_local(celula_tile) + tile_size / 2
	pos.x -= OFFSET_TILE_CENTRALIZADO
	pos.y += OFFSET_TILE_CENTRALIZADO
	player.position = pos
	print("Reiniciado no checkpoint: ", celula_tile)
