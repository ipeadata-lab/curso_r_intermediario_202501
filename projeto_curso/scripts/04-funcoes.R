# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/programacao-funcional.html

# Carregar os dados de voos
voos <- readr::read_csv2("dados/voos_dez-2024-alterado.csv")

# Estrutura básica de uma função
# nome_funcao <- function(argumentos){
#   # o que a função vai executar
#   # quando chamar ela:
#   # nome_funcao()
# }

# Exemplo de função existente
Sys.Date()
Sys.Date
# function ()
# as.Date(as.POSIXlt(Sys.time()))
# <bytecode: 0x13b4b02b0>
# <environment: namespace:base>

# Exemplo de uso da função combine_words do pacote knitr
knitr::combine_words(
  unique(voos$sg_uf_origem),
  and =  " e ",
  oxford_comma = FALSE
)

# Criar uma função para combinar palavras
combinar_palavras <- function(vetor_palavras){
  palavras_unicas <- unique(vetor_palavras)
  palavras_combinadas <- knitr::combine_words(
    palavras_unicas,
    and =  " e ",
    oxford_comma = FALSE)
  return(palavras_combinadas)
}

# Experimentando a função combinar_palavras
combinar_palavras(c("R", "Python", "SQL"))
combinar_palavras(c("R", "Python", "SQL", "R"))
combinar_palavras(voos$sg_uf_origem)
combinar_palavras(voos$sg_uf_destino)

# Testando a função sem argumentos
combinar_palavras()
# Error: argument "vetor_palavras" is missing, with no default

mean()
# Error: argument "x" is missing, with no default

# x, df: nomes comuns para argumentos
# x: vetor de valores
# df: dataframe


# Exercícios --------
# 1) Converter dólar para real
converter_dolar_para_real <- function(valor_em_dolar){
  cotacao_dolar <- 5.77
  valor_em_real <- valor_em_dolar * cotacao_dolar
  valor_em_real
}

# Experimentando a função converter_dolar_para_real
converter_dolar_para_real(1800)
converter_dolar_para_real(200)
converter_dolar_para_real("R$ 1800")
# Error in valor_em_dolar * cotacao_dolar :
#   non-numeric argument to binary operator

# TO DO: Verificação dos argumentos
# Fizemos isso em conteúdos posteriores

# 2) Remover acentos

remover_acentos <- function(vetor_texto){
  stringi::stri_trans_general(vetor_texto, "Latin-ASCII")
}

# Experimentando a função remover_acentos
voos$nm_municipio_origem
remover_acentos(voos$nm_municipio_origem)


abjutils::rm_accent

# Adicionar coluna sem acentos ao dataframe voos
voos_2 <- voos |>
  dplyr::mutate(
    nm_municipio_origem_sem_acentos = remover_acentos(nm_municipio_origem)
  )

# 3) Combinar palavras sem NA
combinar_palavras_sem_na <- function(vetor_palavras){
  palavras_unicas <- unique(vetor_palavras)
  palavras_sem_na <- na.omit(palavras_unicas)
  palavras_ordenadas <- sort(palavras_sem_na)
  palavras_combinadas <- knitr::combine_words(
    palavras_ordenadas,
    and =  " e ",
    oxford_comma = FALSE)
  return(palavras_combinadas)
}

# Experimentando a função combinar_palavras_sem_na
combinar_palavras_sem_na(voos$sg_uf_origem)
combinar_palavras_sem_na(voos$sg_uf_destino)

# Exercícios
# 1) Modificar a função converter_dolar_para_real para aceitar cotação como argumento
converter_dolar_para_real <- function(valor_em_dolar, cotacao_dolar = 5.77){
  # cotacao_dolar <- 5.77

  valor_em_real <- valor_em_dolar * cotacao_dolar
  valor_em_real
}

# Experimentando a função com cotação diferente
converter_dolar_para_real(1800, cotacao_dolar = 2)


converter_dolar_para_real(1800)
converter_dolar_para_real(1800, cotacao_dolar = 6.19)
converter_dolar_para_real(1800, cotacao_dolar = 6.19)

# Dúvida: substituir um padrão no texto por outro.
stringr::str_replace_all(voos$nm_municipio_origem,
                         pattern =  "SÃO",
                         replacement =  "SANTO")



# 3)
preparar_coluna <- function(vetor_palavras) {

  vetor_palavras_preparado <- stringi::stri_trans_general(vetor_palavras, "Latin-ASCII") |>
    stringr::str_to_lower()

  return(vetor_palavras_preparado)

}

# b)
preparar_coluna(voos$nm_municipio_origem)

# c)
voos_prep <- voos |>
  dplyr::mutate(nm_municipio_origem_preparado = preparar_coluna(nm_municipio_origem))

# Verificação de argumentos ----------



combinar_palavras_com_verificacao <- function(vetor_de_palavras) {
  stopifnot(is.vector(vetor_de_palavras))
  palavras_unicas <- unique(vetor_de_palavras)
  palavras_combinadas <- knitr::combine_words(
    palavras_unicas,
    and = " e ",
    oxford_comma = FALSE)
  palavras_combinadas
}

# Experimentando a função com verificação de argumentos
combinar_palavras_com_verificacao(voos)


stopifnot(is.vector(mtcars))
assertthat::assert_that(is.vector(mtcars))


# Exercícios ----

# Modifique a função converter_dolar_para_real() para que ela verifique se os argumentos fornecidos são válidos.
# A função deve aceitar apenas valores numéricos.


converter_dolar_para_real <- function(valor_em_dolar, cotacao_dolar = 5.77){
  # cotacao_dolar <- 5.77

  stopifnot(is.numeric(valor_em_dolar))
  stopifnot(is.numeric(cotacao_dolar))


  # Dúvida Luiz
  # if(!is.numeric(valor_em_dolar) | !is.vector(valor_em_dolar)){
  #   stop("O valor_em_dolar deve ser numérico")
  # }


  valor_em_real <- valor_em_dolar * cotacao_dolar
  valor_em_real
}

# Experimentando a função com verificação de argumentos
converter_dolar_para_real(100)
converter_dolar_para_real("abc")
converter_dolar_para_real(voos)
converter_dolar_para_real('100')
converter_dolar_para_real(dados_inexistentes)


# Sobre environments e funções
# voos é encontrado no ambiente global pois foi carregado por nós
voos

# Mas e esses objetos?
# mtcars e pi são objetos que estão disponíveis no R Base, por isso não precisamos carregar
# eles não estão no ambiente global, mas são encontrados em outro ambiente
mtcars
pi

# função que retorna os ambientes disponíveis
search()

# Usamos o operador <- para atribuição.
# <-
# Existe outro operador de atribuição: <<-
# Ele atribui o valor a um objeto em um ambiente acima do atual
# PERIGOSO, NÃO USE!!!!
# Se usado dentro de uma função, ele atribui o valor no ambiente global,
# e isso pode causar efeitos colaterais indesejados
# <<- não usem

# não é legal fazer assim!
# no exemplo abaixo, o objeto `voos` é usado mas não é passado para a função como argumento
# se `voos` não existir no ambiente global, a função não vai funcionar
contagem_coluna <- function(coluna){
  voos |>
    dplyr::count(.data[[coluna]], sort = TRUE)
}

# Experimentando a função: UF de origem
contagem_coluna("sg_uf_origem")


# Neste outro exemplo, adicionamos o argumento `df` à função
# Agora, a função é mais flexível e pode ser usada com qualquer dataframe
contagem_coluna_2 <- function(df, coluna){
  df |>
    dplyr::count(.data[[coluna]], sort = TRUE)
}

# Esse operador .data[[coluna]] parece confuso, mas é uma forma de acessar
#  a coluna de um dataframe quando estamos criando uma função que usa pipe


# .data[[coluna]]
# voos[["sg_uf_origem"]]


# Experimentando a função: UF de origem
contagem_coluna_2(voos, "sg_uf_origem")
contagem_coluna_2(voos, "sg_uf_destino")
contagem_coluna_2(voos, "nm_empresa")
contagem_coluna_2(palmerpenguins::penguins, "species")

# Iteração --------------
# Função para salvar dados de voos por empresa em arquivos CSV
salvar_csv_por_empresa <- function(nome_empresa,
                                   dados,
                                   dir_salvar = "dados/voos_empresas/") {
  # Verificar se os argumentos são válidos
  stopifnot(is.data.frame(dados))
  stopifnot(is.character(nome_empresa))
  stopifnot(length(nome_empresa) == 1)
  stopifnot(is.character(dir_salvar))

  # Limpar o nome da empresa
  nome_empresa_limpo <- janitor::make_clean_names(nome_empresa)

  # Criando o diretório para salvar os arquivos
  fs::dir_create(dir_salvar)

  # Compor o caminho do arquivo a ser salvo
  caminho_arquivo_salvar <- paste0(dir_salvar, nome_empresa_limpo, ".csv")

  # Filtrar os dados para a empresa desejada
  dados_filtrados <- dados |>
    dplyr::filter(nm_empresa == nome_empresa)

  # Salvar os dados em um arquivo CSV
  readr::write_csv2(dados_filtrados, file = caminho_arquivo_salvar)

  # Apresentar uma mensagem ao usuário
  usethis::ui_done("Arquivo salvo: {caminho_arquivo_salvar}")

  # Retornar o caminho do arquivo salvo
  caminho_arquivo_salvar
}

# Experimentando a função salvar_csv_por_empresa
salvar_csv_por_empresa(nome_empresa = "TAM LINHAS AÉREAS S.A.",
                       dados = voos)

# Obter os nomes das empresas
unique(voos$nm_empresa)

# Iteração --------------
# Obter os nomes das 10 maiores empresas
nome_empresas <- voos |>
  dplyr::count(nm_empresa, sort = TRUE) |>
  head(10) |>
  dplyr::pull(nm_empresa)

# Estrutura de um loop for
# for (variable in vector) {
#
# }

for (empresa in nome_empresas) {
  salvar_csv_por_empresa(nome_empresa = empresa,
                         dados = voos)
}


# exercicio

for (x in 1:5) {
  Sys.sleep(1)
  print(x)
}

for (x in 1:5) {
  Sys.sleep(x)
  print(x)
}

# Usando o pacote purrr para iterar --------------
library(purrr)

nome_empresas <- voos |>
  dplyr::count(nm_empresa, sort = TRUE) |>
  head(10) |>
  dplyr::pull(nm_empresa)

# Usar a função map para salvar os dados de cada empresa
lista_caminhos <- purrr::map(nome_empresas, salvar_csv_por_empresa, dados = voos)

# Exibir a lista de caminhos dos arquivos salvos
lista_caminhos


# Exercicio

# Exemplo de função para criar histogramas
criar_histograma <- function(dados, variavel){
  stopifnot(is.data.frame(dados))
  stopifnot(is.character(variavel))
  dados |>
  ggplot2::ggplot() +
    ggplot2::aes(x = .data[[variavel]]) +
    ggplot2::geom_histogram() +
    ggplot2::theme_light() +
    ggplot2::labs(title = paste("Histograma de", variavel))
}


# 1) Obter as variáveis numéricas do data frame

palmerpenguins::penguins


# nome_colunas_numericas <- c(....)

palmerpenguins::penguins |>
  dplyr::select(dplyr::where(is.factor))


nome_colunas_numericas <- palmerpenguins::penguins |>
  dplyr::select(dplyr::where(is.numeric)) |>
  names()


# 2) Iterar com a função map()


graficos <- purrr::map(nome_colunas_numericas,
           criar_histograma,
           dados = palmerpenguins::penguins)

# Exibir o primeiro histograma
graficos[[1]]

# Usar uma função anônima com map
purrr::map(
  nome_colunas_numericas,
  ~criar_histograma(dados = palmerpenguins::penguins,
                    variavel = .x))

# Usando o pacote furrr para paralelizar --------------
library(furrr)
parallel::detectCores() # detectar quantos cores temos
future::plan(multisession, workers = 6)

# Obter os nomes das empresas
nome_empresas <- voos |>
  dplyr::count(nm_empresa, sort = TRUE) |>
  dplyr::pull(nm_empresa)

# Medir o tempo de execução com tictoc
library(tictoc)
tic()
lista_caminhos <- furrr::future_map(nome_empresas, salvar_csv_por_empresa, dados = voos)
toc()
# 8.819 sec elapsed

# Comparar com a execução sem paralelização
tic()
lista_caminhos <- purrr::map(nome_empresas, salvar_csv_por_empresa, dados = voos)
toc()
# 8.781 sec elapsed

# Definir uma semente para reprodutibilidade
set.seed(5678)


