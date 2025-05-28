extends Sprite2D

var draggin = false
var of = Vector2(0,0)

var snap = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if draggin:
		position = get_global_mouse_position() - of

func _on_button_button_down() -> void:
	draggin = true
	of = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	draggin = false
	
