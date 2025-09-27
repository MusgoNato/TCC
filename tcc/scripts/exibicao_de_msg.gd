extends RichTextLabel

@onready var timer: Timer = $"../Timer"

# Limite máximo de mensagens na fila
const MAX_QUEUE_SIZE: int = 5

# Fila de mensagens para evitar sobreposição
var message_queue: Array = []

# Flag para verificar se uma mensagem já está sendo exibida
var is_displaying_message: bool = false

func _ready() -> void:
	# Inicializa o gerador de números aleatórios
	randomize()
	
	# Habilita as cores da mensagem
	self.bbcode_enabled = true
	
	# Conecta sinal global para mensagens do jogo
	GlobalScript.connect("mensagem_para_jogador", Callable(self, "_on_mensagem_para_jogador"))
	
	# Verificação para as dicas do jogo, somente se estiver ativa exibe dicas e mensagens
	if GlobalScript.dicas_config:
		# Conecta o timeout do timer para exibir dicas
		timer.wait_time = GlobalScript.TIMEOUT_MSG
		timer.timeout.connect(add_tip_to_queue)
		timer.start()

## Adiciona uma mensagem global à fila com verificação de limite
func _on_mensagem_para_jogador(texto: String):
	if GlobalScript.dicas_config:
		# Verifica se a fila atingiu o limite
		if message_queue.size() >= MAX_QUEUE_SIZE:
			# Remove a mensagem mais antiga (a primeira da fila)
			message_queue.pop_front()
		# Adiciona a nova mensagem ao final da fila
		message_queue.append(texto)
		
		process_message_queue()

## Adiciona uma dica aleatória à fila com verificação de limite
func add_tip_to_queue():
	if not GlobalScript.dicas_ao_jogador:
		return
	
	var random_tip = GlobalScript.dicas_ao_jogador[randi() % GlobalScript.dicas_ao_jogador.size()]
	
	# Verifica se a fila atingiu o limite
	if message_queue.size() >= MAX_QUEUE_SIZE:
		# Remove a mensagem mais antiga (a primeira da fila)
		message_queue.pop_front()
	# Adiciona a nova dica ao final da fila
	message_queue.append(random_tip)
	
	process_message_queue()

## Processa a fila de mensagens
func process_message_queue():
	if is_displaying_message or message_queue.is_empty():
		return
	
	var next_message = message_queue.pop_front()
	
	_show_and_fade_message(next_message)

## Função que lida com a exibição e o efeito de fade
func _show_and_fade_message(texto: String):
	is_displaying_message = true
	
	self.text = texto
	self.visible = true
	
	var tween := create_tween()
	self.modulate.a = 0
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	
	await get_tree().create_timer(GlobalScript.TIME_FADE_MSG).timeout
	
	var fade_out := create_tween()
	fade_out.tween_property(self, "modulate:a", 0.0, 0.3)
	await fade_out.finished
	
	self.visible = false
	is_displaying_message = false
	
	# Após a animação, verifica se há mais mensagens na fila
	process_message_queue()
	
func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	Input.set_custom_mouse_cursor(GlobalScript.textura_mouse_arrastando_bloco, Input.CURSOR_CAN_DROP, Vector2(16,16))
	return true
