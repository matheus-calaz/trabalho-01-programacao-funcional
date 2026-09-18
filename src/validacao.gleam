import gleam/option.{type Option, None, Some}
import src/tipos

/// Cria um conteudo quando os dados recebidos sao validos.
///
/// Para ser valido, o conteudo deve possuir identificador positivo,
/// duracao positiva e, quando informada, avaliacao entre 0.0 e 5.0.
pub fn criar_conteudo(
  id: Int,
  titulo: String,
  tipo: tipos.TipoMidia,
  categoria: String,
  duracao_minutos: Int,
  avaliacao: Option(Float),
  estado: tipos.EstadoConsumo,
) -> Result(tipos.Conteudo, Nil) {
  case id > 0 && duracao_minutos > 0 && avaliacao_valida(avaliacao) {
    True ->
      Ok(tipos.Conteudo(
        id,
        titulo,
        tipo,
        categoria,
        duracao_minutos,
        avaliacao,
        estado,
      ))
    False -> Error(Nil)
  }
}

/// Verifica se uma avaliacao opcional pertence ao intervalo permitido.
fn avaliacao_valida(avaliacao: Option(Float)) -> Bool {
  case avaliacao {
    None -> True
    Some(nota) -> nota >=. 0.0 && nota <=. 5.0
  }
}

/// Classifica um conteudo como Curto, Medio ou Longo.
pub fn classificar_duracao(
  conteudo: tipos.Conteudo,
) -> tipos.CategoriaDuracao {
  case conteudo {
    tipos.Conteudo(_, _, _, _, duracao_minutos, _, _) ->
      case duracao_minutos <= 30 {
        True -> tipos.Curto
        False ->
          case duracao_minutos <= 90 {
            True -> tipos.Medio
            False -> tipos.Longo
          }
      }
  }
}