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

# remove old version
files <- files[ !(files %like% '2019_old')]





# save grid -------------------------------------

# select file
file_grid <- files[ files %like% 'landuse'][3]

# read data
df_grid <- readRDS(file = file_grid)
head(df_grid)

# rename columns
setDT(df_grid)
data.table::setnames(df_grid, 'sigla_muni' , 'abbrev_muni')
data.table::setnames(df_grid, 'nome_muni' , 'name_muni')
# data.table::setnames(df_grid, 'cod_muni',  'code_muni')


# select columns
spatial_df <- df_grid[, c('abbrev_muni', 'name_muni', 'code_muni', 'id_hex', 'geometry')]
spatial_df <- st_sf(spatial_df)
subset(spatial_df, id_hex != 'test')
head(spatial_df)

# fun
dir.create(path = paste0('./data/grid'), recursive = T)

save_gpkg <- function(city){ # city='bho'

  message(city)
  temp <- subset(spatial_df, abbrev_muni  == city)
  temp <- setDT(temp)[order(id_hex)]
  temp <- unique(temp, by ='id_hex')
  temp <- st_sf(temp)
  temp <- subset(temp, abbrev_muni  != 'a')
  dir.create(path = paste0('./data/grid/',city), recursive = T)
  st_write(temp, paste0('./data/grid/',city,'/hex_grid_',city,'.gpkg'), overwrite=T)
}

# save
pblapply(X=unique(spatial_df$abbrev_muni), FUN=save_gpkg)







# Save population and land use -------------------------------------

# select file
file_pop_landuse <- files[ files %like% 'landuse']

save_pop_landuse <- function(f){ # f = file_pop_landuse[1]

  # read data
  df_pop_landuse <- readRDS(f)

  # rename columns and drop geometry
  setDT(df_pop_landuse)
  df_pop_landuse[, geometry := NULL ]
  data.table::setnames(df_pop_landuse, 'sigla_muni' , 'abbrev_muni')
  data.table::setnames(df_pop_landuse, 'nome_muni' , 'name_muni')
  # data.table::setnames(df_pop_landuse, 'ano',  'year')

  # determine year
  year <- stringi::stri_extract_last_regex(f, "\\d{4}")
  df_pop_landuse[, year := year ]
  head(df_pop_landuse)

  # sort and remove duplicates
  df_pop_landuse <- data.table::setorderv(df_pop_landuse, cols = names(df_pop_landuse))
  df_pop_landuse <- unique(df_pop_landuse, cols = names(df_pop_landuse))

  # Pop and land use columns
  columns_pop <- c('year','abbrev_muni','name_muni','code_muni','id_hex','P001','P002','P003','P004','P005','P006','P007','P010','P011','P012','P013','P014','P015','P016','R001','R002','R003')
  columns_landuse <- c('year','abbrev_muni','name_muni','code_muni','id_hex','T001','T002','T003','T004','E001','E002','E003','E004','M001','M002','M003','M004','S001','S002','S003','S004','C001')


  # fun
  dir.create(path = paste0('./data/population'))
  dir.create(path = paste0('./data/land_use'))

  save_pop_landuse_csv <- function(city){ # city='for'

    # separate pop and land use data
    temp_pop <- df_pop_landuse[ abbrev_muni  == city, ..columns_pop]
    temp_landuse <- df_pop_landuse[ abbrev_muni  == city, ..columns_landuse]

    # create dir
    dir.create(path = paste0('./data/population/', city, '/', 2010) ,recursive = T)
    dir.create(path = paste0('./data/land_use/', city, '/', year) ,recursive = T)

    fwrite(temp_pop, paste0('./data/population/', city, '/',2010,'/population_',2010,'_',city,'.csv'))
    fwrite(temp_landuse, paste0('./data/land_use/', city, '/',year,'/landuse_',year,'_',city,'.csv'))
  }

  lapply(X=unique(df_pop_landuse$abbrev_muni), FUN=save_pop_landuse_csv)

}


# save
pblapply(X=file_pop_landuse, FUN=save_pop_landuse)





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
  data.table::setnames(df_access, 'sigla_muni' , 'abbrev_muni')
  data.table::setnames(df_access, 'nome_muni' , 'name_muni')
  data.table::setnames(df_access, 'modo',  'mode')
  data.table::setnames(df_access, 'pico',  'peak')
  data.table::setnames(df_access, 'ano',  'year')
  head(df_access)

  # recode transport modes
  unique(df_access$mode)
  setDT(df_access)[, mode := fcase(mode=='bicicleta', 'bicycle',
                                   mode=='caminhada', 'walk',
                                   mode=='tp', 'public_transport',
                                   mode=='carro', 'car')]

  # reorder columns
  setcolorder(df_access, neworder = c('year', 'abbrev_muni', 'id_hex')) # 'name_muni', 'code_muni',
  head(df_access)


  # fun
  save_acces_csv <- function(city){ # city='for'

    message(city)
    temp <- subset(df_access, abbrev_muni  == city)

    for (i in unique(temp$mode)){ # i = 'car'

      temp_mode <- subset(temp, mode  == i)
      year <- temp_mode$year[1]

      dir.create(path = paste0('./data/access/', city, '/',year,'/', i) ,recursive = T)
      fwrite(temp_mode, paste0('./data/access/', city, '/',year,'/', i,'/access_', year, '_',i,'_',city,'.csv'))
      }
  }


lapply(X=unique(df_access$abbrev_muni), FUN=save_acces_csv)


}

pblapply(X=file_access, FUN=save_access)




# dictionary -------------------------------------
dic_port <- xlsx::read.xlsx('C:/Users/user/Downloads/dicionario2019_v1.0_20200116 (2).xlsx',
                            sheetName = 'Port',startRow = 4,encoding = 'UTF-8')

head(dic_port)
