import gleam/option.{type Option}

/// Representa os tipos de mídia disponíveis na plataforma.
pub type TipoMidia {
  Filme
  Serie
  Documentario
  Podcast
}

/// Representa o estado de consumo de um conteúdo.
///
/// Um conteúdo em andamento armazena a quantidade
/// de minutos já consumidos.
pub type EstadoConsumo {
  NaoIniciado
  EmAndamento(progresso_minutos: Int)
  Concluido
}

/// Representa a classificação de um conteúdo
/// de acordo com sua duração.
pub type CategoriaDuracao {
  Curto
  Medio
  Longo
}

/// Representa um conteúdo disponível na plataforma.
///
/// A avaliação é opcional porque um conteúdo pode
/// ainda não ter recebido uma nota.
pub type Conteudo {
  Conteudo(
    id: Int,
    titulo: String,
    tipo: TipoMidia,
    categoria: String,
    duracao_minutos: Int,
    avaliacao: Option(Float),
    estado: EstadoConsumo,
  )
}

/// Representa a organização hierárquica do catálogo.
///
/// Cada nó representa uma categoria e pode possuir:
/// - outras categorias;
/// - conteúdos associados diretamente a ele.
///
/// Vazio representa a ausência de uma categoria.
pub type Catalogo {
  Vazio
  NoCatalogo(
    nome: String,
    subcategorias: List(Catalogo),
    conteudos: List(Conteudo),
  )
}