# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/dados-espaciais.html

# Parte 1

# Carregar pacotes necessários
library(tidyverse)
library(geobr)
library(sf)
# Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.0; sf_use_s2() is TRUE


# Trabalhando com arquivos espaciais (.gpkg, .shp, etc.) ----------------
# Caminho para o arquivo de rodovias do DF
arquivo_dnit_df <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/shapefiles/dnit/dnit_df.gpkg"

# Ler o arquivo shapefile das rodovias do DF
rodovias_df <- read_sf(arquivo_dnit_df)

# Exibir o conteúdo do dataframe
rodovias_df

# Visualizar a estrutura do dataframe
glimpse(rodovias_df)

# Plotar o mapa das rodovias do DF
rodovias_df |>
  ggplot() +
  geom_sf(aes(color = ds_tipo_ad))

# Outra forma de plotar o mapa das rodovias do DF
ggplot() +
  geom_sf(data = rodovias_df,
          aes(color = ds_tipo_ad)) # +
  # geom_sf(data = ....)

# Visualizar o dataframe em uma nova aba
View(rodovias_df)

# Verificar a classe do objeto
class(rodovias_df)

# Coordenadas como texto ------------------------------------

# Caminho para o arquivo CSV com dados de barrgens de mineração no Brasil
# Dados do SIGBM
caminho_arquivo <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/sigbm_20252118.csv"

# Ler o arquivo CSV
dados_sigbm <- read_csv2(caminho_arquivo)

# Carregar o pacote parzer para parsear coordenadas
library(parzer)

# Funções para parsear latitude e longitude
# parse_lat()
# parse_lon()

# Parsear as coordenadas e adicionar ao dataframe
dados_sigbm_parzer <- dados_sigbm |>
  mutate(
    lat = parzer::parse_lat(LatitudeFormatada),
    lon = parzer::parse_lon(LongitudeFormatada)
  )

# Converter o dataframe para um objeto sf (simple features)
dados_sigbm_sf <- st_as_sf(
  dados_sigbm_parzer,
  coords = c("lon", "lat"),
  crs = 4674 # https://epsg.io/4674 - SIRGAS 2000
)

# Exibir o objeto sf
dados_sigbm_sf

# Plotar o mapa com os pontos de coordenadas
ggplot() +
  geom_sf(data = dados_sigbm_sf)

# Carregar o pacote geobr para obter dados geográficos do Brasil
library(geobr)

# Visualizar as funções disponíveis no pacote geobr
View(list_geobr())

# Obter o código do município de Osasco
lookup_muni("osasco")

# Ler os dados dos estados do Brasil
estados_br <- read_state()

# Using year/date 2010
# Download status: 27 done; 0 in progress. Total size: 4.19 Mb (287%)... done!

# Salvar uma cópia dos dados dos estados
dir.create("dados/geobr/")
write_sf(estados_br, "dados/geobr/estados_br.gpkg")

# write_sf(estados_br, "dados/geobr/estados_br.shp")

# Visualizar os estados com ggplot2
ggplot() +
  geom_sf(data = estados_br)

# Exemplo de mapa temático ---------------------------
# Usando os dados que já estamos trabalhando em outras aulas

# Ler os dados de voos
voos <- read_csv2("dados/voos_dez-2024-alterado.csv")

# Contar o número de voos por estado de origem
dados_origem <- voos |>
  count(sg_uf_origem) |>
  rename(estado = sg_uf_origem, n_voos = n) |>
  mutate(referencia = "Origem")

# Contar o número de voos por estado de destino
dados_destino <- voos |>
  count(sg_uf_destino) |>
  rename(estado = sg_uf_destino, n_voos = n) |>
  mutate(referencia = "Destino")

# Unir os dados de origem e destino
base_contagem_voos_uf <- bind_rows(dados_origem,
                                   dados_destino) |>
  drop_na(estado)

# Unir os dados de voos com os dados dos estados
dados_voos_unidos <- full_join(
  estados_br,
  base_contagem_voos_uf, by = c("abbrev_state" = "estado")
)

# Verificar a classe do objeto resultante
class(dados_voos_unidos)

# Plotar o mapa com a contagem de voos por estado
ggplot() +
  geom_sf(data = dados_voos_unidos,
          aes(fill = n_voos)) +
  facet_wrap(vars(referencia))

# Plotar o mapa com a contagem de voos por estado, com escala de cores
ggplot() +
  geom_sf(data = dados_voos_unidos, aes(fill = n_voos)) +
  facet_wrap(vars(referencia)) +
  scale_fill_viridis_c(
    name = "voos",
    option = "plasma",
    breaks = c(0, 1000, 10000, 20000, 30000),
    labels = scales::number_format(),
    trans = "pseudo_log",
    na.value = "#F8F7F7",
    aesthetics = c("fill", "color")
  ) +
  ggthemes::theme_map()

# Arrumar os dados de voos para plotagem
dados_voos_arrumados <- dados_voos_unidos |>
  mutate(
    referencia = factor(referencia, labels = c("Origem", "Destino")),
    categoria_n_voos = cut(
      n_voos,
      breaks = c(0, 100, 500, 1000, 5000, 10000, 15000,
                 20000, 25000, Inf),
      labels = c(
        "0-100",
        "101-500",
        "501-1.000",
        "1.001-5.000",
        "5.001-10.000",
        "10.001-15.000",
        "15.001-20.000",
        "20.001-25.000",
        "25.001 ou mais"
      )
    )
  )

# Criar o mapa de voos
mapa_voos <- ggplot() +
  geom_sf(data = dados_voos_arrumados, aes(fill = n_voos)) +
  facet_wrap(vars(referencia)) +
  theme_minimal() +
  labs(title = "Quantidade de voos por estado, em Dezembro/2024",
       fill = "Número de voos",
       caption = "Dados obtidos com o pacote flightsbr do R.") +
  theme(legend.position = "bottom",
        axis.text.y = element_text(angle = 90)) +
    scale_fill_viridis_c(
    name = "voos",
    option = "plasma",
    breaks = c(0, 1000, 10000, 20000, 30000),
    labels = scales::number_format(),
    trans = "pseudo_log",
    na.value = "#F8F7F7",
    aesthetics = c("fill", "color")
  )

# Exibir o mapa de voos
mapa_voos

# Adicionar escala e seta de norte ao mapa
# install.packages("ggspatial")
mapa_voos +
  ggspatial::annotation_scale() +
    # Adiciona o Norte Geográfico
  ggspatial::annotation_north_arrow(
    location = "bl",
    which_north = "true",
    pad_x = unit(0.5, "cm"),
    pad_y = unit(0.8, "cm"),
    height = unit(1, "cm"),
    width = unit(1, "cm")
  )

# tmap - alternativa ao ggplot2
library(tmap)

# visualização interativa
# install.packages("mapview")
mapview::mapview(dados_sigbm_sf, zcol = "VolumeAtualFormatado")# +
  #estados_br

# Criar um mapa interativo
mapa_interativo <- mapview::mapview(dados_sigbm_sf, zcol = "VolumeAtualFormatado")

# Salvar o mapa interativo como HTML
htmltools::save_html(mapa_interativo,
                     "mapa_interativo.html")
# Adriano: Depois queria saber como transformar em html, etc.
# Error in as.character.default(x) :
#   no method for coercing this S4 class to a vector

# Viewer -> Export -> Save as web page

# Simplificando vetores ------------------------------------

# Plotar os estados do Brasil
ggplot() +
  geom_sf(data = estados_br)

# Simplificar os dados dos estados
estados_br_simplificado <- st_simplify(estados_br,
                                      dTolerance = 1000
                                      )

# Plotar os estados simplificados
ggplot() +
  geom_sf(data = estados_br_simplificado)

# As funções do geobr tem um argumento chamado `simplified`, que retorna os
# dados já simplificados quando definido como simplified = TRUE.

# Ler os dados dos estados do Brasil em 1872
estados1872 <- geobr::read_state(year = 1872)

# Plotar os estados de 1872
ggplot() +
  geom_sf(data = estados1872)

