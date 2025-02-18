library(sidrar)

# Sugestão de dados feita pelo Rafael: ------
# https://sidra.ibge.gov.br/Tabela/4092
# Dados trimestrais da PNADc:
# "Pessoas de 14 anos ou mais de idade,
# por condição em relação à força de trabalho e condição de ocupação"
# Codigo: 4092

# Com o codigo abaixo, a baixa essa tabela que traz pop ocupada e desocupada
# para cada UF em diferentes trimentes.
# Acho que um dos objetivos do exercicio poderia ser por exemplo calcular a
# taxa de desocupação de cada estado e cada região ao longo do tempo.
# Voces vao ver que a tabela é bem 'untidy', entao dá bastante pano pra manga.

# Buscando informação desta tabela no SIDRA
informacoes_tabela_4092 <- sidrar::info_sidra(4092)

# Quais são os períodos disponíveis?
periodos_disponiveis <- informacoes_tabela_4092$period |>
  stringr::str_split(pattern = ", ") |>
  unlist()


dados_4092 <- sidrar::get_sidra(
  # Tabela 4092 - Pessoas de 14 anos ou mais de idade, por condição em relação à força de trabalho e condição de ocupação
  x = 4092,
  # Períodos: trimestres
  period = periodos_disponiveis,
  # Dados agrupados por UF
  geo = "State",
  # 4: Return the codes and names of the descriptors (Default)
  format  = 4
)


# Salvando os dados brutos em vários formatos, para usar no curso!
readr::write_rds(dados_4092, "dados/sidrar_4092_bruto.rds")

readr::write_csv(dados_4092, "dados/sidrar_4092_bruto.csv")

readr::write_csv2(dados_4092, "dados/sidrar_4092_bruto_2.csv")

writexl::write_xlsx(dados_4092, "dados/sidrar_4092_bruto.xlsx")
