extends Control

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	Input.set_custom_mouse_cursor(GlobalScript.textura_mouse_arrastando_bloco, Input.CURSOR_CAN_DROP, Vector2(16,16))
	return true
