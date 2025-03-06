# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/texto-data.html#manipula%C3%A7%C3%A3o-de-datas


# download dos dados que vão ser utilizados
download.file(
# caminho do arquivo que queremos baixar
  url = "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/voos_dez-2024-alterado.csv",
#   # onde salvar no projeto
  destfile = "dados/voos_dez-2024-alterado.csv",
#   # evitar erros
  mode = "wb")

# Carregar pacotes necessários
library(tidyverse)

# Ler os dados de voos
voos <- read_csv2("dados/voos_dez-2024-alterado.csv")

# O erro abaixo ocorre porque o arquivo não foi encontrado no caminho especificado

# Erro: 'dados/voos_dez-2024-alterado.csv' does not exist in current working directory ('C:/Users/.../OneDrive/Área de Trabalho/curso-ipea-r-interm/Curso R 2 Ipea').

# Visualizar a estrutura dos dados
glimpse(voos)

# Alternativa para ler os dados diretamente da URL
library(readr)
voos <- read_delim("https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/voos_dez-2024-alterado.csv",
    delim = ";", escape_double = FALSE, trim_ws = TRUE)
View(voos)

# Datas ------------------

# Verificar a classe de uma string de data
class("2025-02-10")

# Converter uma string para o tipo Date
data_hoje <- as.Date("2025-02-10")

# Verificar a classe do objeto convertido
class(data_hoje)

# Isso dá errado, mas não gera erro
as.Date("10/02/2025")

# Obter a data atual do sistema
Sys.Date()

# 7.2.1.1 Exercício
#
# Crie uma variável chamada data_nascimento com sua data de nascimento e transforme-a para o tipo Date.
texto_simples <- "1993-02-15"
data_nascimento <- as.Date("1993-02-15")

# Crie uma variável chamada data_atual com a data atual do sistema.
data_atual <- Sys.Date()

# Calcule a diferença entre a data atual e a sua data de nascimento. O que é retornado?
data_atual - data_nascimento

# Utilize a função Sys.time() e guarde o resultado em uma variável.
# O que essa função retorna?
# Qual é o tipo da variável?
hora <- Sys.time()
# "2025-02-10 09:43:45 -03"
class(hora)

# 7.2.2.1 Exercício
#
# Utilizando a base de dados voos (importada no início da aula), explore:
# Quais são as colunas que armazenam alguma data?
# Qual é o tipo de cada uma dessas colunas?
# Quais dessas precisariam ser transformadas para o tipo Date? Como você faria isso?

# Selecionar colunas que começam com "dt_"
voos_datas  <- voos |>
  select(starts_with("dt_"))

# Verificar a classe de uma coluna específica
class(voos$dt_sistema)

# Exemplo de datas em diferentes formatos
# dt_partida_real - 01/12/2024
# dt_chegada_real - 45627

# Converter data no formato BR
as.Date(voos$dt_partida_real, format = "%d/%m/%Y")

# %d - dia numérico
# %m - mês
# %Y - ano com 4 dígitos

# Converter data no formato numérico do Excel
as.Date(voos$dt_chegada_real)

# Usar a função do pacote janitor para converter data do Excel
janitor::excel_numeric_to_date(voos$dt_chegada_real)

# Arrumar as datas no dataframe
voos_datas_arrumadas <- voos_datas |>
  mutate(
    # Converter data no formato BR
    dt_partida_real_data = as.Date(dt_partida_real, format = "%d/%m/%Y"),
    # Converter data do Excel
    dt_chegada_real_data = janitor::excel_numeric_to_date(dt_chegada_real),
    # Converter data/hora para data
    dt_sistema_data = as.Date(dt_sistema)
  )

# Observe os valores abaixo, e identifique em qual formato de data estão. Como você transformaria esses valores para o tipo Date?
#
# "2025-02-03"
# "03/02/2025"
# 20122
# 45691

# Converter string para Date
as.Date("2025-02-03")
as.Date("03/02/2025", format = "%d/%m/%Y")

# Converter número para Date
as.Date(20122)
as.numeric(as.Date("2025-02-03"))

# Converter data do Excel para Date
# as.Date(45691)
janitor::excel_numeric_to_date(45691)

# lubridate ----------------------------

# d - day - dia
# m - month - mês
# y - ano - year

# Verificar a classe de uma data no formato dmy
class(dmy("10/02/2024"))

# Usar a função dmy para converter data no formato dia/mês/ano
voos_datas |>
  mutate(dt_partida_real_date = dmy(dt_partida_real))

# extrair informações de data --------

# Extrair ano, mês e dia de uma data
voos_datas_arrumadas |>
  mutate(
    ano = year(dt_referencia),
    mes = month(dt_referencia),
    dia = day(dt_referencia)
  ) |> View()

# Extrair informações de data com formatação adicional
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

# Funções para arredondar datas
round(0.9)
floor(0.9) # chão - arredonda para baixo
ceiling(0.1) # teto - arredonda para cima

# Arredondar data para o início do mês
voos_datas_arrumadas |>
  mutate(
    mes = floor_date(dt_referencia, unit = "month")
  ) |> View()

# Datas em gráficos -----------------

# Filtrar dados de voos com origem em Brasília
voos_brasilia <- voos |>
  filter(nm_municipio_origem == "BRASÍLIA")

# Verificar a classe da coluna de data
class(voos_brasilia$dt_partida_real)
# [1] "character"

# Contar o número de voos por data de partida
contagem_voos_brasilia <- voos_brasilia |>
  count(dt_partida_real)

# Plotar o gráfico de contagem de voos por data de partida
contagem_voos_brasilia |>
  ggplot() +
  geom_col(aes(x = dt_partida_real, y = n))

# Converter a coluna de data para o tipo Date
contagem_voos_brasilia_2 <- voos_brasilia |>
  mutate(dt_partida_real = dmy(dt_partida_real)) |>
  count(dt_partida_real)

# Verificar a classe da coluna de data convertida
class(contagem_voos_brasilia_2$dt_partida_real)

# Plotar o gráfico de contagem de voos por data de partida com a coluna convertida
contagem_voos_brasilia_2 |>
  ggplot() +
  geom_col(aes(x = dt_partida_real, y = n))

# Configurar o locale para português do Brasil
Sys.setlocale("LC_ALL", "pt_br.utf-8")

# Plotar o gráfico de contagem de voos com formatação de data no eixo x
contagem_voos_brasilia_2 |>
  ggplot() +
  geom_col(aes(x = dt_partida_real, y = n)) +
  scale_x_date(date_breaks = "7 days",
               date_labels =  "%d/%b")
