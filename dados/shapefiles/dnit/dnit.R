dnit <- sf::read_sf("dados/shapefiles/dnit/SNV_202501A.shp")

dnit_df <- dnit |> 
  dplyr::filter(sg_uf == "DF")


sf::write_sf(dnit_df, "dados/shapefiles/dnit/dnit_df.gpkg")
