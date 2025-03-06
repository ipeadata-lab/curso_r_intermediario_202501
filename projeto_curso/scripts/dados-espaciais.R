# Carregar pacotes
library(tidyverse)
library(geobr)
library(sf)
# Linking to GEOS 3.11.0, GDAL 3.5.3, PROJ 9.1.0; sf_use_s2() is TRUE

arquivo_dnit_df <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/shapefiles/dnit/dnit_df.gpkg"

rodovias_df <- read_sf(arquivo_dnit_df)

rodovias_df

glimpse(rodovias_df)

rodovias_df |> 
  ggplot() +
  geom_sf(aes(color = ds_tipo_ad))



ggplot() +
  geom_sf(data = rodovias_df, 
          aes(color = ds_tipo_ad)) # +
  # geom_sf(data = ....)  

View(rodovias_df)


class(rodovias_df)

# Coordenadas como texto

caminho_arquivo <- "https://github.com/ipeadata-lab/curso_r_intermediario_202501/raw/refs/heads/main/dados/sigbm_20252118.csv"

dados_sigbm <- read_csv2(caminho_arquivo)

library(parzer)


parse_lat()
parse_lon()

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

ggplot() +
  geom_sf(data = dados_sigbm_sf)



# geobr
library(geobr)

View(list_geobr())

# Código de municipio
lookup_muni("osasco")

estados_br <- read_state()

# Using year/date 2010
# Download status: 27 done; 0 in progress. Total size: 4.19 Mb (287%)... done! 

# Salvar uma cópia
dir.create("dados/geobr/")
write_sf(estados_br, "dados/geobr/estados_br.gpkg")

# write_sf(estados_br, "dados/geobr/estados_br.shp")


# Visualizar com ggplot2
ggplot() +
  geom_sf(data = estados_br)
  
# Voos

voos <- read_csv2("dados/voos_dez-2024-alterado.csv")


dados_origem <- voos |>
  count(sg_uf_origem) |>
  rename(estado = sg_uf_origem, n_voos = n) |>
  mutate(referencia = "Origem")

dados_destino <- voos |>
  count(sg_uf_destino) |>
  rename(estado = sg_uf_destino, n_voos = n) |>
  mutate(referencia = "Destino")

base_contagem_voos_uf <- bind_rows(dados_origem,
                                   dados_destino) |>
  drop_na(estado)



dados_voos_unidos <- full_join(
  estados_br, 
  base_contagem_voos_uf, by = c("abbrev_state" = "estado")
)

class(dados_voos_unidos)

ggplot() +
  geom_sf(data = dados_voos_unidos,
          aes(fill = n_voos)) +
  facet_wrap(vars(referencia))


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


mapa_voos

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


mapa_interativo <- mapview::mapview(dados_sigbm_sf, zcol = "VolumeAtualFormatado")


htmltools::save_html(mapa_interativo, 
                     "mapa_interativo.html")
# Adriano: Depois queria saber como transformar em html, etc.
# rror in as.character.default(x) : 
#   no method for coercing this S4 class to a vector

# Viewer -> Export -> Save as web page



# simplificando vetores


ggplot() +
  geom_sf(data = estados_br)




estados_br_simplificado <- st_simplify(estados_br,
                                      dTolerance = 1000
                                      )

ggplot() +
  geom_sf(data = estados_br_simplificado)

# geobr::read_state(simplified = TRUE)

estados1872 <- geobr::read_state(year = 1872)

ggplot() + 
  geom_sf(data = estados1872)

