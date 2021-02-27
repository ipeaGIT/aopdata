
library(sf)
library(geobr)
library(ggplot2)
library(furrr)
library(dplyr)
library(pbapply)
library(data.table)
library(purrr)

# read data -------------------------------------
df <- readr::read_rds('\\\\storage1\\geobr\\aop\\data\\dados2019_v1.0_20200116.rds')
head(df)

# rename columns
setDT(df)
data.table::setnames(df, 'sigla_muni' , 'abbrev_muni')
data.table::setnames(df, 'nome_muni' , 'name_muni')
data.table::setnames(df, 'cod_muni',  'code_muni')
data.table::setnames(df, 'modo',  'mode')
data.table::setnames(df, 'pico',  'peak')

# recode transport modes
unique(df$mode)
setDT(df)[, mode := fcase(mode=='bicicleta', 'bicycle',
                     mode=='caminhada', 'walk',
                     mode=='tp', 'public_transport')]

# reorder
setorderv(df, cols = c('abbrev_muni', 'name_muni', 'code_muni', 'id_hex'))

# save grid -------------------------------------

  # select columns
  spatial_df <- select(df, c('abbrev_muni', 'name_muni', 'code_muni', 'id_hex', 'geometry'))
  spatial_df <- st_sf(spatial_df)
  head(spatial_df)

  # fun
  dir.create(path = paste0('./grid'))
  save_gpkg <- function(city){ # city='for'
    temp <- subset(spatial_df, abbrev_muni  == city)
    dir.create(path = paste0('./grid/',city),recursive = T)
    st_write(temp, paste0('./grid/',city,'/hex_grid_',city,'.gpkg'), overwrite=T)
  }

  # save
  pblapply(X=unique(spatial_df$abbrev_muni), FUN=save_gpkg)


# save access data  -------------------------------------

# drop spatial data
df$geometry <- NULL
head(df)

# fun
dir.create(path = paste0('./access'))
save_acces <- function(city, mmode){ # city='for'; mmode='walk'
  temp <- subset(df, abbrev_muni  == city)
  temp <- subset(temp, mode  == mmode)
  dir.create(path = paste0('./access/', city, '/2019/', mmode) ,recursive = T)
  setorderv(df, cols = names(df))
  fwrite(temp, paste0('./access/', city, '/2019/', mmode,'/access_2019_',city,'.csv'))
}

combinations <- CJ(unique(df$abbrev_muni), unique(df$mode), unique=RT) %>% na.omit()

purrr::walk2(.x = combinations$V1,
             .y = combinations$V2,
             .f = save_acces
             )




# dictionary -------------------------------------
dic_port <- xlsx::read.xlsx('C:/Users/user/Downloads/dicionario2019_v1.0_20200116 (2).xlsx',
                            sheetName = 'Port',startRow = 4,encoding = 'UTF-8')

head(dic_port)
