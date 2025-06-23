class_name Percurso
extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var player: Player = $player

var celula_tile := Vector2i(0, 0)
var destino := Vector2i(0, 0)
var processando_blocos: bool = false
var tile_size: Vector2

# O tamanho do tile é 32x32
# Para que seja centralizado o movimento do jogador de acordo com o tile, y
const OFFSET_TILE_CENTRALIZADO = 16

func _ready():
	player.position = Vector2.ZERO
	
	# Tamanho do tile map layer como um todo
	tile_size = Vector2(tile_map_layer.tile_set.tile_size)
	#print("Tile size: ", tile_size)

	# Pega o tamanho como um retangulo
	var used = tile_map_layer.get_used_rect()
	#print("Used rect: ", used)
	#print("Used rect position: ", used.position)
	#print("Used rect size: ", used.size)
	#print("Used rect end: ", used.end)

	# Calcula a linha do meio do tile map layer (Posicao inicial do personagem)
	var linha_meio = used.position.y + int(used.size.y / 2)
	celula_tile = Vector2i(0, linha_meio-1) # -1 para encaixar 5 corretamente
	#print("Starting tile: ", celula_tile)

	# Calcula a posicao com base no tile map layer, canto superior direito
	var tile_position = tile_map_layer.map_to_local(celula_tile)
	#print("Tile position (top-left): ", tile_position)

	# Calculo do centro do tile
	tile_position.x -= OFFSET_TILE_CENTRALIZADO
	tile_position.y += OFFSET_TILE_CENTRALIZADO

	var centro = tile_position + (tile_size / 2)
	#print("Calculated center: ", centro)
	
	# Centraliza a posicao do jogador ao centro do tile
	player.position = centro
	#print("Player position: ", player.position)

func _process(delta: float) -> void:
	delta = delta
	pass
	
	## Handle input for static movement
	#var direction := Vector2i.ZERO
	#if Input.is_action_just_pressed("rigth"):  # Fixed typo from "rigth"
		#player.animation_player.flip_h = false
		#direction = Vector2i(1, 0)
		#player.animation_player.play("dir")
	#elif Input.is_action_just_pressed("left"):
		#direction = Vector2i(-1, 0)
		#player.animation_player.flip_h = true
		#player.animation_player.play("esq")
	#elif Input.is_action_just_pressed("up"):
		#direction = Vector2i(0, -1)
		#player.animation_player.play("up")
	#elif Input.is_action_just_pressed("down"):
		#direction = Vector2i(0, 1)
		#player.animation_player.play("down")
	#
	#if direction != Vector2i.ZERO:
		## Calculate new tile position
		#var new_tile = celula_tile + direction
		#
		## Check if the new tile is within the tile map bounds
		#var used_rect = tile_map_layer.get_used_rect()
		## Limites da tela do percurso
		#var is_valid = (new_tile.x >= used_rect.position.x and
						#new_tile.x < used_rect.position.x + used_rect.size.x and
						#new_tile.y >= used_rect.position.y - 1 and
						#new_tile.y < used_rect.position.y - 1 + used_rect.size.y)
		##print("Attempting move to: ", new_tile, " Valid: ", is_valid)
		#
		#if is_valid:
			#celula_tile = new_tile
			#
			## Calcula a posicao global para o tile
			#var nova_pos = tile_map_layer.map_to_local(celula_tile)
			#nova_pos += tile_size / 2
			#nova_pos.x -= OFFSET_TILE_CENTRALIZADO
			#nova_pos.y += OFFSET_TILE_CENTRALIZADO
			##print("Moving to tile: ", celula_tile, " World position: ", nova_pos)
#
			## Move o jogador
			#var tween = create_tween()
			#tween.tween_property(player, "position", nova_pos, 0.2)
			#await tween.finished
			#
		#else:
			#print("Move blocked: Tile ", new_tile, " is outside used_rect: ", used_rect)
			
func _on_envia_blocos_percurso(blocos):
	blocos = blocos
	if blocos.is_empty() or processando_blocos:
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
	var tile_checkpoint = tile_map_layer.get_cell_tile_data(posicao_jogador_celula)
	print("Tile checkpoint: ", tile_checkpoint)
	print(tile_checkpoint.get_custom_data("checkpoint"))
	if tile_checkpoint != null and tile_checkpoint.get_custom_data("checkpoint"):
		print("Checkpoint alcançado!")
