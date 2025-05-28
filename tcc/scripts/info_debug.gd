class_name Debug extends Node

@onready var montagem: Montagem = $"../PaineisManager/MontagemBackground/Montagem"
@onready var json_manager: JsonManager = $"../JsonManager"
@onready var fps: Label = $"../CanvasLayer/FPS"
var blocos = null

func _ready() -> void:
	blocos = json_manager.get_dados_blocos()
	print(blocos)

func _input(event: InputEvent) -> void:
	# Saida rapida
	if event.is_action_pressed('sair'):
		get_tree().quit()
		
func _process(delta: float) -> void:	
	delta = delta
	$"../CanvasLayer/FPS".text = str(Engine.get_frames_per_second())
