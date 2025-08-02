class_name ViewportMontage
extends SubViewport

@onready var camera_2d: Camera2D = $Camera2D

var arrastando: bool = false
var botao_direito_pressionado: bool = false

var ultima_pos_mouse: Vector2 = Vector2.ZERO
var posicao_camera2d: Vector2 = Vector2.ZERO

const POS_INICIAL_CAMERA: Vector2 = Vector2.ZERO

func _ready() -> void:
	camera_2d.position = POS_INICIAL_CAMERA

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("reiniciar_camera"):
		camera_2d.position = POS_INICIAL_CAMERA
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			botao_direito_pressionado = event.pressed
			if event.pressed:
				# Pega a posição do clique dentro do SubViewport
				ultima_pos_mouse = event.position
	elif event is InputEventMouseMotion:
		if botao_direito_pressionado:
			arrastando = true
			var pos_atual = event.position
			var delta = ultima_pos_mouse - pos_atual
			camera_2d.position += delta
			ultima_pos_mouse = pos_atual
			print("Camera2D: ", camera_2d.position)
		else:
			arrastando = false
