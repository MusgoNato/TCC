extends Control

# Volta ao menu inicial
func _on_label_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

# Entra na fase de movimento
func _on_btn_fase_1_pressed() -> void:
	GlobalScript.fase_selecionada = 1
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Entra na fase de condições	
func _on_btn_condições_button_down() -> void:
	GlobalScript.fase_selecionada = 2
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Entra na fase de repetições
func _on_btn_repetições_pressed() -> void:
	GlobalScript.fase_selecionada = 3
	get_tree().change_scene_to_file("res://scenes/game.tscn")

# Entra na fase de funções
func _on_btn_funções_button_down() -> void:
	GlobalScript.fase_selecionada = 4
	get_tree().change_scene_to_file("res://scenes/game.tscn")
