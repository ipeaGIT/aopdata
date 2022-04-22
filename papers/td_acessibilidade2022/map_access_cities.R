library(ggplot2)
library(dplyr)
library(data.table)
library(ggalt)
library(hrbrthemes)
library(ggnewscale) # install.packages("ggnewscale")
library(ggsn)
library(sf)
library(Hmisc)


# fub ---------------------------------------------------------------------

sfc_as_cols <- function(x, names = c("lon","lat")) {
  stopifnot(inherits(x,"sf") && inherits(sf::st_geometry(x),"sfc_POINT"))                                                                                                                                                                                                                                                     
  ret <- sf::st_coordinates(x)
  ret <- tibble::as_tibble(ret)
  stopifnot(length(names) == ncol(ret))
  x <- x[ , !names(x) %in% names]
  ret <- setNames(ret,names)
  ui <- dplyr::bind_cols(x,ret)
  st_set_geometry(ui, NULL)
}


# create list with munis ----------------------

munis_list <- list(
  
  munis_df = tribble(
    ~code_muni, ~abrev_muni, ~name_muni,        ~abrev_estado,  ~map_plot_ratio_wh,
    2304400,    "for",       "Fortaleza",       "CE",           1.2,
    3550308,    "spo",       "Sao Paulo",       "SP",           0.65,
    3304557,    "rio",       "Rio de Janeiro",  "RJ",           1.91, 
    4106902,    "cur",       "Curitiba",        "PR",           0.62,
    4314902,    "poa",       "Porto Alegre",    "RS",           0.75,
    3106200,    "bho",       "Belo Horizonte",  "MG",           0.69,
    5300108,    "bsb",       "Brasilia",        "DF",           1.71,
    2927408,    "sal",       "Salvador",        "BA",           1.36,
    1302603,    "man",       "Manaus",          "AM",           1.27,           
    2611606,    "rec",       "Recife",          "PE",           0.68,
    5208707,    "goi",       "Goiania",         "GO",           0.93,
    1501402,    "bel",       "Belem",           "PA",           0.65,
    3518800,    "gua",       "Guarulhos",       "SP",           0.91,
    3509502,    "cam",       "Campinas",        "SP",           1.20,
    2111300,    "slz",       "Sao Luis",        "MA",           0.78,
    3304904,    "sgo",       "Sao Goncalo",     "RJ",           1.21,
    2704302,    "mac",       "Maceio",          "AL",           0.74,
    3301702,    "duq",       "Duque de Caxias", "RJ",           0.61,
    5002704,    "cgr",       "Campo Grande",    "MS",           0.87,
    2408102,    "nat",       "Natal",           "RN",           0.70
  ) %>% setDT(),
  
  
  munis_modo = tribble(
    ~abrev_muni, ~`2017`,  ~`2018`,  ~`2019`,  ~`2020`, 
    "for",       "todos",  "todos",  "todos",  "todos",     
    "spo",       "todos",  "todos",  "todos",  "todos",   
    "rio",       "ativo",  "todos",  "todos",  "todos",   
    "cur",       "todos",  "todos",  "todos",  "todos",   
    "poa",       "todos",  "todos",  "todos",  "todos",   
    "bho",       "todos",  "todos",  "todos",  "todos",   
    "bsb",       "ativo",  "ativo",  "ativo",  "ativo",   
    "sal",       "ativo",  "ativo",  "ativo",  "ativo",   
    "man",       "ativo",  "ativo",  "ativo",  "ativo",   
    "rec",       "ativo",  "ativo",  "todos",  "todos",   
    "goi",       "ativo",  "ativo",  "todos",  "todos",   
    "bel",       "ativo",  "ativo",  "ativo",  "ativo",   
    "gua",       "ativo",  "ativo",  "ativo",  "ativo",   
    "cam",       "todos",  "todos",  "todos",  "todos",   
    "slz",       "ativo",  "ativo",  "ativo",  "ativo",   
    "sgo",       "ativo",  "ativo",  "ativo",  "ativo",   
    "mac",       "ativo",  "ativo",  "ativo",  "ativo",   
    "duq",       "ativo",  "ativo",  "ativo",  "ativo",   
    "cgr",       "ativo",  "ativo",  "ativo",  "ativo",   
    "nat",       "ativo",  "ativo",  "ativo",  "ativo"   
  ) %>% 
    tidyr::pivot_longer(cols = `2017`:`2020`, names_to = "ano_modo", values_to = "modo") %>% 
    setDT()
)



###### B. temas para mapas ---------------------------

theme_for_CMA <- function(base_size, ...) {
  
  # theme_void(base_family="Roboto Condensed") %+replace%
  theme_void() %+replace%
    
    theme(
      legend.position = "bottom",
      plot.margin=unit(c(2,0,0,0),"mm"),
      legend.key.width=unit(2,"line"),
      legend.key.height = unit(0.2,"cm"),
      legend.text=element_text(size=rel(0.5)),
      legend.title=element_text(size=rel(0.5)),
      # plot.title = element_text(hjust = 0, vjust = 4),
      ...
      
      
    )
}

theme_for_TMI <- function(base_size) {
  
  # theme_void(base_family="Roboto Condensed") %+replace%
  theme_void() %+replace%
    
    theme(
      legend.position = "bottom",
      plot.margin=unit(c(2,0,0,0),"mm"),
      legend.key.width=unit(1,"line"),
      legend.key.height = unit(0.2,"cm"),
      legend.text=element_text(size=rel(0.5)),
      legend.title=element_text(size=rel(0.5)),
      plot.title = element_text(hjust = 0, vjust = 4),
      strip.text = element_text(size = 6)
      # legend.key.width=unit(0.5,"cm")
      
    )
}


# base plot

baseplot <- theme_minimal() +
  theme( 
    #axis.text.y  = element_text(face="bold")
    #,axis.text.x  = element_text(face="bold")
    #,
    panel.grid.minor = element_blank()
    ,strip.text.x = element_text(size = 9, face ="bold")
    ,legend.text = element_text(size = 9)
    , axis.text = element_text(size=7)
    , axis.title = element_text(size=9)
  )





### 0) Mapa com cidades do projeto   ---------------------------------------

# get World map
worldMap <- rworldmap::getMap(resolution = "low") %>% st_as_sf() %>%
  st_transform(4326)


# load map of Brazil and municipalities
states_sf <- geobr::read_state(code_state = "all", year = 2018) %>%
  st_transform(4326)
munis_sf <- lapply(munis_list$munis_df$code_muni, geobr::read_municipality) %>% rbindlist() %>% st_sf()
munis_sf <- st_transform(munis_sf, 4326)

munis_sf <- munis_sf %>%
  left_join(munis_list$munis_df, by = "code_muni") %>%
  left_join(munis_list$munis_modo[ano_modo == 2019, .(abrev_muni, modo)], by = "abrev_muni") %>%
  # number it according to order
  arrange(desc(modo), name_muni.y) %>%
  mutate(n = 1:n()) %>%
  mutate(text = paste0(n, ".", " ", name_muni.y)) %>%
  mutate(text = ifelse(abrev_muni %in% c("bho", "rio", "rec", "goi"), paste0(text, "*"), text)) %>%
  mutate(type = ifelse(modo %in% c("todos"), 
                       "Active and Public Transport",
                       "Active Transport")) %>%
  mutate(color = ifelse(abrev_muni %in% c("todos"), 
                        "#469c77", "steelblue4"))

# get centroids of municipalities
munis_centroids <- st_centroid(munis_sf)
munis_tp_centroids <- subset(munis_centroids, 
                             abrev_muni %in% munis_list$munis_modo[ano_modo == 2019 & modo == "todos"]$abrev_muni) %>%
  mutate(modo = "todos")

munis_tp_centroids_df <- sfc_as_cols(munis_centroids)



# create sp map
sp <- ggplot()+
  geom_sf(data=worldMap, fill="white", color="gray90") +
  geom_sf(data=states_sf, fill="gray85", colour = "gray89") +
  geom_sf(data=munis_centroids, size = 3, fill="steelblue4", color="steelblue4", alpha=0.7) +
  geom_sf(data=munis_tp_centroids, size = 3, fill="#469c77", color="#469c77", alpha=0.7) +
  ggrepel::geom_text_repel(data = filter(munis_tp_centroids_df, abbrev_state == "SP"), aes(x = lon, y = lat, label = n),
                           segment.size = 3, size=2.5)+
  theme_void() +
  theme(axis.text = element_blank(), axis.ticks = element_blank(), 
        panel.grid = element_blank(), 
        panel.background=element_rect(fill = "gray98"),
        panel.border = element_rect(fill = NA))+
  coord_sf(expand = FALSE,
           xlim = c(filter(munis_tp_centroids_df, abrev_muni == "spo")$lon-1.2, 
                    filter(munis_tp_centroids_df, abrev_muni == "spo")$lon+1.2),
           ylim = c(filter(munis_tp_centroids_df, abrev_muni == "spo")$lat-0.8, 
                    filter(munis_tp_centroids_df, abrev_muni == "spo")$lat+1.2))

# create rio map
rio <- ggplot()+
  geom_sf(data=worldMap, fill="white", color="gray90") +
  geom_sf(data=states_sf, fill="gray85", colour = "gray89") +
  geom_sf(data=munis_centroids, size = 3, fill="steelblue4", color="steelblue4", alpha=0.7) +
  geom_sf(data=munis_tp_centroids, size = 3, fill="#469c77", color="#469c77", alpha=0.7) +
  ggrepel::geom_text_repel(data = filter(munis_tp_centroids_df, abbrev_state == "RJ"), aes(x = lon, y = lat, label = n),
                           segment.size = 3, size=2.5)+
  theme_void() +
  theme(axis.text = element_blank(), axis.ticks = element_blank(), 
        panel.grid = element_blank(), 
        panel.background=element_rect(fill = "gray98"),
        panel.border = element_rect(fill = NA))+
  coord_sf(expand = FALSE,
           xlim = c(filter(munis_tp_centroids_df, abrev_muni == "rio")$lon-1.2, 
                    filter(munis_tp_centroids_df, abrev_muni == "rio")$lon+1.2),
           ylim = c(filter(munis_tp_centroids_df, abrev_muni == "rio")$lat-0.5, 
                    filter(munis_tp_centroids_df, abrev_muni == "rio")$lat+1))



# create map

temp_map1 <- 
  ggplot() + 
  geom_sf(data=worldMap, fill="white", color="gray90") +
  geom_sf(data=states_sf, fill="gray85", colour = "gray89") +
  geom_sf(data=munis_centroids,    size = 3, fill="steelblue4", color="steelblue4", alpha=0.7) + # 'springgreen4' steelblue4
  geom_sf(data=munis_tp_centroids, size = 3, fill="#469c77", color="#469c77", alpha=0.7) + # 'springgreen4' steelblue4
  ggrepel::geom_text_repel(data = filter(munis_tp_centroids_df, abbrev_state %nin% c("SP", "RJ")), 
                           aes(x = lon, y = lat, label = n),
                           segment.size = 3, size=3)+
  theme(panel.background = element_rect(fill = "gray98", colour = NA),
        axis.text = element_blank(), axis.ticks = element_blank(), 
        panel.grid = element_blank()) + 
  labs(x = '', y = '')+
  coord_sf(expand = FALSE, 
           xlim = c(st_bbox(states_sf)[[1]], st_bbox(states_sf)[[3]]),
           ylim = c(st_bbox(states_sf)[[2]], st_bbox(states_sf)[[4]])) # coord_cartesian Coordinates Zoom
# guides(colour = guide_legend(override.aes = list(size=8)))

arrowA <- data.frame(x1 = 14.5, x2 = 10, 
                     y1 = 6.1,  y2 = 5) # 1: arrow!

arrowB <- data.frame(x1 = 16.9, x2 = 17.7, 
                     y1 = 6.1,  y2 = 5.3) # 1: arrow!

library(cowplot)
library(gridExtra)

t1 <- ttheme_default(core=list(
  fg_params=list(fontface=c(rep("plain", 4), "bold.italic")),
  bg_params = list(fill=c(rep(c("grey95", "grey90"),
                              length.out=4), "#6BAED6"),
                   alpha = rep(c(1,0.5), each=5))
))

tt1 <- ttheme_minimal(
  
  padding = unit(c(2, 2), "mm"),
  base_size = 8.5,
  core=list(fg_params=list(col="#469c77", hjust=0, x=0))
  
)

tt2 <- ttheme_minimal(
  
  padding = unit(c(2, 2), "mm"),
  base_size = 8.5,
  core=list(fg_params=list(col="steelblue4", hjust=0, x=0))
  
)

# textos
t1 <- textGrob("Transporte Público/Ativo e\n Carro",  gp=gpar(col="#469c77", fontsize=8, fontface = "bold"), just = c("right"))
t2 <- textGrob("Transporte Ativo e\n Carro", gp=gpar(col="steelblue4", fontsize=8, fontface = "bold"), just = c("right"))

# tabelas
table1 <- munis_tp_centroids_df %>% arrange(n) %>% filter(modo == "todos") %>% .$text
table2 <- munis_tp_centroids_df %>% arrange(n) %>% filter(modo == "ativo") %>% .$text

fim <- ggplot() +
  coord_equal(xlim = c(0, 35), ylim = c(0, 20), expand = FALSE) +
  annotation_custom(ggplotGrob(temp_map1), 
                    xmin = 0, xmax = 25, 
                    ymin = 0, ymax = 20) +
  annotation_custom(ggplotGrob(sp), 
                    xmin = 1.5, xmax = 9, 
                    ymin = 0, ymax = 9) +
  annotation_custom(t1, 
                    xmin = 21, xmax = 24,
                    ymin = 17, ymax = 18)+
  annotation_custom(t2, 
                    xmin = 21, xmax = 24,
                    ymin = 8, ymax = 9)+
  # annotation_custom(t, 
  #                   xmin = 22, xmax = 23,
  #                   ymin = 0, ymax = 12)+
  annotation_custom(gridExtra::tableGrob(table1,
                                         rows = NULL, cols = NULL, theme = tt1),
                    xmin = 19, xmax = Inf,
                    ymin = 12, ymax = 20.5)+
  annotation_custom(gridExtra::tableGrob(table2, 
                                         rows = NULL, cols = NULL, theme = tt2),
                    xmin = 19.5, xmax = Inf,
                    ymin = 0, ymax = 12.5)+
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowA, 
               arrow = arrow(length = unit(0.02, "npc")), lineend = "round")+
  annotation_custom(ggplotGrob(rio), 
                    xmin = 15, xmax = 21, 
                    ymin = 0, ymax = 5)+
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowB, 
               arrow = arrow(length = unit(0.02, "npc")), lineend = "round")+
  theme(panel.background = element_rect(fill = NA, colour = NA),
        axis.text = element_blank(), axis.ticks = element_blank(),
        plot.margin = unit(c(0,0,0,0), "cm"))+
  labs(x = "", y = "")



# save map
ggsave(fim, 
       # file="../publicacoes/2020_access_inequalities_paper/figures/fig0_munis_all_test.png", 
       file="papers/td_acessibilidade2022/map_acess_cities.png",
       dpi = 300, width = 20, height = 12, units = "cm")
