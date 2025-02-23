extends Control

# Volta ao menu inicial
func _on_label_pressed() -> void:
	get_tree().change_scene_to_file("res://Interfaces/Menu_inicial/menu.tscn")


func _on_btn_movimento_pressed() -> void:
	get_tree().change_scene_to_file("res://Interfaces/Fases/Movimento/MainScene.tscn")
