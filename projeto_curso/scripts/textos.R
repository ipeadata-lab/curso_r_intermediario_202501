# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/texto-data.html#manipula%C3%A7%C3%A3o-de-textos-strings


library(tidyverse)

voos <- read_csv2("dados/voos_dez-2024-alterado.csv")

# alternativa:
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
voos |>
  filter(nm_aerodromo_origem == "CONGONHAS") |> View()

voos |>
  filter(nm_aerodromo_origem == "GUARULHOS") |> View()

str_detect(voos$nm_aerodromo_origem, "GUARULHOS")

voos |>
  filter(str_detect(nm_aerodromo_origem, "GUARULHOS")) |>
  count(nm_aerodromo_origem)

voos |>
  filter(str_detect(nm_aerodromo_origem, "GUARULHOS|CONGONHAS"))

# Exemplo LATAM
voos |>
  filter(str_detect(nm_empresa, "^LATAM")) |>
  count(nm_empresa)

voos |>
  filter(str_starts(nm_empresa, "LATAM")) |>  # também existe o str_ends
  count(nm_empresa)

# pergunta: e quando tem maiúscula e minúscula?
voos |>
  filter(str_starts(str_to_lower(nm_empresa), "latam"))

# funções que usamos com mutate

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


exemplo_espacos <- tibble(
  nomes = c(" Beatriz Milz", "Beatriz Milz ", "Beatriz  Milz", "Beatriz Milz")
)

exemplo_espacos |>
  count(nomes)

exemplo_espacos |>
  mutate(nomes = str_squish(nomes)) |>
  count(nomes)


voos |>
  mutate(
    nm_aerodromo_origem = str_squish(nm_aerodromo_origem),
    nm_aerodromo_origem = str_to_title(nm_aerodromo_origem),
    nm_aerodromo_origem = str_replace_all(nm_aerodromo_origem, " Do ", " do "),
    nm_aerodromo_origem = str_replace_all(nm_aerodromo_origem, " De ", " de "),
    nm_aerodromo_origem = str_replace_all(nm_aerodromo_origem, " Da ", " da "),
  ) |>
  count(nm_aerodromo_origem, sort = TRUE) |> View()

# reclassificação

voos_brasil <- voos |>
  filter(ds_natureza_etapa == "DOMÉSTICA")

voos_brasil |>
  count(nm_empresa, sort = TRUE)

voos_azul <- voos_brasil |>
  filter(str_detect(nm_empresa, "^AZUL "))


voos_azul |>
  count(nm_empresa, sort = TRUE)


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






