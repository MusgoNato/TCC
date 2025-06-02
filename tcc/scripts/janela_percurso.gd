class_name Janela_Percurso extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var jogador: CharacterBody2D = $Jogador
@onready  var tile_size: Vector2 = Vector2(tile_map_layer.tile_set.tile_size)

var celula_tile := Vector2i(0,0)
var destino := Vector2i(0,0)
var processando_blocos: bool = false

func _ready():
	# Alinha inicialmente com o grid
	celula_tile = tile_map_layer.local_to_map(jogador.global_position)
	jogador.global_position = tile_map_layer.map_to_local(celula_tile) + tile_size / 2

func _on_envia_blocos_percurso(blocos):
	if processando_blocos:
		print("Ja esta processando blocos")
		return
			
	processando_blocos = true
	
	for bloco in blocos:
		var direcao = Vector2i.ZERO
		
		match bloco.tipo:
			"direita":
				direcao.x += 1
			"esquerda":
				direcao.x -= 1
			"_":
				continue
		
		# Antes de mover atualiza a celula
		celula_tile += direcao
		
		# Calcula posição absoluta na nova célula
		var nova_pos = tile_map_layer.map_to_local(celula_tile)
		
		# Centraliza
		nova_pos += tile_size / 2
		
		# Move usando posição absoluta
		var tween = create_tween()
		tween.tween_property(jogador, "global_position", nova_pos, 0.2)
		
		# Espera o movimento terminar		
		await tween.finished
		
	processando_blocos = false
	
