# Trabalho Prático 1 — Programação Funcional

## Plataforma de streaming e consumo de conteúdo

Projeto desenvolvido para a disciplina de Programação Funcional do curso de Ciência da Computação da Universidade Estadual de Maringá (UEM).

## Integrantes

- Matheus Augusto Muller Calazans — RA: 129678
- Arthur Gomes Spirandelli — RA: 144136

Professor: Wagner Igarashi

## Tema

**Tema 6 — Plataforma de streaming e consumo de conteúdo**

O projeto implementa um sistema funcional para representar e analisar conteúdos de uma plataforma de streaming.

O sistema permite:

- criar e validar conteúdos;
- classificar conteúdos por duração;
- calcular o tempo total consumido;
- filtrar conteúdos pelo estado de consumo;
- converter durações de minutos para horas;
- buscar conteúdos pelo identificador;
- encontrar o conteúdo melhor avaliado;
- calcular médias de avaliação;
- processar uma estrutura hierárquica de catálogo;
- gerar um relatório textual com indicadores da plataforma.

Toda a implementação utiliza funções puras, estruturas imutáveis, tipos algébricos de dados, pattern matching e recursão estrutural explícita.

## Estrutura do projeto

```text
trabalho-01-programacao-funcional/
├── examples/
│   ├── validacao_examples.gleam
│   ├── listas_examples.gleam
│   ├── hierarquia_examples.gleam
│   └── analise_examples.gleam
├── src/
│   ├── tipos.gleam
│   ├── validacao.gleam
│   ├── listas.gleam
│   ├── hierarquia.gleam
│   └── analise.gleam
├── README.md
└── sgleam.exe
```

## Tipos de dados

### `TipoMidia`

Tipo soma que representa os tipos de mídia disponíveis:

- `Filme`
- `Serie`
- `Documentario`
- `Podcast`

### `EstadoConsumo`

Tipo soma que representa o estado de consumo de um conteúdo:

- `NaoIniciado`
- `EmAndamento(progresso_minutos: Int)`
- `Concluido`

O estado `EmAndamento` armazena a quantidade de minutos já consumidos.

### `CategoriaDuracao`

Tipo soma utilizado para classificar a duração:

- `Curto`
- `Medio`
- `Longo`

### `Conteudo`

Tipo produto principal do sistema. Possui os seguintes campos:

- `id`;
- `titulo`;
- `tipo`;
- `categoria`;
- `duracao_minutos`;
- `avaliacao`;
- `estado`.

A avaliação é representada por `Option(Float)`, permitindo:

- `Some(nota)`, quando existe uma avaliação;
- `None`, quando o conteúdo ainda não foi avaliado.

### `Catalogo`

Tipo autorreferente que representa a hierarquia de categorias:

- `Vazio`;
- `NoCatalogo(nome, subcategorias, conteudos)`.

Cada nó pode possuir uma lista de conteúdos e uma lista de outros catálogos, formando uma árvore.

## Regras de domínio

Um conteúdo é considerado válido quando:

1. o identificador é maior que zero;
2. a duração em minutos é maior que zero;
3. a avaliação, quando presente, está entre `0.0` e `5.0`.

A duração é classificada da seguinte forma:

| Classificação | Duração |
|---|---:|
| `Curto` | Até 30 minutos |
| `Medio` | De 31 a 90 minutos |
| `Longo` | Mais de 90 minutos |

Para o cálculo do tempo consumido:

- conteúdo `NaoIniciado` contribui com zero minutos;
- conteúdo `EmAndamento` contribui com seu progresso;
- conteúdo `Concluido` contribui com sua duração completa.

## Mapeamento das funcionalidades

| Requisito | Descrição | Função | Arquivo |
|---|---|---|---|
| F1 | Criação e validação | `criar_conteudo` | `src/validacao.gleam` |
| F2 | Classificação por duração | `classificar_duracao` | `src/validacao.gleam` |
| F3 | Tempo total consumido | `tempo_total_consumido` | `src/listas.gleam` |
| F4 | Filtragem por estado | `filtrar_por_estado` | `src/listas.gleam` |
| F5 | Conversão de minutos para horas | `converter_duracao_para_horas` | `src/listas.gleam` |
| F6 | Busca por identificador | `buscar_por_id` | `src/listas.gleam` |
| F7 | Conteúdo melhor avaliado | `conteudo_melhor_avaliado` | `src/listas.gleam` |
| F8 | Média por categoria dos concluídos | `media_avaliacao_categoria_concluidos` | `src/analise.gleam` |
| F9 | Contagem hierárquica | `total_conteudos_catalogo` | `src/hierarquia.gleam` |
| F9 | Busca de títulos na hierarquia | `listar_titulos_categoria` | `src/hierarquia.gleam` |
| F10 | Relatório textual | `gerar_relatorio` | `src/analise.gleam` |

## Recursão

As funções recursivas foram implementadas explicitamente com pattern matching, utilizando os casos:

```gleam
[]
```

e:

```gleam
[primeiro, ..resto]
```

Não foram utilizadas funções como `map`, `filter`, `fold` ou `reduce` para substituir as recursões exigidas.

Também foram implementadas funções recursivas para percorrer a árvore `Catalogo`.

## Tratamento de ausência e falha

O sistema utiliza:

- `Option(Float)` para avaliações opcionais;
- `Result(Conteudo, Nil)` para criação e busca de conteúdos;
- `Result(Float, Nil)` para médias que podem não existir.

Quando não existe um conteúdo ou uma avaliação adequada, a função correspondente devolve `Error(Nil)`.

## Execução dos testes

Os comandos devem ser executados na pasta raiz do projeto.

### Windows

Para executar todos os testes:

```powershell
.\sgleam.exe -t examples/validacao_examples.gleam examples/listas_examples.gleam examples/hierarquia_examples.gleam examples/analise_examples.gleam
```

Para executar os testes separadamente:

```powershell
.\sgleam.exe -t examples/validacao_examples.gleam
.\sgleam.exe -t examples/listas_examples.gleam
.\sgleam.exe -t examples/hierarquia_examples.gleam
.\sgleam.exe -t examples/analise_examples.gleam
```

### Linux ou macOS

O executável correspondente deve estar na raiz do projeto e possuir permissão de execução:

```bash
chmod +x ./sgleam
```

Para executar todos os testes:

```bash
./sgleam -t examples/validacao_examples.gleam examples/listas_examples.gleam examples/hierarquia_examples.gleam examples/analise_examples.gleam
```

## Resultado esperado

A execução completa deve apresentar:

```text
Running tests...
43 tests, 43 success(es), 0 failure(s) and 0 error(s).
```

Os testes contemplam:

- valores válidos;
- valores inválidos;
- limites das classificações;
- listas vazias;
- busca com e sem resultado;
- conteúdos sem avaliação;
- empate entre avaliações;
- categorias inexistentes;
- catálogos vazios;
- subcategorias;
- categorias repetidas;
- relatórios com e sem avaliações.

## Tecnologias utilizadas

- Gleam;
- Student Gleam (`sgleam`);
- `sgleam/check`;
- Visual Studio Code;
- Git e GitHub Desktop.

## Restrições

O projeto não utiliza:

- banco de dados;
- interface gráfica;
- API externa;
- estado mutável;
- efeitos colaterais no núcleo de processamento.