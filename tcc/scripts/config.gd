extends Control

@onready var som: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/som
@onready var brilho: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/brilho

func _ready() -> void:
	# Setando valores minimos e maximos para as configurações
	som.min_value = 1.0
	som.max_value = 10.0
	som.step = 2.0
	
	brilho.min_value = 1.0
	brilho.max_value = 10.0
	brilho.step = 2.0
	
## Sinal conectado para voltar ao menu inicial
func _on_btn_voltar_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

## Sinal conectado para mudança de brilho do jogo
func _on_brilho_value_changed(value: float) -> void:
	print("Valor do brilho sendo alterado: %d" % value)

## Sinal conectado para mudança de volume do jogo
func _on_som_value_changed(value: float) -> void:
	print("Valor do som sendo alterado: %d" % value)

## Sinal conectado para ativar e desativar dicas
func _on_dicas_pressed() -> void:
	GlobalScript.dicas_ativas = !GlobalScript.dicas_ativas
	print("Dicas ativas? ", GlobalScript.dicas_ativas)
