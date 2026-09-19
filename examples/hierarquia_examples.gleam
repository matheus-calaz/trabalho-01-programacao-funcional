import gleam/option.{None, Some}
import sgleam/check
import src/hierarquia.{
  listar_titulos_categoria,
  total_conteudos_catalogo,
}
import src/tipos.{
  Concluido, Documentario, Filme, NaoIniciado, Podcast, Serie,
}

fn catalogo_exemplo() -> tipos.Catalogo {
  let destaque =
    tipos.Conteudo(
      1,
      "Destaque da Semana",
      Filme,
      "Destaques",
      110,
      Some(4.8),
      Concluido,
    )

  let filme_acao =
    tipos.Conteudo(
      2,
      "Missao Funcional",
      Filme,
      "Filmes",
      120,
      Some(4.5),
      Concluido,
    )

  let documentario =
    tipos.Conteudo(
      3,
      "Historia da Computacao",
      Documentario,
      "Filmes",
      90,
      Some(5.0),
      Concluido,
    )

  let filme_drama =
    tipos.Conteudo(
      4,
      "Codigo e Emocao",
      Filme,
      "Drama",
      100,
      None,
      NaoIniciado,
    )

  let serie =
    tipos.Conteudo(
      5,
      "Recursao Infinita",
      Serie,
      "Series",
      45,
      Some(4.7),
      NaoIniciado,
    )

  tipos.NoCatalogo(
    "Catalogo Principal",
    [
      tipos.NoCatalogo(
        "Filmes",
        [
          tipos.NoCatalogo(
            "Drama",
            [],
            [filme_drama],
          ),
        ],
        [filme_acao, documentario],
      ),
      tipos.NoCatalogo(
        "Series",
        [],
        [serie],
      ),
      tipos.Vazio,
    ],
    [destaque],
  )
}

pub fn total_conteudos_catalogo_examples() {
  check.eq(
    total_conteudos_catalogo(tipos.Vazio),
    0,
  )

  check.eq(
    total_conteudos_catalogo(
      tipos.NoCatalogo("Vazio", [], []),
    ),
    0,
  )

  check.eq(
    total_conteudos_catalogo(catalogo_exemplo()),
    5,
  )
}

pub fn listar_titulos_categoria_examples() {
  let catalogo = catalogo_exemplo()

  check.eq(
    listar_titulos_categoria(tipos.Vazio, "Filmes"),
    [],
  )

  check.eq(
    listar_titulos_categoria(
      catalogo,
      "Catalogo Principal",
    ),
    ["Destaque da Semana"],
  )

  check.eq(
    listar_titulos_categoria(catalogo, "Filmes"),
    [
      "Missao Funcional",
      "Historia da Computacao",
    ],
  )

  check.eq(
    listar_titulos_categoria(catalogo, "Drama"),
    ["Codigo e Emocao"],
  )

  check.eq(
    listar_titulos_categoria(
      catalogo,
      "Categoria Inexistente",
    ),
    [],
  )
}

pub fn categorias_repetidas_examples() {
  let primeiro =
    tipos.Conteudo(
      10,
      "Podcast Um",
      Podcast,
      "Tecnologia",
      30,
      Some(4.0),
      Concluido,
    )

  let segundo =
    tipos.Conteudo(
      11,
      "Podcast Dois",
      Podcast,
      "Tecnologia",
      40,
      Some(4.5),
      Concluido,
    )

  let catalogo =
    tipos.NoCatalogo(
      "Raiz",
      [
        tipos.NoCatalogo(
          "Tecnologia",
          [],
          [primeiro],
        ),
        tipos.NoCatalogo(
          "Tecnologia",
          [],
          [segundo],
        ),
      ],
      [],
    )

  check.eq(
    listar_titulos_categoria(
      catalogo,
      "Tecnologia",
    ),
    [
      "Podcast Um",
      "Podcast Dois",
    ],
  )
}