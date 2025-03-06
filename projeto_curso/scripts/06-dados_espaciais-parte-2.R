# Material da aula: https://ipeadata-lab.github.io/curso_r_intermediario_202501/dados-espaciais.html

# Parte 2

# Carregar pacotes necessários
library(sf)
library(tidyverse)
library(geobr)
library(parzer)

# Delimitação dos estados -------
# Ler os dados dos estados do Brasil
estados_br <- read_state()

# Filtro mais simples: dplyr -----
# Filtrar os dados para obter apenas o estado de Minas Gerais (MG)
estado_mg <- estados_br |>
  filter(abbrev_state == "MG")

# Dados SIGBM ---------
# Caminho para o arquivo CSV com dados de coordenadas
caminho_arquivo <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/sigbm_20252118.csv"

# Ler o arquivo CSV
dados_sigbm <- read_csv2(caminho_arquivo)

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

# Filtro espacial -----
# Filtrar os dados espaciais para obter apenas as barragens em Minas Gerais
sigbm_mg <- sf::st_filter(dados_sigbm_sf, estado_mg)

# Visualizar o estado de MG e as barragens em um mapa interativo
mapview::mapview(estado_mg) +
  sigbm_mg

# Outro exemplo: DNIT
# Caminho para o arquivo shapefile das rodovias de SP
caminho_dnit_sp <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/shapefiles/dnit/dnit_sp.gpkg"

# Ler o arquivo shapefile das rodovias de SP
rodovias_sp <- read_sf(caminho_dnit_sp)

# Visualizar as rodovias de SP em um mapa interativo
mapview::mapview(rodovias_sp)

# Obter a delimitação do município de Osasco
municipio_osasco <- read_municipality(3534401, simplified = FALSE)

# Encontrar a interseção entre as rodovias de SP e o município de Osasco
intersection_rodovia_osasco <- sf::st_intersection(rodovias_sp, municipio_osasco)

# Warning message:
# attribute variables are assumed to be spatially constant throughout all geometries

# Visualizar a interseção em um mapa interativo
mapview::mapview(intersection_rodovia_osasco) #+
  municipio_osasco

# Filtrar as rodovias que passam pelo município de Osasco
filter_rodovia_osasco <- sf::st_filter(rodovias_sp, municipio_osasco)

# Exibir as rodovias filtradas
filter_rodovia_osasco

# Visualizar as rodovias filtradas e o município de Osasco em um mapa interativo
mapview::mapview(filter_rodovia_osasco) +
  municipio_osasco

# Áreas e distâncias -----------
# Calcular a área do município de Osasco
sf::st_area(municipio_osasco)
# 64.94 km²

# Selecionar as duas barragens com maior volume em MG
barragens_alto_volume <- sigbm_mg |>
  slice_max(order_by = VolumeAtualFormatado, n = 2)

# Calcular a distância entre as duas barragens selecionadas
st_distance(barragens_alto_volume[1, ],
            barragens_alto_volume[2, ],
            by_element = TRUE)

# Calcular a matriz de distâncias entre as primeiras barragens em MG
matriz_de_distancias <- st_distance(head(sigbm_mg))

# Exibir a matriz de distâncias
matriz_de_distancias

