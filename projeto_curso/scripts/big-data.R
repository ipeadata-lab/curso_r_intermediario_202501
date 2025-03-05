# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/big-data.html
# Instala os pacotes necessários
pacotes <- c("DBI", "RSQLite", "dbplyr", "arrow", "RPostgres")
install.packages(pacotes)

# Carrega as bibliotecas necessárias
library(dplyr)
library(DBI)

# Conecta ao banco de dados PostgreSQL -------------------------------
con <- DBI::dbConnect(
  drv = RPostgres::Postgres(),
  host = "grotesquely-fatherly-boxfish.data-1.use1.tembo.io",
  port = 5432,
  user = "postgres",
  password = "eC6wbYBQdA2H4TlW"
)

# Verifica a conexão
con
# <PqConnection> postgres@grotesquely-fatherly-boxfish.data-1.use1.tembo.io:5432

# Lista as tabelas disponíveis no banco de dados
dbListTables(con)
# [1] "voos"                    "pg_stat_statements"
# [3] "pg_stat_statements_info"


# Desconectar:
# dbDisconnect(con)

# Cria um objeto tbl para a tabela "voos"
db_voos <- tbl(con, "voos")
class(db_voos)

# [1] "tbl_PqConnection" "tbl_dbi"          "tbl_sql"
# [4] "tbl_lazy"         "tbl"

# Como acessar esses dados? -------------------------------

# A função names() do R Base não funciona. Pois o objeto db_voos é uma conexão com o banco de dados e não um dataframe.
names(db_voos)

# A função colnames() funciona para acessar os nomes das colunas

colnames(db_voos)
#  [1] "id_basica"                  "id_empresa"
#   [3] "sg_empresa_icao"            "sg_empresa_iata"
#   [5] "nm_empresa"                 "nm_pais"
#   [7] "ds_tipo_empresa"            "nr_voo"
#   [9] "nr_singular"                "id_di"
#  [11] "cd_di"                      "ds_di"
#  [13] "ds_grupo_di"                "dt_referencia"
#  [15] "nr_ano_referencia"          "nr_semestre_referencia"
#  [17] "nm_semestre_referencia"     "nr_trimestre_referencia"
#  [19] "nm_trimestre_referencia"    "nr_mes_referencia"
#  [21] "nm_mes_referencia"          "nr_semana_referencia"
#  [23] "nm_dia_semana_referencia"   "nr_dia_referencia"
#  [25] "nr_ano_mes_referencia"      "id_tipo_linha"
#  [27] "cd_tipo_linha"              "ds_tipo_linha"
#  [29] "ds_natureza_tipo_linha"     "ds_servico_tipo_linha"
#  [31] "ds_natureza_etapa"          "hr_partida_real"
#  [33] "dt_partida_real"            "nr_ano_partida_real"
#  [35] "nr_semestre_partida_real"   "nm_semestre_partida_real"
#  [37] "nr_trimestre_partida_real"  "nm_trimestre_partida_real"
#  [39] "nr_mes_partida_real"        "nm_mes_partida_real"
#  [41] "nr_semana_partida_real"     "nm_dia_semana_partida_real"
#  [43] "nr_dia_partida_real"        "nr_ano_mes_partida_real"
#  [45] "id_aerodromo_origem"        "sg_icao_origem"
#  [47] "sg_iata_origem"             "nm_aerodromo_origem"
#  [49] "nm_municipio_origem"        "sg_uf_origem"
#  [51] "nm_regiao_origem"           "nm_pais_origem"
#  [53] "nm_continente_origem"       "nr_etapa"
#  [55] "hr_chegada_real"            "dt_chegada_real"
#  [57] "nr_ano_chegada_real"        "nr_semestre_chegada_real"
#  [59] "nm_semestre_chegada_real"   "nr_trimestre_chegada_real"
#  [61] "nm_trimestre_chegada_real"  "nr_mes_chegada_real"
#  [63] "nm_mes_chegada_real"        "nr_semana_chegada_real"
#  [65] "nm_dia_semana_chegada_real" "nr_dia_chegada_real"
#  [67] "nr_ano_mes_chegada_real"    "id_equipamento"
#  [69] "sg_equipamento_icao"        "ds_modelo"
#  [71] "ds_matricula"               "id_aerodromo_destino"
#  [73] "sg_icao_destino"            "sg_iata_destino"
#  [75] "nm_aerodromo_destino"       "nm_municipio_destino"
#  [77] "sg_uf_destino"              "nm_regiao_destino"
#  [79] "nm_pais_destino"            "nm_continente_destino"
#  [81] "nr_escala_destino"          "lt_combustivel"
#  [83] "nr_assentos_ofertados"      "kg_payload"
#  [85] "km_distancia"               "nr_passag_pagos"
#  [87] "nr_passag_gratis"           "kg_bagagem_livre"
#  [89] "kg_bagagem_excesso"         "kg_carga_paga"
#  [91] "kg_carga_gratis"            "kg_correio"
#  [93] "nr_decolagem"               "nr_horas_voadas"
#  [95] "kg_peso"                    "nr_velocidade_media"
#  [97] "nr_pax_gratis_km"           "nr_carga_paga_km"
#  [99] "nr_carga_gratis_km"         "nr_correio_km"
# [101] "nr_bagagem_paga_km"         "nr_bagagem_gratis_km"
# [103] "nr_ask"                     "nr_rpk"
# [105] "nr_atk"                     "nr_rtk"
# [107] "id_arquivo"                 "nm_arquivo"
# [109] "nr_linha"                   "dt_sistema"
# [111] "nr_chave"

# Cria uma consulta para contar o número de voos por mês
query_voos_contagem_mes <- db_voos |>
  group_by(nr_ano_referencia, nr_mes_referencia,
           ds_servico_tipo_linha, ds_natureza_etapa) |>
  summarise(quantidade_de_voos = n(), .groups = "drop")


# Exibe a consulta
query_voos_contagem_mes

# Mostra a consulta SQL gerada
show_query(query_voos_contagem_mes)
# <SQL>
# SELECT
#   `nr_ano_referencia`,
#   `nr_mes_referencia`,
#   `ds_servico_tipo_linha`,
#   `ds_natureza_etapa`,
#   COUNT(*) AS `quantidade_de_voos`
# FROM `voos`
# GROUP BY
#   `nr_ano_referencia`,
#   `nr_mes_referencia`,
#   `ds_servico_tipo_linha`,
#   `ds_natureza_etapa`



# Coleta os resultados da consulta em um dataframe
df_voos_contagem_mes <- collect(query_voos_contagem_mes)


# Exibe o dataframe
df_voos_contagem_mes

# Não é necessário separar em dois passos, geralmente já criamos a consulta e coletamos os resultados em um único passo:
df_voos_contagem_mes2 <- db_voos |>
  group_by(nr_ano_referencia, nr_mes_referencia,
           ds_servico_tipo_linha, ds_natureza_etapa) |>
  summarise(quantidade_de_voos = n(), .groups = "drop") |>
  collect()

# As seguintes funções não funcionam com objetos tbl:
# tail(db_voos)
# nrow(db_voos)


# Verifica a conexão
con
# <PqConnection> postgres@grotesquely-fatherly-boxfish.data-1.use1.tembo.io:5432

# Desconecta do banco de dados
dbDisconnect(con)

# Verifica a conexão após desconectar (deve gerar um erro)
con
# Error: Invalid connection