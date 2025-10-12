extends Node2D
@onready var global_canvas_modulate: CanvasModulate = $GlobalCanvasModulate

func _ready() -> void:
	if Engine.has_singleton("GlobalEffects"):
		set_brilho(GlobalScript.valor_brilho_config)

## Funcao responsavel por ajustar o brilho global (0.0 = preto, 1.0 = normal)
func set_brilho(value: float) -> void:
	var v = clamp(value, 0.0, 1.0)
	global_canvas_modulate.color = Color(v, v, v, 1.0)	
	GlobalScript.valor_brilho_config = value

## Funcao responsavel por retornar o brilho atual do canvas_modulate global
func get_brilho() -> float:
	return global_canvas_modulate.color.r

## Funcao responsavel pelo fade_to para aplicar em momento de mudanca de brilho para animar
func fade_to(value: float, duration: float = 0.5) -> void:
	var target := Color(clamp(value,0,1), clamp(value,0,1), clamp(value,0,1), 1.0)
	var tw = create_tween()
	tw.tween_property(global_canvas_modulate, "color", target, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

## Funcao responsavel pelo fade_in para aplicar em momento de mudanca de brilho para animar
func fade_in(duration: float = 0.5) -> void:
	fade_to(1.0, duration)

func fade_out(duration: float = 0.5) -> void:
	fade_to(0.0, duration)
