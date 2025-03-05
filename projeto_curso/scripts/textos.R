# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/texto-data.html#manipula%C3%A7%C3%A3o-de-textos-strings

# Carregar pacotes necessários
library(tidyverse)

# Ler os dados de voos
voos <- read_csv2("dados/voos_dez-2024-alterado.csv")

# Alternativa para ler os dados diretamente da URL
# voos <- read_csv2("https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/voos_dez-2024-alterado.csv")

# textos ----------------------

# Exemplo de extração de texto
empresas <- voos$nm_empresa[10:20]

# Extrair padrão "S.A" das strings
str_extract(empresas, "S\\.A")

# Extrair dígitos das strings
str_extract("123", "\\d")

# Listar arquivos no diretório "dados" com extensão .csv
fs::dir_ls("dados", regexp = "*.csv$")

# Listar todos os arquivos no diretório "dados"
fs::dir_ls("dados")

# Listar arquivos no diretório "dados" com extensão .csv
fs::dir_ls("dados", regexp = ".csv$")

# Exemplo de extração de partes de uma data em texto
data_texto <- "10/02/2025"

# Extrair dois dígitos das strings
str_extract(data_texto, "\\d{2}")

# Extrair todos os dígitos das strings
lista <- str_extract_all(data_texto, "\\d{2}")
lista[[1]][2]

# Extrair data completa no formato dd/mm/yyyy
str_extract(data_texto, "\\d{2}/\\d{2}/\\d{4}")

# exercícios
# 1) Filtrar valores que começam com "R$"
valores <- c("R$ 100", "USD 200", "300€", "R$ 200", "algum texto R")
str_subset(valores, "R\\$")

# 2) Filtrar palavras que começam com "pro"
palavras_pro <- c(
  "processo",
  "projeto",
  "produto",
  "improviso",
  "aprovar",
  "professora",
  "floresta",
  "prédio",
  "prova",
  "problema",
  "compro",
  "sopro"
)

# Filtrar palavras que começam com "pro"
str_subset(palavras_pro, "^pro")

# Filtrar palavras que contêm "pro"
str_subset(palavras_pro, "pro")

# Visualizar palavras que começam com "pro"
str_view(palavras_pro, "^pro", html = TRUE)

# Visualizar palavras que terminam com "pro"
str_view(palavras_pro, "pro$", html = TRUE)

# Parte 2 ----------------------

# Filtrar voos com origem em Congonhas
voos |>
  filter(nm_aerodromo_origem == "CONGONHAS") |> View()

# Filtrar voos com origem em Guarulhos
voos |>
  filter(nm_aerodromo_origem == "GUARULHOS") |> View()

# Verificar se o nome do aeródromo contém "GUARULHOS"
str_detect(voos$nm_aerodromo_origem, "GUARULHOS")

# Filtrar voos com origem em Guarulhos e contar
voos |>
  filter(str_detect(nm_aerodromo_origem, "GUARULHOS")) |>
  count(nm_aerodromo_origem)

# Filtrar voos com origem em Guarulhos ou Congonhas
voos |>
  filter(str_detect(nm_aerodromo_origem, "GUARULHOS|CONGONHAS"))

# Exemplo LATAM
# Filtrar voos da LATAM e contar
voos |>
  filter(str_detect(nm_empresa, "^LATAM")) |>
  count(nm_empresa)

# Outra forma de filtrar voos da LATAM e contar
voos |>
  filter(str_starts(nm_empresa, "LATAM")) |>  # também existe o str_ends
  count(nm_empresa)

# Pergunta: e quando tem maiúscula e minúscula?
# Filtrar voos da LATAM ignorando maiúsculas e minúsculas
voos |>
  filter(str_starts(str_to_lower(nm_empresa), "latam"))

# Funções que usamos com mutate

# Manipular e limpar nomes de empresas
voos |>
  distinct(nm_empresa) |>
  mutate(
    nm_empresa_alterado = str_replace_all(nm_empresa, "-|/", " "),
    nm_empresa_alterado = str_squish(nm_empresa_alterado),
    nm_empresa_alterado = str_to_sentence(nm_empresa_alterado),
    # deixar esse exemplo para quando falar de função
    # nome_separado = str_split(nm_empresa_alterado, " "),
    # sigla = substr(nome_separado, start = 1, stop = 1)
  ) |> View()

# Exemplo de manipulação de espaços em branco
exemplo_espacos <- tibble(
  nomes = c(" Beatriz Milz", "Beatriz Milz ", "Beatriz  Milz", "Beatriz Milz")
)

# Contar ocorrências de nomes com espaços em branco
exemplo_espacos |>
  count(nomes)

# Remover espaços em branco e contar novamente
exemplo_espacos |>
  mutate(nomes = str_squish(nomes)) |>
  count(nomes)

# Limpar e padronizar nomes de aeródromos
voos |>
  mutate(
    nm_aerodromo_origem = str_squish(nm_aerodromo_origem),
    nm_aerodromo_origem = str_to_title(nm_aerodromo_origem),
    nm_aerodromo_origem = str_replace_all(nm_aerodromo_origem, " Do ", " do "),
    nm_aerodromo_origem = str_replace_all(nm_aerodromo_origem, " De ", " de "),
    nm_aerodromo_origem = str_replace_all(nm_aerodromo_origem, " Da ", " da "),
  ) |>
  count(nm_aerodromo_origem, sort = TRUE) |> View()

# Reclassificação de empresas aéreas

# Filtrar voos domésticos
voos_brasil <- voos |>
  filter(ds_natureza_etapa == "DOMÉSTICA")

# Contar ocorrências de empresas aéreas
voos_brasil |>
  count(nm_empresa, sort = TRUE)

# Filtrar voos da empresa AZUL
voos_azul <- voos_brasil |>
  filter(str_detect(nm_empresa, "^AZUL "))

# Contar ocorrências de voos da empresa AZUL
voos_azul |>
  count(nm_empresa, sort = TRUE)

# Reclassificar nomes de empresas aéreas
voos_brasil |>
  select(nm_empresa) |>
  mutate(
    nm_empresa_reclassificado = case_when(
      str_starts(nm_empresa, "AZUL") ~ "AZUL",
      str_starts(nm_empresa, "GOL ") ~ "GOL",
      str_starts(nm_empresa, "TAM |LATAM") ~ "TAM/LATAM",
      str_starts(nm_empresa, "PASSARED") ~ "PASSAREDO",
      .default = "OUTROS"
    )
  ) |>
  count(nm_empresa_reclassificado, sort = TRUE)






