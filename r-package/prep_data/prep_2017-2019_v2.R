library(sf)
library(geobr)
library(ggplot2)
library(furrr)
library(dplyr)
library(pbapply)
library(data.table)
library(purrr)
library(stringi)

# list all files
files <- list.files('L:/Proj_acess_oport/data/acesso_oport/output_base_final', full.names=T, recursive = T)


# save grid -------------------------------------

# select file
file_grid <- files[ files %like% 'landuse'][3]

# read data
df_grid <- readRDS(file_grid)
head(df_grid)


# rename columns
setDT(df_grid)
# data.table::setnames(df_grid, 'sigla_muni' , 'abbrev_muni')
# data.table::setnames(df_grid, 'nome_muni' , 'name_muni')
# data.table::setnames(df_grid, 'cod_muni',  'code_muni')


# select columns
spatial_df <- df_grid[, c('id_hex', 'abbrev_muni', 'name_muni', 'code_muni', 'geometry')]
spatial_df <- st_sf(spatial_df)
subset(spatial_df, id_hex != 'test')
head(spatial_df)


# fun
dir.create(path = paste0('./data/grid'), recursive = T)

save_gpkg <- function(city){ # city='bho'

  message(city)
  temp <- subset(spatial_df, abbrev_muni == city)
  temp <- setDT(temp)[order(id_hex)]
  temp <- unique(temp, by ='id_hex')
  temp <- st_sf(temp)
  temp <- subset(temp, abbrev_muni  != 'a')
  dir.create(path = paste0('./data/grid/',city), recursive = T)
  st_write(temp, paste0('./data/grid/',city,'/hex_grid_',city,'.gpkg'), overwrite=T)
}

# save
pblapply(X=unique(spatial_df$abbrev_muni), FUN=save_gpkg)

# salve all cities in one file
st_write(spatial_df, 'aop_hex_grid_v2.gpkg', overwrite=T)



# clear global environment
rm(list=ls()[! ls() %in% c("files")])
gc(full = T)


# Save population and land use -------------------------------------

# select file
file_pop_landuse <- files[ files %like% 'landuse']

save_pop_landuse <- function(f){ # f = file_pop_landuse[1]

  # read data
  df_pop_landuse <- readRDS(f)

  # rename columns and drop geometry
  setDT(df_pop_landuse)
  df_pop_landuse[, geometry := NULL ]
  # data.table::setnames(df_pop_landuse, 'sigla_muni' , 'abbrev_muni')
  # data.table::setnames(df_pop_landuse, 'nome_muni' , 'name_muni')
  # data.table::setnames(df_pop_landuse, 'ano',  'year')

  # determine year
  year <- stringi::stri_extract_last_regex(f, "\\d{4}")
  df_pop_landuse[, year := year ]
  head(df_pop_landuse)

  # sort and remove duplicates
  df_pop_landuse <- data.table::setorderv(df_pop_landuse, cols = names(df_pop_landuse))
  df_pop_landuse <- unique(df_pop_landuse, cols = names(df_pop_landuse))

  # Pop and land use columns
  columns_pop <- c('year', 'id_hex', 'abbrev_muni', 'name_muni', 'code_muni','P001','P002','P003','P004','P005','P006','P007','P010','P011','P012','P013','P014','P015','P016','R001','R002','R003')
  columns_landuse <- c('year','id_hex', 'abbrev_muni', 'name_muni', 'code_muni','T001','T002','T003','T004','E001','E002','E003','E004','M001','M002','M003','M004','S001','S002','S003','S004','C001')

  # create dirs to save the data
  dir.create(path = paste0('./data/population'))
  dir.create(path = paste0('./data/land_use'))

  # fun to save data by city an year
  save_pop_landuse_csv <- function(city){ # city='for'

    # separate pop and land use data
    temp_pop <- df_pop_landuse[ abbrev_muni  == city, ..columns_pop]
    temp_landuse <- df_pop_landuse[ abbrev_muni  == city, ..columns_landuse]

    # update pop year
    temp_pop[, year := 2010]

    # create dir
    dir.create(path = paste0('./data/population/', city, '/', 2010) ,recursive = T)
    dir.create(path = paste0('./data/land_use/', city, '/', year) ,recursive = T)

    fwrite(temp_pop, paste0('./data/population/', city, '/',2010,'/population_',2010,'_',city,'.csv'))
    fwrite(temp_landuse, paste0('./data/land_use/', city, '/',year,'/landuse_',year,'_',city,'.csv'))
  }
  lapply(X=unique(df_pop_landuse$abbrev_muni), FUN=save_pop_landuse_csv)


  # fun to save data for all cities by year
  save_each_year_csv <- function(year){ # year='2017'

    # separate pop and land use data
    temp_pop <- df_pop_landuse[ year  == year, ..columns_pop]
    temp_landuse <- df_pop_landuse[ year  == year, ..columns_landuse]

    # update pop year
    temp_pop[, year := 2010]

    fwrite(temp_pop, 'aop_population_2010_v2.csv')
    fwrite(temp_landuse, paste0('aop_landuse_', year,'_v2.csv'))
  }
  lapply(X=unique(df_pop_landuse$year), FUN=save_each_year_csv)


}


# save
pblapply(X=file_pop_landuse, FUN=save_pop_landuse)



# clear global environment
rm(list=ls()[! ls() %in% c("files")])
gc(full = T)



# Save access -------------------------------------


# select file
file_access <- files[ files %like% 'access']

save_access <- function(f){ # f = file_access[2]

  message(f)
  # read data
  df_access <- readRDS(f)

  # rename columns and drop geometry
  setDT(df_access)
  df_access[, geometry := NULL ]
  head(df_access)

  # recode transport modes
  unique(df_access$mode)
  # setDT(df_access)[, mode := fcase(mode=='bicicleta', 'bicycle',
  #                                  mode=='caminhada', 'walk',
  #                                  mode=='tp', 'public_transport',
  #                                  mode=='carro', 'car')]

  # reorder columns
  setcolorder(df_access, neworder = c('year', 'id_hex', 'abbrev_muni', 'name_muni', 'code_muni')) # 'name_muni', 'code_muni',
  head(df_access)


  # # fun to save by city
  # save_acces_csv <- function(city){ # city='for'
  #
  #   message(city)
  #   temp <- subset(df_access, abbrev_muni  == city)
  #
  #   for (i in unique(temp$mode)){ # i = 'car'
  #
  #     temp_mode <- subset(temp, mode  == i)
  #     year <- temp_mode$year[1]
  #
  #     if( i == 'car'){year=2019; temp_mode[, year := 2019] }
  #
  #     dir.create(path = paste0('./data/access/', city, '/',year,'/', i) ,recursive = T)
  #     fwrite(temp_mode, paste0('./data/access/', city, '/',year,'/', i,'/access_', year, '_',i,'_',city,'.csv'))
  #     }
  # }
  # lapply(X=unique(df_access$abbrev_muni), FUN=save_acces_csv)

  # fun to save by mode, all cities
  save_acces_year_csv <- function(mode){ # mode='public_transport'

    year <- unique(df_access$year)

    if( mode %in% c('walk', 'bicycle')){
    fwrite(df_access, paste0('aop_access_active_', year,'_v2.csv'))
    }

    if( mode == 'car'){
      temp_mode <- subset(df_access, mode  == mode)
      temp_mode[, year := 2019]
      fwrite(df_access, paste0('aop_access_car_', 2019,'_v2.csv'))
    }

    if( mode == 'public_transport'){
      temp_mode <- subset(df_access, mode  == mode)
      fwrite(df_access, paste0('aop_access_publictransport_', year,'_v2.csv'))
    }
  }
  lapply(X=unique(df_access$mode), FUN=save_acces_year_csv)

}

pblapply(X=file_access, FUN=save_access)




# dictionary -------------------------------------
dic_port <- xlsx::read.xlsx('C:/Users/user/Downloads/dicionario2019_v1.0_20200116 (2).xlsx',
                            sheetName = 'Port',startRow = 4,encoding = 'UTF-8')

head(dic_port)
