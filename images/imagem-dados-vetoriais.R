library(sf)
library(ggplot2)

# codigo do municipio
cod_municipio <- 3534401

# baixa geometria do municipio
muni <- geobr::read_municipality(cod_municipio)

sf::write_sf(muni, "dados/geobr/osasco-sp.gpkg")


escolas <- geobr::read_schools()

escolas_muni <- escolas |>
  dplyr::filter(name_muni == muni$name_muni,
                government_level %in% c("Estadual", "Municipal"))

# Não subir este shapefile no github, é grande
rodovias <- sf::read_sf("dados/shapefiles/dnit/SNV_202501A.shp")

rodovias |> 
  dplyr::filter(sg_uf == "SP") |> 
  sf::write_sf("dados/shapefiles/dnit/dnit_sp.gpkg")

rodovias_muni <- sf::st_filter(rodovias, muni, .predicate = st_intersects)


tema_mapa <- theme_void() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5))
    

# Gerando mapas

mapa_delimitacao <- ggplot() +
  # municipio
  geom_sf(data = muni, show.legend = FALSE)  +
  labs(title = "Município", subtitle = "Polígono") +
  tema_mapa

mapa_escolas <- ggplot() +
  geom_sf(data = escolas_muni, show.legend = TRUE)  +
  labs(title = "Escolas públicas", subtitle = "Pontos") +
  tema_mapa

mapa_rodovias <-  ggplot() +
  geom_sf(data = rodovias_muni, # aes(color = government_level),
          show.legend = TRUE)  +
  labs(title = "Rodovias", subtitle = "Linhas") +
  tema_mapa






# mapa_completo

mapa_completo <- ggplot() +
  # municipio
  geom_sf(data = muni, show.legend = FALSE) +
  # escolas
  geom_sf(data = escolas_muni, show.legend = TRUE) +
  # rodovias
  geom_sf(data = rodovias_muni, show.legend = FALSE) +
  tema_mapa  +
  labs(title = "Composição", subtitle = "Pontos, linhas e polígonos") 

mapa_completo


library(patchwork)

exemplo_composicao <- mapa_delimitacao + mapa_escolas + mapa_rodovias + mapa_completo + plot_layout(nrow = 1) 


ggplot2::ggsave("images/exemplo-vetorial-osasco.png")

