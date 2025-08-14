extends Node

## Variável global para verificação de qual fase foi selecionada
var fase_selecionada: int = 0

var texto_instrucoes_iniciais = [
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
