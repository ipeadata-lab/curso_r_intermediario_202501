# Carregar o pacote DBI
library(DBI)

# Fazer a conexao com o banco de dados
# con <- dbConnect(RSQLite::SQLite(), "dados/flights_br.sqlite")


con <- DBI::dbConnect(
    RPostgres::Postgres(),
    user = "postgres",
    host = "grotesquely-fatherly-boxfish.data-1.use1.tembo.io",
    port = 5432,
    password = "eC6wbYBQdA2H4TlW"
  )

# Criar uma tabela com as opções de mes e ano para iterar
meses <- 1:12
anos <- 2024
tbl_mes_ano <- tidyr::crossing(anos, meses) |>
  dplyr::mutate(
    meses = stringr::str_pad(meses, width = 2, pad = "0"),
    mes_ano = paste(anos, meses, sep = "")
  ) |> 
  dplyr::group_split(mes_ano)


# criar uma função que recebe o mes e ano, e a conexao,
# e adiciona os dados dos voos no banco
adicionar_dados_voos <- function(mes_ano, conexao){
  voos <- flightsbr::read_flights(date = mes_ano)
  dbWriteTable(conexao, "voos", voos, append = TRUE)
}





# Iterar sobre os meses e anos

tbl_mes_ano |> 
  purrr::map(~adicionar_dados_voos(.x$mes_ano, conexao = con), .progress = TRUE)

# 
tabela_voos <- dplyr::tbl(con, "voos")

# ver nome das colunas
names(tabela_voos) # não funciona como desejado
colnames(tabela_voos)


# Verificar os meses e anos disponíveis
mes_ano <- tabela_voos |> 
  dplyr::count(nr_mes_referencia, nr_ano_referencia) |> dplyr::collect()


# Fechar a conexão
dbDisconnect(con)
