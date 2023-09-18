# cargo os pacotes
library('geobr')
library('sf')
library('ggplot2')
#Procuro que os dados estejam
View(list_geobr()) 
#importo a capa  brasil
BR <- read_country(year = 2020)
#importo a capa com os biomas
biomas <- read_biomes(year = 2019)
#importo shapefile com os estados do bioma caatinga do site terrabrasilis
url_file <-"http://terrabrasilis.dpi.inpe.br/download/dataset/caatinga-aux/vector/states_caatinga_biome.zip"

dest_file1 <- tempfile()

#faço o download do arquivo temporario
download.file(url = url_file,
              destfile = dest_file1)

dest_file2 <- tempfile()

#	descompactando em arquivo temporário
unzip(zipfile = dest_file1,
      exdir = dest_file2)

dir(dest_file2)
#importando para a variavel estados
Estados <- sf::st_read(
  dsn = file.path(
    dest_file2,
    layer = "states_caatinga_biome.shp"))
# vejo quantos estados tenho no bioma
unique(Estados) # são 10 Estados
#Crio uma paleta com 10 cores
paleta10 <- c('#8dd3c7','#ffffb3','#bebada','#fb8072','#80b1d3','#fdb462','#b3de69','#fccde5','#d9d9d9','#bc80bd')

# Crio o mapa
#camada Brasil
mapa <- ggplot() +
  geom_sf(data = BR,
          fill = "white", 
          color = "black", 
          size = 3) +
 #camada estados do Bioma
  geom_sf(data = Estados, 
          aes(fill = nome), 
          color = "black") +  
  scale_fill_manual(values = paleta10, name = "Estados") +
  labs(title = "Estados do Bioma Caatinga",
       caption = "Fonte dos dados: IBGE e TerraBrasilis") +
  coord_sf(xlim = c(-75, -35), ylim = c(-35, 10), expand = FALSE) +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5)) +
  guides(fill = guide_legend(title.position = "top"))

# Exiba o mapa
print(mapa)
 # adiciono escala y seta
library(ggspatial)

mapa +
  annotation_scale(
    location = 'bl',     # bottom \ top | right \ left
    bar_cols = c('grey','white')
  ) +
  annotation_north_arrow(
    location = 'tr',
    pad_x = unit(0.30, 'cm'),
    pad_y = unit(0.30, 'cm'),
    height = unit(1.0, 'cm'),
    width = unit(1.0, 'cm'),
    style = north_arrow_fancy_orienteering(
      fill = c('grey40','white'),
      line_col = 'grey20'
    )
  ) -> mapa2

mapa2




