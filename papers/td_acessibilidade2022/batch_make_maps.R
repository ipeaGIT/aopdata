library(tidyverse)
dados_muni_active

dplyr::select(dados_muni_active, modo, pico)

names(dados_muni_active)
names(dados_muni_tpcar)

plot_metric <- function(data, var_name, p_muni, p_modo, p_pico) {
  # subset relevant data
  data_filtered <- subset(data, sigla_muni == p_muni & modo == p_modo & pico == p_pico)
  
  # select columns
  data_filtered <- data_filtered %>% select(id_hex, sigla_muni, ano, modo, pico, var = var_name, geometry)
  
  # make plot
  p <- ggplot() +
    geom_sf(data=muni_outline, fill='gray90', color=NA) +
    geom_sf(data=data_filtered, 
            aes(fill = var), color = NA, alpha = 0.9) +
    scale_fill_viridis_c(option="E", direction=-1) +
    labs(subtitle = sprintf("metric: %s, mode: %s", var_name, p_modo), fill = var_name) +
    theme_void()
  
  # save plot
  ggsave(plot = p, filename = here::here("maps", sprintf("%s_%s.png", var_name, p_modo)),
         dpi=300, width = 15, height = 23, units = 'cm')
  
}

# mapas transporte ativo
var_names <- names(dados_muni_active)
var_names <- var_names[6:138]

walk(var_names, plot_metric, data = dados_muni_active, p_muni = "spo", 
     p_modo = "bicicleta", p_pico = 1)
walk(var_names, plot_metric, data = dados_muni_active, p_muni = "spo", 
     p_modo = "caminhada", p_pico = 1)

# mapas transporte público e carro
var_names <- names(dados_muni_tpcar)
var_names <- var_names[6:138]

walk(var_names, plot_metric, data = dados_muni_tpcar, p_muni = "spo", 
     p_modo = "tp", p_pico = 1)
walk(var_names, plot_metric, data = dados_muni_tpcar, p_muni = "spo", 
     p_modo = "carro", p_pico = 1)

