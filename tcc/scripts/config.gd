extends Control

@onready var brilho: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/brilho
@onready var brilho_num: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/brilho_num
@onready var som: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/som
@onready var som_num: Label = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/som_num
@onready var dicas: CheckButton = $MarginContainer/HBoxContainer/VBoxContainer/dicas
@onready var confirmation_dialog: ConfirmationDialog = $MarginContainer/HBoxContainer/ConfirmationDialog

# Adicione referências aos seus botões
@onready var btn_salvar: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/salvar_alteracoes
@onready var btn_resetar: Button = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer3/resetar_valores

# Botao para aumentar ou diminuir tempo das instrucoes iniciais
@onready var button: SpinBox = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer4/Button

# Variáveis para armazenar o estado original das configurações ao entrar na tela
var brilho_original: float
var som_original: float
var dicas_originais: bool

func _ready() -> void:
	# 1. Atribui os valores globais aos controles da UI.
	brilho.value = GlobalScript.valor_brilho_config
	som.value = GlobalScript.valor_som_config
	dicas.button_pressed = GlobalScript.dicas_config
	
	# 2. Armazena os valores originais para a verificação do botão "Voltar".
	brilho_original = brilho.value
	som_original = som.value
	dicas_originais = dicas.button_pressed
	
	# Para debug mais rapido das informacoes
	button.value = GlobalScript.TEMPO_INSTRUCOES_INICIAS
	
	# 4. Atualiza os textos da UI.
	brilho_num.text = str(brilho.value)
	som_num.text = str(som.value)
	
	# 5. Configura o diálogo de confirmação.
	confirmation_dialog.dialog_text = "Você fez alterações nas configurações. Deseja sair sem salvar?"
	confirmation_dialog.title = "Sair sem salvar?"
	confirmation_dialog.ok_button_text = "Sair sem salvar"
	confirmation_dialog.cancel_button_text = "Cancelar"
	
## Sinal responsavel para voltar ao menu inicial
func _on_btn_voltar_config_pressed() -> void:
	
	# A verificação agora compara os valores atuais da UI com os valores originais
	if brilho.value != brilho_original or som.value != som_original or dicas.button_pressed != dicas_originais:
		confirmation_dialog.popup_centered()
	else:
		GlobalEffects.set_brilho(GlobalScript.valor_brilho_config)
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

## Sinal responsavel pela mudança de brilho do jogo
func _on_brilho_value_changed(value: float) -> void:
	brilho_num.text = str(value)
	GlobalScript.valor_brilho_config = value
	
	# Chama o autoload para aplicar globalmente
	GlobalEffects.set_brilho(value)

## Sinal responsavel para ativar/desativar dicas
func _on_dicas_pressed() -> void:
	
	# Atualiza a variável global quando o botão é pressionado
	GlobalScript.dicas_config = dicas.button_pressed

## Sinal responsavel pelo diálogo de confirmação quando o botão OK (Sair sem salvar) é clicado
func _on_confirmation_dialog_confirmed() -> void:
	
	# Reverte as alterações para os valores originais antes de sair
	GlobalScript.valor_brilho_config = brilho_original
	GlobalScript.valor_som_config = som_original
	GlobalScript.dicas_config = dicas_originais
	
	GlobalEffects.set_brilho(GlobalScript.valor_brilho_config)
	
	# Mude a cena, mas não salve nada
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

## Sinal responsavel por salvar alterações
func _on_salvar_alteracoes_pressed() -> void:
	# Chama a função de salvamento no SaveManager
	SaveManager.salvar_config_utilitarios()

	# Atualiza as variáveis 'originais' para que o botão 'Voltar' saiba que as mudanças foram salvas
	brilho_original = brilho.value
	som_original = som.value
	dicas_originais = dicas.button_pressed

## Funcao resposavel por resetar configuracoes para o padrao
func _on_resetar_valores_pressed() -> void:
	# Atualiza os valores globais para os valores padrão
	GlobalScript.valor_brilho_config = GlobalScript.CONFIG_BRILHO
	GlobalScript.valor_som_config = GlobalScript.CONFIG_SOM
	GlobalScript.dicas_config = GlobalScript.CONFIG_DICAS
	
	# Atualiza a UI para refletir os valores globais que acabaram de ser resetados
	brilho.value = GlobalScript.valor_brilho_config
	som.value = GlobalScript.valor_som_config
	dicas.button_pressed = GlobalScript.dicas_config
		
	# Salva os valores padrão no arquivo para persistência
	SaveManager.salvar_config_utilitarios()
	
	# Atualiza os valores 'originais' para que o botão 'Voltar' saiba que o estado é o padrão
	brilho_original = brilho.value
	som_original = som.value
	dicas_originais = dicas.button_pressed
	
	if GlobalScript.info_debug:
		print("Configurações resetadas para o padrão!")

## Sinal responsavel pela mudanca da quantidade de tempo para cada intrucao aparecer na tela
func _on_button_value_changed(value: float) -> void:
	GlobalScript.TEMPO_INSTRUCOES_INICIAS = value

## Sinal responsavel pela modificacao do som do jogo
func _on_som_value_changed(value: float) -> void:
	som_num.text = str(value)
	
	# Atualiza a variável global em tempo real
	GlobalScript.valor_som_config = value
