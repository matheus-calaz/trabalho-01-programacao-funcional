import gleam/int
import gleam/option.{None, Some}
import src/tipos

/// Devolve o total de minutos consumidos nos conteudos de *lista*.
///
/// Conteudos nao iniciados contribuem com zero, conteudos em andamento
/// contribuem com o progresso registrado e conteudos concluidos contribuem
/// com sua duracao completa.
pub fn tempo_total_consumido(lista: List(tipos.Conteudo)) -> Int {
  case lista {
    [] -> 0
    [primeiro, ..resto] ->
      tempo_consumido_conteudo(primeiro) + tempo_total_consumido(resto)
  }
}

/// Devolve o tempo consumido de um unico conteudo.
fn tempo_consumido_conteudo(conteudo: tipos.Conteudo) -> Int {
  case conteudo {
    tipos.Conteudo(_, _, _, _, duracao_minutos, _, estado) ->
      case estado {
        tipos.NaoIniciado -> 0
        tipos.EmAndamento(progresso_minutos) -> progresso_minutos
        tipos.Concluido -> duracao_minutos
      }
  }
}

/// Cria uma lista com os conteudos que possuem o estado informado.
///
/// Para EmAndamento, o valor do progresso nao interfere na comparacao:
/// todos os conteudos em andamento pertencem ao mesmo estado.
pub fn filtrar_por_estado(
  lista: List(tipos.Conteudo),
  estado: tipos.EstadoConsumo,
) -> List(tipos.Conteudo) {
  case lista {
    [] -> []
    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(_, _, _, _, _, _, estado_atual) ->
          case mesmo_estado(estado_atual, estado) {
            True -> [primeiro, ..filtrar_por_estado(resto, estado)]
            False -> filtrar_por_estado(resto, estado)
          }
      }
  }
}

/// Verifica se dois valores representam o mesmo estado de consumo.
fn mesmo_estado(
  primeiro: tipos.EstadoConsumo,
  segundo: tipos.EstadoConsumo,
) -> Bool {
  case primeiro, segundo {
    tipos.NaoIniciado, tipos.NaoIniciado -> True
    tipos.EmAndamento(_), tipos.EmAndamento(_) -> True
    tipos.Concluido, tipos.Concluido -> True
    _, _ -> False
  }
}

/// Converte recursivamente a duracao dos conteudos de minutos para horas.
pub fn converter_duracao_para_horas(
  lista: List(tipos.Conteudo),
) -> List(Float) {
  case lista {
    [] -> []
    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(_, _, _, _, duracao_minutos, _, _) -> [
          int.to_float(duracao_minutos) /. 60.0,
          ..converter_duracao_para_horas(resto)
        ]
      }
  }
}

/// Busca recursivamente um conteudo pelo identificador.
///
/// Devolve Ok(Conteudo) quando encontra o identificador e Error(Nil)
/// quando ele nao esta presente na lista.
pub fn buscar_por_id(
  lista: List(tipos.Conteudo),
  id_busca: Int,
) -> Result(tipos.Conteudo, Nil) {
  case lista {
    [] -> Error(Nil)
    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(id, _, _, _, _, _, _) ->
          case id == id_busca {
            True -> Ok(primeiro)
            False -> buscar_por_id(resto, id_busca)
          }
      }
  }
}

/// Devolve o conteudo com a maior avaliacao da lista.
///
/// Conteudos sem avaliacao sao ignorados. Se nenhum conteudo possuir
/// avaliacao, devolve Error(Nil). Em caso de empate, permanece o primeiro.
pub fn conteudo_melhor_avaliado(
  lista: List(tipos.Conteudo),
) -> Result(tipos.Conteudo, Nil) {
  case lista {
    [] -> Error(Nil)
    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(_, _, _, _, _, avaliacao, _) ->
          case avaliacao {
            None -> conteudo_melhor_avaliado(resto)
            Some(nota) -> Ok(melhor_avaliado(resto, primeiro, nota))
          }
      }
  }
}

/// Percorre o restante da lista mantendo o melhor conteudo encontrado.
fn melhor_avaliado(
  lista: List(tipos.Conteudo),
  melhor: tipos.Conteudo,
  maior_nota: Float,
) -> tipos.Conteudo {
  case lista {
    [] -> melhor
    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(_, _, _, _, _, avaliacao, _) ->
          case avaliacao {
            None -> melhor_avaliado(resto, melhor, maior_nota)
            Some(nota) ->
              case nota >. maior_nota {
                True -> melhor_avaliado(resto, primeiro, nota)
                False -> melhor_avaliado(resto, melhor, maior_nota)
              }
          }
      }
  }
}