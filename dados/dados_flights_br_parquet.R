library(arrow)
library(dplyr)
library(DBI)

parquet_path <- "dados/flightsbr_parquet/"


con <- dbConnect(drv = RSQLite::SQLite(),
                 # caminho para um arquivo SQLite
                 dbname = "dados/flights_br.sqlite")

tab_voos <- tbl(con, "voos")

col_tab_voos <- collect(tab_voos)

col_tab_voos |> 
  group_by(nr_ano_referencia, nr_mes_referencia) |> 
  write_dataset(path = parquet_path, format = "parquet")

dbDisconnect(con)

tibble(
  arquivos = list.files(parquet_path, recursive = TRUE),
  tamanho_MB = file.size(file.path(parquet_path, arquivos)) / 1024^2
)

col_tab_voos |> 
  readr::write_csv2("dados/flightsbr_2024.csv")


# Criando um zip com os arquivos parquet
zip::zip(
  zipfile = "dados/flightsbr_parquet.zip", parquet_path
)
