library(sf)
library(tidyverse)
library(geobr)
library(parzer)

# Delimitação dos estados -------
estados_br <- read_state()


# Filtro mais simples: dplyr -----
estado_mg <- estados_br |> 
  filter(abbrev_state == "MG")


# Dados SIGBM ---------
caminho_arquivo <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/sigbm_20252118.csv"

dados_sigbm <- read_csv2(caminho_arquivo)

dados_sigbm_parzer <- dados_sigbm |> 
  mutate(
    lat = parzer::parse_lat(LatitudeFormatada),
    lon = parzer::parse_lon(LongitudeFormatada)
  )

dados_sigbm_sf <- st_as_sf(
  dados_sigbm_parzer, 
  coords = c("lon", "lat"),
  crs = 4674 # https://epsg.io/4674 - SIRGAS 2000
)

dados_sigbm_sf


# Filtro espacial -----

sigbm_mg <- sf::st_filter(dados_sigbm_sf, estado_mg)

mapview::mapview(estado_mg) +
  sigbm_mg
  
# Outro exemplo: DNIT

caminho_dnit_sp <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/shapefiles/dnit/dnit_sp.gpkg"

rodovias_sp <- read_sf(caminho_dnit_sp)

mapview::mapview(rodovias_sp)

# obter a delimitação de Osasco
municipio_osasco <- read_municipality(3534401,  simplified = FALSE)

intersection_rodovia_osasco <- sf::st_intersection(rodovias_sp, municipio_osasco)

# Warning message:
# attribute variables are assumed to be spatially constant throughout all geometries 

mapview::mapview(intersection_rodovia_osasco) #+ 
  municipio_osasco
  
  
filter_rodovia_osasco <- sf::st_filter(rodovias_sp, municipio_osasco)

filter_rodovia_osasco

mapview::mapview(filter_rodovia_osasco) +
  municipio_osasco

# áreas e distâncias -----------

sf::st_area(municipio_osasco)
# 64.94 km²


barragens_alto_volume <- sigbm_mg |> 
  slice_max(order_by = VolumeAtualFormatado, n = 2) 

st_distance(barragens_alto_volume[1, ], 
            barragens_alto_volume[2, ],
            by_element = TRUE)

matriz_de_distancias <- st_distance(head(sigbm_mg))

matriz_de_distancias

