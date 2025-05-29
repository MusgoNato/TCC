extends Control


#Volta a interface inicial
func _on_btn_voltar_config_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
