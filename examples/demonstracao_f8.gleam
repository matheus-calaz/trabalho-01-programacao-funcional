import gleam/io
import gleam/option.{Some}
import src/analise
import src/tipos.{Concluido, Filme}

pub fn main() {
  let drama_1 =
    tipos.Conteudo(
      1,
      "O Poderoso Chefão",
      Filme,
      "Drama",
      175,
      Some(4.0),
      Concluido,
    )

  let drama_2 =
    tipos.Conteudo(
      2,
      "À Espera de um Milagre",
      Filme,
      "Drama",
      189,
      Some(5.0),
      Concluido,
    )

  let conteudos = [drama_1, drama_2]

  io.debug("Primeiro conteúdo")
  io.debug(drama_1)

  io.debug("Segundo conteúdo")
  io.debug(drama_2)

  let resultado =
    analise.media_avaliacao_categoria_concluidos(
      conteudos,
      "Drama",
    )

  io.debug("Resultado da F8")
  io.debug(resultado)
}

// .\sgleam.exe examples/demonstracao_f8.gleam