import src/tipos

/// Devolve a quantidade total de conteudos armazenados em *catalogo*.
///
/// A contagem considera os conteudos do no atual e de todas as suas
/// subcategorias.
pub fn total_conteudos_catalogo(catalogo: tipos.Catalogo) -> Int {
  case catalogo {
    tipos.Vazio -> 0
    tipos.NoCatalogo(_, subcategorias, conteudos) ->
      contar_conteudos(conteudos)
      + total_conteudos_subcategorias(subcategorias)
  }
}

/// Conta os conteudos armazenados diretamente em um no do catalogo.
fn contar_conteudos(conteudos: List(tipos.Conteudo)) -> Int {
  case conteudos {
    [] -> 0
    [_, ..resto] -> 1 + contar_conteudos(resto)
  }
}

/// Soma os conteudos das subcategorias de um no.
fn total_conteudos_subcategorias(
  subcategorias: List(tipos.Catalogo),
) -> Int {
  case subcategorias {
    [] -> 0
    [primeira, ..resto] ->
      total_conteudos_catalogo(primeira)
      + total_conteudos_subcategorias(resto)
  }
}

/// Lista os titulos associados diretamente a categorias chamadas *nome_cat*.
///
/// A busca percorre toda a hierarquia. Se houver mais de uma categoria com
/// o mesmo nome, os titulos de todas elas sao reunidos em ordem de percurso.
/// Quando a categoria nao existe, o resultado e uma lista vazia.
pub fn listar_titulos_categoria(
  catalogo: tipos.Catalogo,
  nome_cat: String,
) -> List(String) {
  case catalogo {
    tipos.Vazio -> []

    tipos.NoCatalogo(nome, subcategorias, conteudos) -> {
      let titulos_atuais = case nome == nome_cat {
        True -> listar_titulos_conteudos(conteudos)
        False -> []
      }

      juntar_listas(
        titulos_atuais,
        listar_titulos_subcategorias(subcategorias, nome_cat),
      )
    }
  }
}

/// Extrai os titulos de uma lista de conteudos.
fn listar_titulos_conteudos(
  conteudos: List(tipos.Conteudo),
) -> List(String) {
  case conteudos {
    [] -> []

    [primeiro, ..resto] ->
      case primeiro {
        tipos.Conteudo(_, titulo, _, _, _, _, _) -> [
          titulo,
          ..listar_titulos_conteudos(resto)
        ]
      }
  }
}

/// Busca titulos em cada uma das subcategorias.
fn listar_titulos_subcategorias(
  subcategorias: List(tipos.Catalogo),
  nome_cat: String,
) -> List(String) {
  case subcategorias {
    [] -> []

    [primeira, ..resto] ->
      juntar_listas(
        listar_titulos_categoria(primeira, nome_cat),
        listar_titulos_subcategorias(resto, nome_cat),
      )
  }
}

/// Concatena duas listas preservando a ordem dos elementos.
fn juntar_listas(
  primeira: List(a),
  segunda: List(a),
) -> List(a) {
  case primeira {
    [] -> segunda
    [elemento, ..resto] ->
      [elemento, ..juntar_listas(resto, segunda)]
  }
}