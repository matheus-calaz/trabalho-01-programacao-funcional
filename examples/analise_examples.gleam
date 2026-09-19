import gleam/option.{None, Some}
import sgleam/check
import src/analise.{
  gerar_relatorio,
  media_avaliacao_categoria_concluidos,
}
import src/tipos.{
  Concluido,
  EmAndamento,
  Filme,
  NaoIniciado,
  Serie,
}

fn drama_concluido_nota_4() -> tipos.Conteudo {
  tipos.Conteudo(
    1,
    "Drama Um",
    Filme,
    "Drama",
    100,
    Some(4.0),
    Concluido,
  )
}

fn drama_concluido_nota_5() -> tipos.Conteudo {
  tipos.Conteudo(
    2,
    "Drama Dois",
    Filme,
    "Drama",
    90,
    Some(5.0),
    Concluido,
  )
}

fn drama_concluido_sem_nota() -> tipos.Conteudo {
  tipos.Conteudo(
    3,
    "Drama Tres",
    Filme,
    "Drama",
    80,
    None,
    Concluido,
  )
}

fn drama_em_andamento() -> tipos.Conteudo {
  tipos.Conteudo(
    4,
    "Drama Quatro",
    Serie,
    "Drama",
    60,
    Some(3.0),
    EmAndamento(20),
  )
}

fn acao_concluido() -> tipos.Conteudo {
  tipos.Conteudo(
    5,
    "Acao Um",
    Filme,
    "Acao",
    120,
    Some(2.0),
    Concluido,
  )
}

pub fn media_avaliacao_categoria_concluidos_examples() {
  let lista = [
    drama_concluido_nota_4(),
    drama_concluido_sem_nota(),
    drama_em_andamento(),
    acao_concluido(),
    drama_concluido_nota_5(),
  ]

  check.eq(
    media_avaliacao_categoria_concluidos(
      [],
      "Drama",
    ),
    Error(Nil),
  )

  check.eq(
    media_avaliacao_categoria_concluidos(
      [drama_concluido_sem_nota()],
      "Drama",
    ),
    Error(Nil),
  )

  check.eq(
    media_avaliacao_categoria_concluidos(
      lista,
      "Comedia",
    ),
    Error(Nil),
  )

  check.eq(
    media_avaliacao_categoria_concluidos(
      lista,
      "Drama",
    ),
    Ok(4.5),
  )
}

pub fn gerar_relatorio_examples() {
  let nao_iniciado =
    tipos.Conteudo(
      10,
      "Filme Nao Iniciado",
      Filme,
      "Acao",
      120,
      Some(4.0),
      NaoIniciado,
    )

  let em_andamento =
    tipos.Conteudo(
      11,
      "Serie em Andamento",
      Serie,
      "Drama",
      60,
      None,
      EmAndamento(30),
    )

  let concluido =
    tipos.Conteudo(
      12,
      "Filme Concluido",
      Filme,
      "Drama",
      90,
      Some(5.0),
      Concluido,
    )

  check.eq(
    gerar_relatorio([]),
    "Total de itens: 0 | Tempo consumido: 0 minutos | Media de avaliacoes: sem avaliacoes",
  )

  check.eq(
    gerar_relatorio([em_andamento]),
    "Total de itens: 1 | Tempo consumido: 30 minutos | Media de avaliacoes: sem avaliacoes",
  )

  check.eq(
    gerar_relatorio([
      nao_iniciado,
      em_andamento,
      concluido,
    ]),
    "Total de itens: 3 | Tempo consumido: 120 minutos | Media de avaliacoes: 4.5",
  )
}