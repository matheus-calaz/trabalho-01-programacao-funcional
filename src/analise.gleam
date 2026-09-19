import gleam/float
import gleam/int
import gleam/option.{None, Some}
import src/listas
import src/tipos

/// Calcula a media das avaliacoes dos conteudos concluidos da categoria.
///
/// Conteudos de outras categorias, nao concluidos ou sem avaliacao nao
/// participam do calculo. Devolve Error(Nil) quando nao existe nenhuma
/// avaliacao que atenda aos criterios.
pub fn media_avaliacao_categoria_concluidos(
  lista: List(tipos.Conteudo),
  categoria: String,
) -> Result(Float, Nil) {
  let concluidos =
    filtrar_concluidos_categoria(lista, categoria)

  let quantidade =
    contar_avaliacoes(concluidos)

  case quantidade {
    0 -> Error(Nil)

    _ ->
      Ok(
        somar_avaliacoes(concluidos)
        /. int.to_float(quantidade),
      )
  }
}

/// Seleciona os conteudos concluidos que pertencem a *categoria*.
fn filtrar_concluidos_categoria(
  lista: List(tipos.Conteudo),
  categoria: String,
) -> List(tipos.Conteudo) {
  case lista {
    [] -> []

    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(
          _,
          _,
          _,
          categoria_atual,
          _,
          _,
          estado,
        ) ->
          case categoria_atual == categoria, estado {
            True, tipos.Concluido -> [
              primeiro,
              ..filtrar_concluidos_categoria(
                resto,
                categoria,
              )
            ]

            _, _ ->
              filtrar_concluidos_categoria(
                resto,
                categoria,
              )
          }
      }
  }
}

/// Soma as avaliacoes presentes na lista e ignora valores None.
fn somar_avaliacoes(
  lista: List(tipos.Conteudo),
) -> Float {
  case lista {
    [] -> 0.0

    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(_, _, _, _, _, avaliacao, _) ->
          case avaliacao {
            None ->
              somar_avaliacoes(resto)

            Some(nota) ->
              nota +. somar_avaliacoes(resto)
          }
      }
  }
}

/// Conta quantas avaliacoes estao presentes na lista.
fn contar_avaliacoes(
  lista: List(tipos.Conteudo),
) -> Int {
  case lista {
    [] -> 0

    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(_, _, _, _, _, avaliacao, _) ->
          case avaliacao {
            None ->
              contar_avaliacoes(resto)

            Some(_) ->
              1 + contar_avaliacoes(resto)
          }
      }
  }
}

/// Conta a quantidade de conteudos da lista.
fn contar_conteudos(
  lista: List(tipos.Conteudo),
) -> Int {
  case lista {
    [] -> 0
    [_, ..resto] -> 1 + contar_conteudos(resto)
  }
}

/// Calcula a media de todas as avaliacoes presentes na lista.
fn media_avaliacoes(
  lista: List(tipos.Conteudo),
) -> Result(Float, Nil) {
  let quantidade =
    contar_avaliacoes(lista)

  case quantidade {
    0 -> Error(Nil)

    _ ->
      Ok(
        somar_avaliacoes(lista)
        /. int.to_float(quantidade),
      )
  }
}

/// Gera um relatorio com total de itens, tempo consumido e media de notas.
pub fn gerar_relatorio(
  lista: List(tipos.Conteudo),
) -> String {
  let total =
    contar_conteudos(lista)

  let tempo =
    listas.tempo_total_consumido(lista)

  let media_texto =
    case media_avaliacoes(lista) {
      Ok(media) ->
        float.to_string(media)

      Error(Nil) ->
        "sem avaliacoes"
    }

  "Total de itens: "
  <> int.to_string(total)
  <> " | Tempo consumido: "
  <> int.to_string(tempo)
  <> " minutos | Media de avaliacoes: "
  <> media_texto
}