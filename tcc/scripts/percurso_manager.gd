class_name Percurso_Manager extends Node

@onready var sub_viewport_container: SubViewportContainer = $CanvasLayer/SubViewportContainer

func _ready() -> void:
	var percurso = preload("res://scenes/percurso.tscn").instantiate()
	sub_viewport_container.add_child(percurso)
