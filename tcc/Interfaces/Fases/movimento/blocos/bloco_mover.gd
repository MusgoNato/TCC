extends Control

var dragging = false  # Variável para verificar se está sendo arrastado
var offset = Vector2()  # Diferença entre o clique e a posição do bloco
var original_position = Vector2()  # Armazena a posição original do bloco

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var texture_rect = $TextureRect
	texture_rect.modulate = Color(1, 1, 1, 1)
	original_position = global_position  # Armazena a posição original do bloco

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var texture_rect = $TextureRect
	var mouse_pos = get_local_mouse_position()

	# Verifica se o mouse está sobre a área do bloco
	if get_rect().has_point(mouse_pos):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			# Aplica a cor de realce quando o mouse está pressionado
			texture_rect.modulate = Color(0.5, 0.5, 1, 1)
			
			if not dragging:
				dragging = true
				# Calcula a diferença entre o clique e a posição do bloco
				offset = global_position - get_global_mouse_position()
		else:
			# Restaura a cor quando o mouse não está pressionado
			texture_rect.modulate = Color(1, 1, 1, 1)
			dragging = false
	
	# Se estiver arrastando o bloco, atualiza a posição
	if dragging:
		global_position = get_global_mouse_position() + offset 
	
	# Se o botão do mouse for liberado, o bloco volta para a posição original, restaurando a cor em conjunto
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and dragging:
		global_position = original_position
		texture_rect.modulate = Color(1, 1, 1, 1)
		dragging = false 
