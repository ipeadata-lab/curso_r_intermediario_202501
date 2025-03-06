# download dos dados

# download.file(
#   # caminho do arquivo que queremos baixar
#   url = "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/voos_dez-2024-alterado.csv",
#   # onde salvar no projeto
#   destfile = "dados/voos_dez-2024-alterado.csv",
#   # evitar erros
#   mode = "wb")

library(tidyverse)

voos <- read_csv2("dados/voos_dez-2024-alterado.csv")

# Erro: 'dados/voos_dez-2024-alterado.csv' does not exist in current working directory ('C:/Users/r1459868/OneDrive/Área de Trabalho/curso-ipea-r-interm/Curso R 2 Ipea').


glimpse(voos)


library(readr)
voos <- read_delim("https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/voos_dez-2024-alterado.csv", 
    delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(voos)

# Datas ------------------

class("2025-02-10")

data_hoje <- as.Date("2025-02-10")

class(data_hoje)

# isso dá errado, mas nao gera erro
as.Date("10/02/2025")

Sys.Date()

# 7.2.1.1 Exercício
# 
#     Crie uma variável chamada data_nascimento com sua data de nascimento e transforme-a para o tipo Date.

texto_simples <- "1993-02-15"
data_nascimento <- as.Date("1993-02-15")


#     Crie uma variável chamada data_atual com a data atual do sistema.
# 

data_atual <- Sys.Date()


#     Calcule a diferença entre a data atual e a sua data de nascimento. O que é retornado?

data_atual - data_nascimento


# 
#     Utilize a função Sys.time() e guarde o resultado em uma variável.
#         O que essa função retorna?
#         Qual é o tipo da variável?

hora <- Sys.time()
# "2025-02-10 09:43:45 -03"
class(hora)


# 7.2.2.1 Exercício
# 
#     Utilizando a base de dados voos (importada no início da aula), explore:
#         Quais são as colunas que armazenam alguma data?
#         Qual é o tipo de cada uma dessas colunas?
#         Quais dessas precisariam ser transformadas para o tipo Date? Como você faria isso?

voos_datas  <- voos |> 
  select(starts_with("dt_"))

class(voos$dt_sistema)

# dt_partida_real - 01/12/2024 
# dt_chegada_real - 45627

as.Date(voos$dt_partida_real, format = "%d/%m/%Y")

# %d - dia numérico
# %m - mês
# %Y - year/ano com 4 dígitos


as.Date(voos$dt_chegada_real)

janitor::excel_numeric_to_date(voos$dt_chegada_real)



voos_datas_arrumadas <- voos_datas |> 
  mutate(
    # converter data no formato BR
    dt_partida_real_data = as.Date(dt_partida_real, format = "%d/%m/%Y"),
    # Converter data do excel
    dt_chegada_real_data = janitor::excel_numeric_to_date(dt_chegada_real),
    # Converter data/hora para data
    dt_sistema_data = as.Date(dt_sistema)
  )


# Observe os valores abaixo, e identifique em qual formato de data estão. Como você transformaria esses valores para o tipo Date?
# 
#     "2025-02-03"
#     "03/02/2025"
#     20122
#     45691

as.Date("2025-02-03")
as.Date("03/02/2025", format = "%d/%m/%Y")
as.Date(20122)
as.numeric(as.Date("2025-02-03"))

# as.Date(45691)
janitor::excel_numeric_to_date(45691)


# lubridate ----------------------------

# d - day -dia
# m - month - mes
# y - ano - year
class(dmy("10/02/2024"))

# dmy

voos_datas |> 
  mutate(dt_partida_real_date = dmy(dt_partida_real)) 


# extrair informações de data --------

voos_datas_arrumadas |> 
  mutate(
    ano = year(dt_referencia),
    mes = month(dt_referencia),
    dia = day(dt_referencia)
  ) |> View()


voos_datas_arrumadas |> 
  mutate(
    ano = year(dt_referencia),
    mes = month(dt_referencia, 
                label = TRUE,
                abbr = FALSE,
                locale = "pt_BR"),
    dia = day(dt_referencia),
    dia_semana = wday(dt_referencia)
  ) |> View()

round(0.9)
floor(0.9) # chao
ceiling(0.1) # teto

voos_datas_arrumadas |> 
  mutate(
    mes = floor_date(dt_referencia, unit = "month")
  ) |> View()

# Datas em gráficos -----------------

voos_brasilia <- voos |> 
  filter(nm_municipio_origem == "BRASÍLIA")

class(voos_brasilia$dt_partida_real)
# [1] "character"


contagem_voos_brasilia <- voos_brasilia |> 
  count(dt_partida_real)

contagem_voos_brasilia |> 
  ggplot() +
  geom_col(aes(x = dt_partida_real, y = n))


# converter em data

contagem_voos_brasilia_2 <- voos_brasilia |> 
  mutate(dt_partida_real = dmy(dt_partida_real)) |> 
  count(dt_partida_real)

class(contagem_voos_brasilia_2$dt_partida_real)

contagem_voos_brasilia_2 |> 
  ggplot() +
  geom_col(aes(x = dt_partida_real, y = n))

# Configurar o locale
Sys.setlocale("LC_ALL", "pt_br.utf-8") 

contagem_voos_brasilia_2 |> 
  ggplot() +
  geom_col(aes(x = dt_partida_real, y = n)) +
  scale_x_date(date_breaks = "7 days",
               date_labels =  "%d/%b")
               

# textos ----------------------

empresas <- voos$nm_empresa[10:20]

str_extract(empresas, "S\\.A")

str_extract("123", "\\d")

fs::dir_ls("dados", regexp = "*.csv$")

fs::dir_ls("dados")

fs::dir_ls("dados", regexp = ".csv$")

data_texto <- "10/02/2025"

str_extract(data_texto, "\\d{2}")

lista <- str_extract_all(data_texto, "\\d{2}")
lista[[1]][2]


str_extract(data_texto, "\\d{2}/\\d{2}/\\d{4}")

# exercícios
# 1)
valores <- c("R$ 100", "USD 200", "300€", "R$ 200", "algum texto R")
str_subset(valores, "R\\$") 


# 2)
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


str_subset(palavras_pro, "^pro")

str_subset(palavras_pro, "pro")

str_view(palavras_pro, "^pro", html = TRUE)

str_view(palavras_pro, "pro$", html = TRUE)
