class_name Montagem
extends Control

# qtd maximo de blocos na fase
const MAX_BLOCOS = 13

# Simulacao de camera no control
var zoom: int = 1.0
var zoom_min: int = 0.3
var zoom_max: int = 2.0
var zoom_step: int = 0.1

# Limite do scrool
var limite_scroll_camera_min: Vector2 = Vector2(-10000, -10000)
var limite_scroll_camera_max: Vector2 = Vector2(0, 0)

# Arraste do painel
var arrastando_painel := false
var mouse_dentro := false
var posicao_mouse_anterior := Vector2.ZERO

# Conecta sinal para qualquer tipo de mensagem que precisar
signal mensagem_solicitada(texto: String)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Bloco

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is Bloco:
		
		# Nao deixa colocar um bloco na area de montagem caso nao seja na propria
		# area de montagem ou ultrapasse a quantidade de blocos permitidos. Neste
		# caso o pai de data e paleta de blocos.
		if get_child_count() >= MAX_BLOCOS and data.get_parent() != self:
			emit_signal("mensagem_solicitada", "Limite de blocos atingido!")
			data.estaNaAreaDisponivel = false
			return

		# verifica se esta sendo colocado fora da paleta de blocos, neste caso
		# o data tem pai paleta
		if data.get_parent() != self:
			add_child(data)
		
		data.global_position = get_global_mouse_position()
		data.estaNaAreaDisponivel = false

		print("\n\n-----INFO DO BLOCO-----\n\n")
		print("NOME DO BLOCO: ", data.name, "\nID DO BLOCO: ", data.bloco_id, "\nIMAGEM DO BLOCO: ", data.texture.get_image(), "\nTIPO DO BLOCO: ", data.tipo, "\n")
	else:
		print("Blocos não são válidos")


func _gui_input(event: InputEvent) -> void:
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP and mouse_dentro:
		_aplicar_zoom(zoom + zoom_step, event.global_position)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and mouse_dentro:
		_aplicar_zoom(zoom - zoom_step, event.global_position)
	
	# Para o arraste do painel
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed and mouse_dentro:
			var deltaa = event.global_position - posicao_mouse_anterior
			arrastando_painel = true
			posicao_mouse_anterior = event.global_position
		else:
			arrastando_painel = false

	elif event is InputEventMouseMotion and arrastando_painel:
		var deltaa = event.global_position - posicao_mouse_anterior
		position += deltaa
		posicao_mouse_anterior = event.global_position

# Gerencia a 'camera' que foi criada no painel de montagem 
func _aplicar_zoom(novo_zoom: float, focal_point: Vector2) -> void:
	var clamped_zoom = clamp(novo_zoom, zoom_min, zoom_max)
	if clamped_zoom == zoom:
		return

	# Recalcula a posição para manter o ponto focal sob o mouse
	var old_zoom := zoom
	zoom = clamped_zoom
	scale = Vector2(zoom, zoom)

	# Corrige a posição para que o ponto do mouse continue onde estava
	var local_focal := focal_point - global_position
	var ajuste := local_focal * (1.0 - zoom / old_zoom)
	position += ajuste

func _on_mouse_entered() -> void:
	mouse_dentro = true

func _on_mouse_exited() -> void:
	mouse_dentro = false
