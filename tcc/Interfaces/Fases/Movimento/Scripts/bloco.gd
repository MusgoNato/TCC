extends TextureButton

var posicaoInicial: Vector2 
var arrastando = false
var deslocamento: Vector2

func _ready() -> void:
	posicaoInicial = global_position

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		arrastando = true
		deslocamento = get_global_mouse_position() - global_position
	elif event is InputEventMouseButton and not event.pressed:
		arrastando = false		

func _process(delta: float) -> void:
	if arrastando:
		global_position = get_global_mouse_position() - deslocamento
	else:
		global_position = get_meta("posicao_inicial", global_position)


		
