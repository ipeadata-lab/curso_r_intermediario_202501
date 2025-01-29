dir.create("dados")

# uma alternativa
# fs::dir_create("dados")

download.file(
  url = "https://github.com/ipeadata-lab/curso_r_intro_202409/raw/refs/heads/main/dados/sidrar_4092_bruto_2.csv",
              destfile = "dados/sidrar_4092_bruto_2.csv",
              mode = "wb")

# 
write.csv2(mtcars, "dados/mtcars.csv")
