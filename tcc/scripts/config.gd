extends Control

@onready var brilho: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/brilho
@onready var brilho_num: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/brilho_num
@onready var som: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/som
@onready var som_num: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/som_num

func _ready() -> void:
	# Setando valores minimos e maximos para as configurações
	som.min_value = 1.0
	som.max_value = 10.0
	som.step = 2.0
	
	brilho.min_value = 1.0
	brilho.max_value = 10.0
	brilho.step = 2.0
	
	brilho.value = GlobalScript.valor_brilho_init
	som.value = GlobalScript.valor_som_init
	brilho_num.text = str(GlobalScript.valor_brilho_init)
	som_num.text = str(GlobalScript.valor_som_init)
	
	
## Sinal conectado para voltar ao menu inicial
func _on_btn_voltar_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

## Sinal conectado para mudança de brilho do jogo
func _on_brilho_value_changed(value: float) -> void:
	brilho_num.text = str(value)

## Sinal conectado para mudança de volume do jogo
func _on_som_value_changed(value: float) -> void:
	som_num.text = str(value)

## Sinal conectado para ativar e desativar dicas
func _on_dicas_pressed() -> void:
	GlobalScript.dicas_ativas = !GlobalScript.dicas_ativas
