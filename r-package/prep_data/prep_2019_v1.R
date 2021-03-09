
library(sf)
library(geobr)
library(ggplot2)
library(furrr)
library(dplyr)
library(pbapply)
library(data.table)
library(purrr)

# read data -------------------------------------
df <- readr::read_rds('\\\\storage1\\geobr\\aopdata\\dados2019_v1.0_20200116.rds')
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
  save_gpkg <- function(city){ # city='bho'
    temp <- subset(spatial_df, abbrev_muni  == city)
    temp <- setDT(temp)[order(id_hex)]
    temp <- unique(temp, by ='id_hex')
    temp <- st_sf(temp)
    dir.create(path = paste0('./grid/',city),recursive = T)
    st_write(temp, paste0('./grid/',city,'/hex_grid_',city,'.gpkg'), overwrite=T)
  }

  # save
  pblapply(X=unique(spatial_df$abbrev_muni), FUN=save_gpkg)







### save population data -------------------------------------

  # drop spatial data
  df$geometry <- NULL
  head(df)

  # keep only hexagons with any activity
  df <- subset(df, P001 > 0 | S001 > 0 | E001 > 0 | S001 > 0)
  df <- data.table::setorderv(df, cols = names(df))

  # subset columns
  cols_population <- names(df)[1:12]
  df_population <- select(df, cols_population)
  head(df_population)

  # sort and remove duplicates
  df_population <- data.table::setorderv(df_population, cols = names(df_population))
  df_population <- unique(df_population, cols = names(df_population))


  # fun
  dir.create(path = paste0('./population'))
  save_population <- function(city){ # city='for'
    temp <- subset(df_population, abbrev_muni  == city)
    dir.create(path = paste0('./population/', city, '/2010') ,recursive = T)
    setorderv(temp, cols = names(temp))
    fwrite(temp, paste0('./population/', city, '/2010/population_2010_',city,'.csv'))
  }

  pblapply(X=unique(df$abbrev_muni), FUN=save_population)





# save landuse -------------------------------------

  # subset columns
  cols_landuse <- names(df)[c(1,2,3,4,13:20)]
  df_landuse <- select(df, cols_landuse)

  # fun
  dir.create(path = paste0('./landuse'))
  save_landuse <- function(city){ # city='for'
    temp <- subset(df_landuse, abbrev_muni  == city)
    temp <- unique(temp, by ='id_hex')
    dir.create(path = paste0('./landuse/', city, '/2019') ,recursive = T)
    setorderv(temp, cols = names(temp))
    fwrite(temp, paste0('./landuse/', city, '/2019/landuse_2019_',city,'.csv'))
  }

  pblapply(X=unique(df$abbrev_muni), FUN=save_landuse)


# save access data  -------------------------------------

  # subset columns
  cols_access <- names(df)[c(1:4,21:96)]
  df_access <- select(df, cols_access)

# fun
dir.create(path = paste0('./access'))
save_acces <- function(city, mmode){ # city='for'; mmode='public_transport'
  temp <- subset(df_access, abbrev_muni  == city)
  temp <- subset(temp, mode  == mmode)
  temp <- unique(temp, by =c('id_hex', 'peak'))
  dir.create(path = paste0('./access/', city, '/2019/', mmode) ,recursive = T)
  setorderv(temp, cols = names(temp))
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
