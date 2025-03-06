# Carrega os pacotes necessários
library(arrow)  # para trabalhar com arquivos parquet
library(dplyr)  # para manipulação de dados

# Define o diretório onde estão os arquivos parquet
diretorio_parquet <- "dados/flightsbr_parquet/"

# Abre o conjunto de dados parquet como um Dataset do Arrow
# Isso permite trabalhar com dados maiores que a memória RAM
dados_voos_parquet <- open_dataset(sources = diretorio_parquet,
             format = "parquet")

# Verifica a classe do objeto - é um FileSystemDataset do Arrow
class(dados_voos_parquet)

# Mostra a estrutura (schema) do conjunto de dados
# Lista todas as colunas e seus tipos de dados
schema(dados_voos_parquet)

# Cria uma consulta para contar voos por ano, mês e tipo
# A consulta não é executada ainda (lazy evaluation)
query_pq_quantidade_voos <- dados_voos_parquet |> 
  group_by(nr_ano_referencia, nr_mes_referencia,
           ds_servico_tipo_linha, ds_natureza_etapa) |>
  summarise(quantidade_de_voos = n(), .groups = "drop")

# Mostra a consulta SQL que será executada
show_query(query_pq_quantidade_voos)

# Executa a consulta e traz os resultados para a memória
df_quantidade_voos <- collect(query_pq_quantidade_voos)

# Exemplo de como escrever e ler um arquivo parquet único
# Salva o dataset penguins como arquivo parquet
arrow::write_parquet(palmerpenguins::penguins, "dados/pinguins.parquet")

# Lê o arquivo parquet salvo
pinguins_pq <- arrow::read_parquet("dados/pinguins.parquet")

# Código comentado que mostra como escrever dados agrupados em múltiplos arquivos parquet
# col_tab_voos |> 
#   group_by(nr_ano_referencia, nr_mes_referencia) |> 
#   write_dataset(path = parquet_path, format = "parquet")

