# Fonte dos dados:
# https://www.ibge.gov.br/geociencias/organizacao-do-territorio/tipologias-do-territorio/15788-favelas-e-comunidades-urbanas.html?=&t=resultados
# Arquivos geoespaciais vetoriais > Favelas e Comunidades Urbanas - polígonos > shp


fcu <- read_sf("dados/shapefiles/ibge/poligonos_FCUs_shp/qg_2022_670_fcu_agreg.shp")

fcu_df <- fcu |>
  dplyr::filter(sigla_uf == "DF")

sf::write_sf(fcu, "dados/shapefiles/ibge/fcu_df.gpkg")


leaflet::leaflet() |>
  leaflet::addTiles() |>
  leaflet::addPolygons(data = fcu_df, label = ~ nm_fcu)
