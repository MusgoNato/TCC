extends Control

# Comandos para quando os botões forem presisonados (começar jogo, configurações e saida do jogo)
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fases.tscn")

func _on_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/config.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
