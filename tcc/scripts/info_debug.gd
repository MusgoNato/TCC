class_name Debug extends Node

@onready var montagem: Montagem = $"../PaineisManager/LayerMontagem/MontagemBackground/Montagem"
@onready var json_manager: JsonManager = $"../JsonManager"
@onready var fps: Label = $"../FPSLayer/FPS"
var blocos = null

func _ready() -> void:
	blocos = json_manager.get_dados_blocos()
	print(blocos)

func _input(event: InputEvent) -> void:
	# Saida rapida
	if event.is_action_pressed("sair"):
		get_tree().quit()
		
func _process(delta: float) -> void:	
	delta = delta
	fps.text = str(Engine.get_frames_per_second())
	
	# Recarrega a cena atual
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
