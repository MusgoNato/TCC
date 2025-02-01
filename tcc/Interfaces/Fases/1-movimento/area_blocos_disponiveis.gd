extends Control

var blocos = []

@onready var data = preload("res://Interfaces/Fases/1-movimento/fase_1.gd").new()
@onready var inventarioBlocos = $VBoxContainer

# Ao entrar dentro desta cena, chamo as determinadas funções para o carregamento dos dados
func _ready() -> void:
	data._ready()
	blocos = data.get_blocos_disponiveis()
	InsereBlocos()
	
# Responsavel por inserir os blocos disponiveis da fase 1 na minha grid	
func InsereBlocos():
	for bloco in blocos:
		var botao = TextureButton.new() # Crio um botao para o bloco
		botao.texture_normal = load(bloco['icone']) # Carrego a imagem dele
		botao.tooltip_text = bloco['nome'] # Carrego o nome dele
		inventarioBlocos.add_child(botao) # O adiciono a minha area contendo os blocos disponiveis da fase
