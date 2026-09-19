import gleam/option.{None, Some}
import sgleam/check
import src/listas.{
  buscar_por_id, conteudo_melhor_avaliado,
  converter_duracao_para_horas, filtrar_por_estado,
  tempo_total_consumido,
}
import src/tipos.{
  Concluido, EmAndamento, Filme, NaoIniciado, Podcast, Serie,
}

fn conteudo_nao_iniciado() -> tipos.Conteudo {
  tipos.Conteudo(
    1,
    "Filme A",
    Filme,
    "Acao",
    120,
    Some(4.0),
    NaoIniciado,
  )
}

fn conteudo_em_andamento() -> tipos.Conteudo {
  tipos.Conteudo(
    2,
    "Serie A",
    Serie,
    "Drama",
    60,
    Some(4.5),
    EmAndamento(30),
  )
}

fn outro_conteudo_em_andamento() -> tipos.Conteudo {
  tipos.Conteudo(
    3,
    "Podcast A",
    Podcast,
    "Tecnologia",
    30,
    None,
    EmAndamento(10),
  )
}

fn conteudo_concluido() -> tipos.Conteudo {
  tipos.Conteudo(
    4,
    "Filme B",
    Filme,
    "Drama",
    90,
    Some(5.0),
    Concluido,
  )
}

pub fn tempo_total_consumido_examples() {
  check.eq(tempo_total_consumido([]), 0)

  check.eq(
    tempo_total_consumido([conteudo_nao_iniciado()]),
    0,
  )

  check.eq(
    tempo_total_consumido([
      conteudo_nao_iniciado(),
      conteudo_em_andamento(),
      conteudo_concluido(),
    ]),
    120,
  )
}

pub fn filtrar_por_estado_examples() {
  let lista = [
    conteudo_nao_iniciado(),
    conteudo_em_andamento(),
    conteudo_concluido(),
    outro_conteudo_em_andamento(),
  ]

  check.eq(
    filtrar_por_estado([], Concluido),
    [],
  )

  check.eq(
    filtrar_por_estado(lista, Concluido),
    [conteudo_concluido()],
  )

  check.eq(
    filtrar_por_estado(lista, EmAndamento(0)),
    [
      conteudo_em_andamento(),
      outro_conteudo_em_andamento(),
    ],
  )
}

pub fn converter_duracao_para_horas_examples() {
  check.eq(
    converter_duracao_para_horas([]),
    [],
  )

  check.eq(
    converter_duracao_para_horas([
      outro_conteudo_em_andamento(),
      conteudo_em_andamento(),
      conteudo_nao_iniciado(),
    ]),
    [0.5, 1.0, 2.0],
  )
}

pub fn buscar_por_id_examples() {
  let lista = [
    conteudo_nao_iniciado(),
    conteudo_em_andamento(),
    conteudo_concluido(),
  ]

  check.eq(
    buscar_por_id([], 1),
    Error(Nil),
  )

  check.eq(
    buscar_por_id(lista, 2),
    Ok(conteudo_em_andamento()),
  )

  check.eq(
    buscar_por_id(lista, 99),
    Error(Nil),
  )
}

pub fn conteudo_melhor_avaliado_examples() {
  let sem_avaliacao_1 =
    tipos.Conteudo(
      5,
      "Podcast B",
      Podcast,
      "Noticias",
      20,
      None,
      NaoIniciado,
    )

  let sem_avaliacao_2 =
    tipos.Conteudo(
      6,
      "Podcast C",
      Podcast,
      "Noticias",
      25,
      None,
      Concluido,
    )

  let melhor_empate =
    tipos.Conteudo(
      7,
      "Filme C",
      Filme,
      "Drama",
      100,
      Some(5.0),
      Concluido,
    )

  check.eq(
    conteudo_melhor_avaliado([]),
    Error(Nil),
  )

  check.eq(
    conteudo_melhor_avaliado([
      sem_avaliacao_1,
      sem_avaliacao_2,
    ]),
    Error(Nil),
  )

  check.eq(
    conteudo_melhor_avaliado([
      sem_avaliacao_1,
      conteudo_em_andamento(),
      conteudo_concluido(),
    ]),
    Ok(conteudo_concluido()),
  )

  check.eq(
    conteudo_melhor_avaliado([
      conteudo_concluido(),
      melhor_empate,
    ]),
    Ok(conteudo_concluido()),
  )
}