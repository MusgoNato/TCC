extends Node

## Variável global para verificação de qual fase foi selecionada
var fase_selecionada: int = 0

# Constantes para as cores da mensagem ao jogador
const COR_ERRO: String = "red"
const COR_DICA: String = "yellow"
const COR_SUCESSO: String = "lime_green"

# Mensagens prontas para exibir ao jogador (erros, dicas e informacoes)
const MSG_BLOCO_REPETICAO_SEM_FECHAMENTO: String = "[color=%s]ERRO:[/color] Bloco de repetição sem fechamento correspondente" % self.COR_ERRO
const MSG_BLOCO_DESCARTE: String = "Bloco descartado com [color=%s]sucesso[/color]!" % self.COR_SUCESSO
const MSG_CHECKPOINT_ALCANCADO: String = "[color=%s]SUCESSO:[/color] Checkpoint Alcançado" % self.COR_SUCESSO
const MSG_NENHUM_CHECKPOINT_ALCANCADO: String = "[color=%s]Volte e tente de novo![/color] O checkpoint não foi alcançado." % self.COR_DICA
const MSG_LIMITE_BLOCOS_ATINGIDO: String = "[color=%s]Limite de blocos atingido![/color] Tente com menos blocos, você consegue!" % self.COR_DICA

## Vetor de instrucoes para cada fase
var texto_instrucoes_iniciais: Array = [
	# Fase 1
	[
		"Bem-vindo à fase de movimento!",
		"Arraste e solte os blocos disponiveis na area de montagem",
		"Clique em executar para visualizar o percuso do personagem",
		"Boa sorte!"
	],
	
	# Fase 2
	[
		"Bem-vindo à fase de condicionais!",
		"Lembre-se, arraste os blocos e solte-os na área de montagem localizada na parte inferior",
		"Clique em executar para visualizar a lógica que você montou e verifique se é a correta",
		"Boa sorte!"
	],
	
	# Fase 3
	[
		"Bem vindo à fase de repetição!",
		"Agora, você entrou na fase de repetição. A poderosa repetição, conseguindo 
		reusar blocos para que você possa deixar enxuto sua lógica e mais visível",
		"Boa sorte e lembre-se de usar a lógica :)"
	],
	
	# Fase 4
	[
		"Bem vindo à fase de funções!",
		"Texto para fase de funções",
		"Texto para fase de funções",
		"Texto para fase de funções"
	]
]

# Dicas para o jogador, de acordo com a fase em que ele esta
var dicas: Array = [
	# Fase 1 (Movimento)
	[
		"Arraste o bloco de movimento para a área de código para fazê-lo funcionar",
		"Os blocos se encaixam como peças de um quebra-cabeça. Conecte-os para criar um comando completo",	
		"O seu personagem executará os comandos do topo para a base. A ordem importa!",
		"Pense nos comandos passo a passo. O que o personagem precisa fazer primeiro?"
	],
	
	# Fase 2 (Condição)
	[
		"Leia seu código como uma história: 'Se há um obstáculo, eu quebro. Então, eu avanço'",
		"Lembre-se, o bloco de condição verifica qual bloco deve ser quebrado no caminho percorrido",
		"A condição é essencial para quebrar obstáculos",
	],
	
	# Fase 3 (Repetição)
	[
		"Lembre-se, o bloco de repetição sempre deve ser encerrado",
		"O bloco de repetição é essencial evitar duplicação de código",
	],
	
	# Fase 4 (Função)
	[
		"A função é essencial para encapsular blocos",
	],
] 

## Sinal global para exibicao das dicas, avisos e erros para o jogador
signal mensagem_para_jogador(mensagem)

## Funcao responsavel por enviar o sinal da mensagem a cena correspondente
func enviar_mensagem_ao_jogador(mensagem: String):
	emit_signal("mensagem_para_jogador", mensagem)
