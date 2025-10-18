# Visão Geral

Este é um jogo educacional desenvolvido em Godot Engine 4.4.1 com o objetivo de ensinar conceitos básicos de programação (Sequência, Condicionais, Repetição e Função ) utilizando a mecânica de blocos no estilo drag and drop.

# Requisitos de Sistema

Para rodar este projeto a partir dos arquivos-fonte, você precisará da Engine Godot instalada.

* <a href="https://godotengine.org/download/archive/4.4.1-stable/">Link para download da Engine Godot 4.4.1</a>

* Sistema Operacional: Windows, macOS ou Linux(suportados pela Godot Engine).

# Como Executar o Jogo (a partir dos Arquivos Fonte)

Siga os passos abaixo para abrir e executar o projeto no ambiente de desenvolvimento:

1. Descompacte o arquivo TCC.zip em um local de fácil acesso;
2. Abra a Engine Godot e na tela inicial do gerenciador de projetos, clique em "Importar" ou "Import Existing Project";
3. Navegue até a pasta que você extraiu no passo 1 e selecione o arquivo de configuração principal: project.godot.
4. Clique em "Importar e abrir".
5. Após o projeto carregar na Engine, clique no ícone "Play Scene" (o ícone no canto superior direito da tela ou pressione F5).

# Como Jogar (Instruções Básicas)

O objetivo em cada fase é levar o personagem ao ponto final (Objetivo) utilizando a sequência correta de blocos de programação.

## Montagem do Código:
Arraste os blocos de comando (ex: esquerda, direita, condicional) da Paleta de Blocos para a Área de montagem. Encaixe os blocos na ordem que você deseja que o personagem execute as ações.

## Execução:
Clique no botão "Executar" para que o personagem comece a seguir as instruções do seu código.

5. Estrutura do Projeto

        "res://:" Pasta principal contendo todos os recursos.

        "res://assets/:" Contém as imagens, sprites e sons do jogo.
        
        "res://scenes/:" Contém as cenas (.tscn) de cada fase e da interface principal.

        "res://scripts/:" Contém os códigos GDScript (.gd) para a lógica do jogo (personagem, blocos, gerenciador de fases).

        "res://utils/:" Contém o arquivo dados.json, um dicionário em json para carregar as informações dos blocos de código e TutorialBorda.tres, um node visual global para marcação das bordas de algumas interfaces exclusivamente na fase de tutorial .

## Desenvolvido por:
Programador: Hugo josue lema das neves

Curso: Sistemas de Informação

Orientador: Prof Dr. Diogo Fernando Trevisan