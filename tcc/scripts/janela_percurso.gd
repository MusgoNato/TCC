class_name Janela_Percurso extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var jogador: CharacterBody2D = $Jogador

var celula_tile := Vector2i(0,0)
var destino := Vector2i(0,0)
var processando_blocos: bool = false
var tile_size: Vector2

func _ready():
	# Tamanho do tile
	tile_size = Vector2(tile_map_layer.tile_set.tile_size)
	
	# Obtém a área utilizada do TileMap
	var used = tile_map_layer.get_used_rect()
	
	# Calcula a linha do meio CORRETAMENTE
	var linha_meio = used.position.y + int(used.size.y / 2)

	celula_tile = Vector2i(0, linha_meio)

	# Calcula a posição central do tile
	var tile_position = tile_map_layer.map_to_local(celula_tile)
	var centro = tile_position + (tile_size/2)
	
	# Posiciona o jogador no centro exato do tile
	jogador.position = centro

	print("Posição calculada: ", centro)
	print("Tile size: ", tile_size)

func _on_envia_blocos_percurso(blocos):
	### Execucao do percurso do personagem
	if processando_blocos:
		return
					
	processando_blocos = true
	
	for bloco in blocos:
		var direcao = Vector2i.ZERO
		
		match bloco.tipo:
			"direita":
				direcao.x += 1
			"esquerda":
				direcao.x -= 1
			"cima":
				direcao.y -= 1
			"baixo":
				direcao.y += 1	
			"_":
				continue
		print(celula_tile)
		
		# Antes de mover atualiza a celula
		celula_tile += direcao
		
		# Calcula posição absoluta na nova célula
		var nova_pos = tile_map_layer.map_to_local(celula_tile)
		
		# Centraliza
		nova_pos += tile_size / 2
		
		# Move usando posição absoluta
		var tween = create_tween()
		tween.tween_property(jogador, "position", nova_pos, 0.2)
		
		# Espera o movimento terminar		
		await tween.finished
		
	processando_blocos = false
