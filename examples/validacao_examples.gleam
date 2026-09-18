import gleam/option.{None, Some}
import sgleam/check
import src/tipos.{
  Concluido, Curto, Documentario, EmAndamento, Filme, Longo, Medio,
  NaoIniciado, Podcast, Serie,
}
import src/validacao.{classificar_duracao, criar_conteudo}

pub fn criar_conteudo_examples() {
  check.eq(
    criar_conteudo(
      1,
      "Filme A",
      Filme,
      "Acao",
      120,
      Some(4.5),
      Concluido,
    ),
    Ok(tipos.Conteudo(
      1,
      "Filme A",
      Filme,
      "Acao",
      120,
      Some(4.5),
      Concluido,
    )),
  )

  check.eq(
    criar_conteudo(
      2,
      "Podcast A",
      Podcast,
      "Tecnologia",
      30,
      None,
      NaoIniciado,
    ),
    Ok(tipos.Conteudo(
      2,
      "Podcast A",
      Podcast,
      "Tecnologia",
      30,
      None,
      NaoIniciado,
    )),
  )

  check.eq(
    criar_conteudo(
      0,
      "Serie A",
      Serie,
      "Drama",
      45,
      Some(4.0),
      NaoIniciado,
    ),
    Error(Nil),
  )

  check.eq(
    criar_conteudo(
      3,
      "Serie A",
      Serie,
      "Drama",
      0,
      Some(4.0),
      NaoIniciado,
    ),
    Error(Nil),
  )

  check.eq(
    criar_conteudo(
      4,
      "Doc A",
      Documentario,
      "Historia",
      60,
      Some(-0.1),
      NaoIniciado,
    ),
    Error(Nil),
  )

  check.eq(
    criar_conteudo(
      5,
      "Doc B",
      Documentario,
      "Historia",
      60,
      Some(5.1),
      NaoIniciado,
    ),
    Error(Nil),
  )

  check.eq(
    criar_conteudo(
      6,
      "Doc C",
      Documentario,
      "Historia",
      60,
      Some(0.0),
      EmAndamento(10),
    ),
    Ok(tipos.Conteudo(
      6,
      "Doc C",
      Documentario,
      "Historia",
      60,
      Some(0.0),
      EmAndamento(10),
    )),
  )

  check.eq(
    criar_conteudo(
      7,
      "Doc D",
      Documentario,
      "Historia",
      60,
      Some(5.0),
      Concluido,
    ),
    Ok(tipos.Conteudo(
      7,
      "Doc D",
      Documentario,
      "Historia",
      60,
      Some(5.0),
      Concluido,
    )),
  )
}

pub fn classificar_duracao_examples() {
  let curto =
    tipos.Conteudo(
      1,
      "Curto",
      Podcast,
      "Educacao",
      30,
      None,
      NaoIniciado,
    )

  let medio_inicial =
    tipos.Conteudo(
      2,
      "Medio 31",
      Serie,
      "Drama",
      31,
      Some(3.0),
      EmAndamento(5),
    )

  let medio_final =
    tipos.Conteudo(
      3,
      "Medio 90",
      Documentario,
      "Historia",
      90,
      Some(4.0),
      Concluido,
    )

  let longo =
    tipos.Conteudo(
      4,
      "Longo",
      Filme,
      "Ficcao",
      91,
      Some(5.0),
      Concluido,
    )

  check.eq(classificar_duracao(curto), Curto)
  check.eq(classificar_duracao(medio_inicial), Medio)
  check.eq(classificar_duracao(medio_final), Medio)
  check.eq(classificar_duracao(longo), Longo)
}