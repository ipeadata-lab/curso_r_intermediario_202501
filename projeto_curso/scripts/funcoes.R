voos <- readr::read_csv2("dados/voos_dez-2024-alterado.csv")


# estrutura básica de uma função

# nome_funcao <- function(argumentos){
#   # o que a função vai executar
#   # quando chamar ela:
#   
#   # nome_funcao()
# }

Sys.Date()
Sys.Date
# function () 
# as.Date(as.POSIXlt(Sys.time()))
# <bytecode: 0x13b4b02b0>
# <environment: namespace:base>

knitr::combine_words(
  unique(voos$sg_uf_origem), 
  and =  " e ",
  oxford_comma = FALSE
)

combinar_palavras <- function(vetor_palavras){
  
  palavras_unicas <- unique(vetor_palavras)
  
  
  palavras_combinadas <- knitr::combine_words(
    palavras_unicas,
    and =  " e ",
    oxford_comma = FALSE)
  
  return(palavras_combinadas)

}

# Experimentando
combinar_palavras(c("R", "Python", "SQL"))

combinar_palavras(c("R", "Python", "SQL", "R"))

combinar_palavras(voos$sg_uf_origem)

combinar_palavras(voos$sg_uf_destino)

combinar_palavras()
# argument "vetor_palavras" is missing, with no default

mean()
# argument "x" is missing, with no default

# x, df, 
# Exercícios --------
# 1) 

converter_dolar_para_real <- function(valor_em_dolar){
  cotacao_dolar <- 5.77
  
  valor_em_real <- valor_em_dolar * cotacao_dolar
  
  valor_em_real
}

converter_dolar_para_real(1800)
converter_dolar_para_real(200)
converter_dolar_para_real("R$ 1800")
# Error in valor_em_dolar * cotacao_dolar : 
#   non-numeric argument to binary operator

# TO DO: Verificação dos argumentos

# 2)

remover_acentos <- function(vetor_texto){
  stringi::stri_trans_general(vetor_texto, "Latin-ASCII")
}


voos$nm_municipio_origem
remover_acentos(voos$nm_municipio_origem)

abjutils::rm_accent()
abjutils::rm_accent

voos_2 <- voos |> 
  dplyr::mutate(
    nm_municipio_origem_sem_acentos = remover_acentos(nm_municipio_origem)
  )


# 3 ---

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

combinar_palavras_sem_na(voos$sg_uf_origem)

combinar_palavras_sem_na(voos$sg_uf_destino)

combinar_palavras(voos$sg_uf_origem)

combinar_palavras(voos$sg_uf_destino)


# https://ipeadata-lab.github.io/curso_r_intermediario_202501/programacao-funcional.html#exerc%C3%ADcios-1
# Exercícios
# 1)

converter_dolar_para_real <- function(valor_em_dolar, cotacao_dolar = 5.77){
  # cotacao_dolar <- 5.77
  
  valor_em_real <- valor_em_dolar * cotacao_dolar
  
  valor_em_real
}

converter_dolar_para_real(1800, cotacao_dolar = 2)


converter_dolar_para_real(1800)
converter_dolar_para_real(1800, cotacao_dolar = 6.19)


converter_dolar_para_real(1800, cotacao_dolar = 6.19)


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

# verificação de argumentos ----------
 


combinar_palavras_com_verificacao <- function(vetor_de_palavras) {
  
  stopifnot(is.vector(vetor_de_palavras))
  palavras_unicas <- unique(vetor_de_palavras)
  
  palavras_combinadas <- knitr::combine_words(
    palavras_unicas,
    and = " e ",
    oxford_comma = FALSE)
  
  palavras_combinadas
}


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

# Experimentar a função
converter_dolar_para_real(100)
converter_dolar_para_real("abc")
converter_dolar_para_real(voos)
converter_dolar_para_real('100')
converter_dolar_para_real(dados_inexistentes)

voos

mtcars
pi

search()


# <-

# <<- não usem

# não é legal fazer assim!
contagem_coluna <- function(coluna){
  voos |> 
    dplyr::count(.data[[coluna]], sort = TRUE)
}
# Experimentando a função: UF de origem
contagem_coluna("sg_uf_origem")


# 
contagem_coluna_2 <- function(df, coluna){
  df |> 
    dplyr::count(.data[[coluna]], sort = TRUE)
}

# .data[[coluna]]
# voos[["sg_uf_origem"]]


# Experimentando a função: UF de origem
contagem_coluna_2(voos, "sg_uf_origem")

contagem_coluna_2(voos, "sg_uf_destino")


contagem_coluna_2(voos, "nm_empresa")

contagem_coluna_2(palmerpenguins::penguins, "species")


# Iteração --------------

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


salvar_csv_por_empresa(nome_empresa = "TAM LINHAS AÉREAS S.A.",
                       dados = voos)

unique(voos$nm_empresa)

# iteração --------------

nome_empresas <- voos |> 
  dplyr::count(nm_empresa, sort = TRUE) |> 
  head(10) |> 
  dplyr::pull(nm_empresa)


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


# purrr --------------------------------
dplyr::select()


nome_empresas <- voos |> 
  dplyr::count(nm_empresa, sort = TRUE) |> 
  head(10) |> 
  dplyr::pull(nm_empresa)



lista_caminhos <- purrr::map(nome_empresas, salvar_csv_por_empresa, dados = voos)

lista_caminhos


# Exercicio

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


graficos[[1]]

# função anonima -----------------
purrr::map(
  nome_colunas_numericas,
  ~criar_histograma(dados = palmerpenguins::penguins,
                    variavel = .x))


# furrr

library(furrr)
parallel::detectCores() # detectar quantos cores temos
future::plan(multisession, workers = 6)


nome_empresas <- voos |> 
  dplyr::count(nm_empresa, sort = TRUE) |> 
  dplyr::pull(nm_empresa)


library(tictoc)
tic()
lista_caminhos <- furrr::future_map(nome_empresas, salvar_csv_por_empresa, dados = voos)
toc()
# 8.819 sec elapsed


tic()
lista_caminhos <- purrr::map(nome_empresas, salvar_csv_por_empresa, dados = voos)
toc()
# 8.781 sec elapsed



set.seed(5678)


