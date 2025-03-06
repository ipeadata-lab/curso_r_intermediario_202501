library(tidyverse)

voos <- read_csv2("dados/voos_dez-2024-alterado.csv")

# alternativa:
# voos <- read_csv2("https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/voos_dez-2024-alterado.csv")

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






