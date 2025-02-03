# install.packages("flightsbr")
voos_brasil_dez_2024 <- flightsbr::read_flights(date = 202412)

voos_selecionado <- voos_brasil_dez_2024 |>
  dplyr::select(
    id_basica,
    id_empresa,
    nm_empresa,
    dt_referencia,
    ds_di,
    ds_grupo_di,
    ds_natureza_etapa,
    hr_partida_real,
    dt_partida_real,
    id_aerodromo_origem,
    nm_aerodromo_origem,
    nm_municipio_origem,
    sg_uf_origem,
    nm_regiao_origem,
    nm_pais_origem,
    nm_continente_origem,
    hr_chegada_real,
    dt_chegada_real,
    id_aerodromo_destino,
    nm_aerodromo_destino,
    nm_municipio_destino,
    sg_uf_destino,
    nm_regiao_destino,
    nm_pais_destino,
    nm_continente_destino,
    dt_sistema,
  )

dplyr::glimpse(voos_selecionado)


readr::write_csv2(voos_selecionado, "dados/voos_dez-2024.csv")

# voos_selecionado <- readr::read_csv2("dados/voos_dez-2024.csv")

voos_alterado <- voos_selecionado |> 
  dplyr::mutate(
    dt_partida_real = format(dt_partida_real, "%d/%m/%Y"),
    dt_chegada_real = as.numeric(dt_chegada_real  - as.Date("1899-12-30")),
    # dt_chegada_real2 = as.Date(dt_chegada_real, origin = "1899-12-30"),
    #dt_chegada_real_2 = janitor::excel_numeric_to_date(dt_chegada_real),
  ) |> 
  dplyr::arrange(dt_referencia)

voos_alterado |> 
  dplyr::select(tidyselect::starts_with("dt_")) 

readr::write_csv2(voos_alterado, "dados/voos_dez-2024-alterado.csv")

