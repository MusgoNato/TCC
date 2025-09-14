extends Node

## Variável global para verificação de qual fase foi selecionada
var fase_selecionada: int = 0
var pontuacao_do_jogador: int = 0

## Variavel global para tela de configuraçoes
var valor_som_config: float = 5.0
var valor_brilho_config: float = 5.0
var dicas_config: bool = true

## Constantes para os valores padrao das configuracoes
const CONFIG_SOM: float = 5.0
const CONFIG_BRILHO: float = 5.0
const CONFIG_DICAS: bool = true

# Constantes para as cores da mensagem ao jogador
const COR_ERRO: String = "red"
const COR_DICA: String = "yellow"
const COR_SUCESSO: String = "lime_green"

# Mensagens prontas para exibir ao jogador (erros, dicas e informacoes)
const MSG_BLOCO_REPETICAO_SEM_FECHAMENTO: String = "[color=%s]ERRO:[/color] Bloco de repetição sem fechamento correspondente" % self.COR_ERRO
const MSG_BLOCO_DESCARTE: String = "Bloco descartado com [color=%s]sucesso[/color]!" % self.COR_SUCESSO
const MSG_CHECKPOINT_ALCANCADO: String = "[color=%s]SUCESSO:[/color] Checkpoint Alcançado" % self.COR_SUCESSO
const MSG_NENHUM_CHECKPOINT_ALCANCADO: String = "[color=%s]Tente novamente![/color] O próximo checkpoint não foi alcançado." % self.COR_DICA
const MSG_LIMITE_BLOCOS_ATINGIDO: String = "[color=%s]Limite de blocos atingido![/color] Tente com menos blocos, você consegue!" % self.COR_DICA
const MSG_COLIDIU_INIMIGO: String = "[color=%s]Colisão[/color]  com o inimigo" % self.COR_ERRO
const MSG_INIMIGO_DERROTADO: String = "[color=%s]SUCESSO: Inimigo derrotado!" % self.COR_SUCESSO

# Estrelas do jogador
const PONTUACAO_3_ESTRELAS: int = 300 # 5 minutos em segundos
const PONTUACAO_2_ESTRELAS: int = 120 # 2 minutos em segundos
const PONTUACAO_1_ESTRELA: int = 1 # 1 segundo em segundos

# Checkpoints para cada fase
const FASE_1: int = 2
const FASE_2: int = 3
const FASE_3: int = 5
const FASE_4: int = 7

### vetor para armazenamento dos checkpoints de cada fase do jogo
var quant_checkpoints_fases: Array = [FASE_1, FASE_2, FASE_3, FASE_4]


## Tempo de cada instrução na tela
const TEMPO_INSTRUCOES_INICIAS: int = 1

## Instrucoes inicias de cada fase para o jogador
var texto_instrucoes_iniciais: Array = [
	# Fase 1: Movimento
	[
		"Bem-vindo à fase de movimento!",
		"Seu objetivo é guiar o personagem até o fim do percurso usando os blocos disponíveis.",
		"Arraste e solte os blocos na área de montagem para criar sua primeira sequência de código!",
		"Não se esqueça que o tempo está correndo. Seja rápido para conseguir mais estrelas!",
		"Boa sorte, você consegue!",
	],
	
	# Fase 2: Condicionais
	[
		"Bem-vindo à fase de condicionais!",
		"Agora, sua lógica pode tomar decisões. Use o bloco 'se' para checar uma condição e decidir qual caminho seguir.",
		"Arraste os blocos e solte-os na área de montagem.",
		"Clique em 'executar' para ver a sua lógica em ação. Lembre-se de testar diferentes cenários.",
		"Boa sorte e divirta-se criando suas primeiras decisões!",
	],
	
	# Fase 3: Repetição
	[
		"Bem-vindo à fase de repetição!",
		"A repetição nos permite executar o mesmo comando várias vezes sem ter que repetir os blocos.",
		"Use o bloco 'repita' para deixar sua lógica mais curta e organizada.",
		"Teste a sua lógica clicando em 'executar' e veja como a repetição funciona!",
		"Vamos lá, mostre que você domina a repetição!",
	],
	
	# Fase 4: Funções
	[
		"Bem-vindo à fase de funções!",
		"Funções nos ajudam a organizar o código em pedaços reutilizáveis. Pense nelas como uma caixa que guarda um conjunto de blocos.",
		"Crie sua primeira função usando a área da função, e chame-a quando precisar.",
		"Com funções, você pode resolver problemas complexos com mais facilidade.",
		"Divirta-se explorando o poder das funções!"
	]
]

# Dicas para o jogador, de acordo com a fase em que ele esta
var dicas_ao_jogador: PackedStringArray = [
	"Pensar na lógica passo a passo, ajuda a resolver os desafios.",
	"Completar a fase em menos tempo garante mais estrelas!",
	"Dividir um problema grande em partes menores facilita a solução.",
	"Aperte r para recomeçar a fase ou no botão Resetar ao apertar ESC",
	"Não desista! Todo problema tem uma solução.",
	"Otimizar o seu código é tão importante quanto fazê-lo funcionar!",
	"Fique de olho nos inimigos. Eles podem ser a chave para o próximo passo.",
	"Você consegue arrastar e soltar os blocos em qualquer lugar da área de montagem.",
	"A pontuação de estrelas é sua recompensa por um trabalho bem feito!",
	"Consiga todos os checkpoints para passar para a próxima fase"	
]

## Sinal global para exibicao das dicas, avisos e erros para o jogador
signal mensagem_para_jogador(mensagem)

## Funcao responsavel por enviar o sinal da mensagem a cena correspondente
func enviar_mensagem_ao_jogador(mensagem: String):
	emit_signal("mensagem_para_jogador", mensagem)
