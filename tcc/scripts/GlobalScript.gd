extends Node

# Dev
var info_debug: bool = true
var liberar_todas_fases: bool = true

# Textura do mouse
var textura_mouse_area_pra_soltar_bloco = preload("res://assets/mouse_asset/PNG/Basic/Default/hand_open.png")
var textura_padrao_mouse_ponteiro = preload("res://assets/mouse_asset/PNG/Basic/Default/pointer_c.png")
var textura_mouse_arrastando_bloco = preload("res://assets/mouse_asset/PNG/Basic/Default/hand_closed.png")

# Variável global para verificação de qual fase foi selecionada
var fase_selecionada: int = 0
var pontuacao_do_jogador: int = 0

# Variavel global para tela de configuraçoes
var valor_som_config: float = 2.0
var valor_brilho_config: float = 1.0
var dicas_config: bool = true

# Constantes para os valores padrao das configuracoes
const CONFIG_SOM: float = 2.0
const CONFIG_BRILHO: float = 1.0
const CONFIG_DICAS: bool = true

# Constantes para as cores da mensagem ao jogador
const COR_ERRO: String = "red"
const COR_DICA: String = "yellow"
const COR_SUCESSO: String = "lime_green"

# Tempo do temporizador das mensagens ao jogador
const TIMEOUT_MSG: float = 15.0

# Tempo do fade da mensagem
const TIME_FADE_MSG: float = 3.5 

# Mensagens prontas para exibir ao jogador (erros, dicas e informacoes)
const MSG_BLOCO_REPETICAO_SEM_FECHAMENTO: String = "[color=%s]ERRO:[/color] Bloco de repetição sem fechamento correspondente" % self.COR_ERRO
const MSG_BLOCO_DESCARTE: String = "Bloco descartado com [color=%s]sucesso[/color]!" % self.COR_SUCESSO
const MSG_CHECKPOINT_ALCANCADO: String = "[color=%s]SUCESSO:[/color] Checkpoint Alcançado" % self.COR_SUCESSO
const MSG_NENHUM_CHECKPOINT_ALCANCADO: String = "[color=%s]Tente novamente![/color] O próximo checkpoint não foi alcançado." % self.COR_DICA
const MSG_LIMITE_BLOCOS_ATINGIDO: String = "[color=%s]Limite de blocos atingido![/color] Tente com menos blocos, você consegue!" % self.COR_DICA
const MSG_COLIDIU_INIMIGO: String = "[color=%s]Colisão[/color]  com o inimigo" % self.COR_ERRO
const MSG_INIMIGO_DERROTADO: String = "[color=%s]SUCESSO: Inimigo derrotado!" % self.COR_SUCESSO

# Estrelas do jogador
const PONTUACAO_3_ESTRELAS: int = 420 # 3 minutos
const PONTUACAO_2_ESTRELAS: int = 240 # 6 minutos
const PONTUACAO_1_ESTRELA: int = 60 # 9 minutos

# Checkpoints para cada fase
const FASE_1: int = 2
const FASE_2: int = 3
const FASE_3: int = 5
const FASE_4: int = 7
const FASE_TUTORIAL: int = 1

# vetor para armazenamento dos checkpoints de cada fase do jogo
var quant_checkpoints_fases: Array = [FASE_TUTORIAL, FASE_1, FASE_2, FASE_3, FASE_4]

# Tempo de cada instrução na tela
var TEMPO_INSTRUCOES_INICIAS: float = 5

# Mensagens do tutorial para cada area
var msg_tutorial: Array = [
	"Esta é a [b][color=#FFAA00]paleta de blocos[/color][/b], a cada fase será adicionado um ou mais blocos com [b]funcionalidades diferentes[/b]. [b][color=#FFAA00]ENTER[/color][/b] >> Avançar",
	"Esta é a [b][color=#FF5555]lixeira[/color][/b], é aqui que você irá [b]descartar os blocos[/b]. [b][color=#FFAA00]ENTER[/color][/b] >> Avançar",
	"Aqui é onde você poderá ver seu [b][color=#00CCFF]personagem[/color][/b] se movimentar e o que cada bloco fará ao posicioná-lo na [b]área de montagem[/b]. [b][color=#FFAA00]ENTER[/color][/b] >> Avançar",
	"Esta é uma [b][color=#FFAA00]área de dicas e mensagens[/color][/b] que aparecerá à medida que avança no jogo, preste atenção às mensagens, pois elas indicam algum [b][color=#FF5555]erro[/color][/b] que está cometendo ou informações importantes sobre como utilizar alguns blocos. [b][color=#FFAA00]ENTER[/color][/b] >> Avançar",
	"Esta é a [b][color=#00CCFF]área da montagem[/color][/b], é aqui que você soltará os blocos da paleta e montará sua [b]lógica[/b] para refletir no percurso do personagem. [b][color=#FFAA00]ENTER[/color][/b] >> Avançar",
	"Este é o [b][color=#FFAA00]botão de execução[/color][/b] de toda a sua lógica feita dentro da área de montagem. Após terminar de montar os blocos, aperte no botão para ver a [b]execução[/b] da sua lógica."
]


# Instrucoes inicias de cada fase para o jogador
var texto_instrucoes_iniciais: Array = [
	
	# Tutorial
	[
		"Bem-vindo ao [b][color=#FFAA00]tutorial[/color][/b]! Aqui você aprenderá as [b]mecânicas básicas[/b] do jogo.",
		"Você controlará o seu [b][color=#00CCFF]personagem[/color][/b] através da mecânica de [b]arrastar e soltar[/b]. Para isso, arraste um dos blocos da [b]área de blocos disponíveis[/b].",
		"Cada [b]bloco[/b], à medida que avança nas fases, possuirá uma [b]função específica[/b].",
		"Observe como o [b]personagem[/b] reage quando os [b]blocos são executados[/b].",
		"Quando estiver pronto, pressione [b][color=#00FF00]ENTER[/color][/b] para avançar entre os destaques do tutorial e continuar aprendendo.",
		"Não se preocupe em [b][color=#FF5555]errar[/color][/b]! Você pode resetar a fase ou tentar novamente quantas vezes quiser.",
		"Ao final do tutorial, você estará pronto para enfrentar os [b][color=#FFAA00]desafios[/color][/b] da fase real do jogo. [i]Boa sorte![/i]"
	],
	
	# Fase 1: Movimento
	[
		"Bem-vindo à [b][color=#FFAA00]fase de movimento[/color][/b]!",
		"Seu objetivo é guiar o [b][color=#00CCFF]personagem[/color][/b] até o fim do percurso usando os [b]blocos disponíveis[/b].",
		"Cada bloco apresentado pelas [b]setas[/b] representa o [b]movimento[/b] do jogador.",
		"Arraste e solte os blocos na [b][color=#FFAA00]área de montagem[/color][/b] para criar sua primeira sequência de código!",
		"Não se esqueça que o tempo está correndo. Seja rápido para conseguir mais [b][color=#00FF00]estrelas[/color][/b]!",
		"[b]Boa sorte![/b]"
	],

	# Fase 2: Condicionais
	[
		"Bem-vindo à [b][color=#FFAA00]fase de condicionais[/color][/b]!",
		"Agora, sua lógica pode tomar [b]decisões[/b]. O bloco condicional atuará como uma verificação se há um [b][color=#00CCFF]inimigo[/color][/b] na próxima posição do jogador. Caso seja verdade, o inimigo será eliminado e o personagem conseguirá prosseguir; caso contrário, ocorrerá uma colisão e o personagem voltará ao último checkpoint alcançado.",
		"Arraste os [b]blocos[/b] e solte-os na [b][color=#FFAA00]área de montagem[/color][/b].",
		"Clique em '[b]executar[/b]' para ver sua lógica em ação. Lembre-se de testar diferentes cenários.",
		"[b]Boa sorte[/b] e divirta-se criando suas primeiras decisões!"
	],

	# Fase 3: Repetição
	[
		"Bem-vindo à [b][color=#FFAA00]fase de repetição[/color][/b]!",
		"A repetição nos permite executar o mesmo comando várias vezes sem precisar repetir os blocos manualmente.",
		"Para usar corretamente o bloco [b]'repita'[/b], primeiro arraste um bloco [b]repita_início[/b] e feche-o com um bloco [b]repita_fim[/b]. Todos os blocos entre esses dois serão repetidos de acordo com a quantidade especificada no [b]repita_início[/b].",
		"Use o bloco '[b]repita[/b]' para deixar sua lógica mais curta e organizada.",
		"Teste sua lógica clicando em '[b]executar[/b]' e veja como a repetição funciona!",
		"[b]Vamos lá[/b], mostre que você domina a repetição!"
	],

	# Fase 4: Funções
	[
		"Bem-vindo à [b][color=#FFAA00]fase de funções[/color][/b]!",
		"Funções nos ajudam a organizar o código em pedaços [b]reutilizáveis[/b]. Pense nelas como uma [b]caixa[/b] que guarda um conjunto de blocos.",
		"Crie sua primeira função usando a [b][color=#FFAA00]área da função[/color][/b] e chame-a quando precisar.",
		"Com funções, você pode resolver problemas [b]complexos[/b] com mais facilidade.",
		"[b]Divirta-se[/b] explorando o poder das funções!"
	]
]

# Dicas para o jogador, de acordo com a fase em que ele esta
var dicas_ao_jogador: PackedStringArray = [
	"[b]Pensar na lógica passo a passo[/b] ajuda a resolver os desafios.",
	"Completar a fase em menos tempo garante mais [b][color=#00FF00]estrelas[/color][/b]!",
	"Dividir um problema grande em partes menores facilita a [b]solução[/b].",
	"Aperte [b]R[/b] para recomeçar a fase ou no botão [b]Resetar[/b] ao apertar [b]ESC[/b].",
	"Não desista! Todo problema tem uma [b][color=#FF5555]solução[/color][/b].",
	"Otimizar o seu [b]código[/b] é tão importante quanto fazê-lo [b]funcionar[/b]!",
	"Fique de olho nos [b][color=#FFAA00]inimigos[/color][/b]. Eles podem ser a chave para o próximo passo.",
	"Você consegue [b]arrastar e soltar[/b] os blocos em qualquer lugar da [b][color=#FFAA00]área de montagem[/color][/b].",
	"A pontuação de [b][color=#00FF00]estrelas[/color][/b] é sua recompensa por um trabalho bem feito!",
	"Consiga todos os [b][color=#00CCFF]checkpoints[/color][/b] para passar para a próxima fase."
]


## Sinal global para exibicao das dicas, avisos e erros para o jogador
signal mensagem_para_jogador(mensagem)

func _ready() -> void:
	SaveManager.carregar_config_utilitarios()

## Funcao responsavel por enviar o sinal da mensagem a cena correspondente
func enviar_mensagem_ao_jogador(mensagem: String):
	emit_signal("mensagem_para_jogador", mensagem)
	
## Funcao responsavel por aplicar brilho a cena (Esta funcao eh referente a cena global carregada pelo autoload GlobalEffects)
func aplicar_brilho_a_cena(_canvas_modulate_node: CanvasModulate = null) -> void:
	# Aplica o brilho global da configuração usando o GlobalEffects autoload
	if Engine.has_singleton("GlobalEffects"):
		GlobalEffects.set_brilho(valor_brilho_config)

## Funcao responsavel por aplicar vrilho a uma cena especifica
func aplicar_brilho_em_cena_especifica(_canvas_modulate_node: CanvasModulate = null) -> void:
	var v = clamp(GlobalScript.valor_brilho_config, 0.0, 1.0)
	_canvas_modulate_node.color = Color(v, v, v, 1.0)
