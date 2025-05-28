class_name AreaMontagem
extends VBoxContainer

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is Bloco

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if not data is Bloco:
		return

	# Evita múltiplos pais
	if data.get_parent() != self:
		add_child(data)

	# Reordena com base na posição do mouse
	var global_mouse = get_global_mouse_position()
	var filhos = get_children()

	for i in filhos.size():
		var filho = filhos[i]
		if filho == data:
			continue

		if filho.get_global_rect().has_point(global_mouse):
			move_child(data, i)
			break

	data.estaNaAreaDisponivel = false
