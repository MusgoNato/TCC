class_name Player
extends CharacterBody2D

# Para animacoes e area de colisao caso seja necessario
@onready var animation_player: AnimatedSprite2D = $AnimationPlayer
@onready var area_colisao: Area2D = $AreaColisao
