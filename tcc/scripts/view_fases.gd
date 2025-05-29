extends Control

# Volta ao menu inicial
func _on_label_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_btn_fase_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
