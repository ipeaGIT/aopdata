# update metadata.csv

library(qdapRegex)
library(data.table)
library(pbapply)
library(dplyr)

######### Etapa 1 - bases padrao ( geo/ano/arquivo) ----------------------


# create empty metadata
metadata <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(metadata) <- c("type","city","year","mode","download_path")

# list all files
files = list.files("//storage1/geobr/aopdata/data", full.names = T, recursive = T)

# function to update metadata
update_metadata <- function(f){
  # f <- files[1]  # access
  # f <- files[80] # grid
  # f <- files[100] # landuse
  # f <- files[120] # population

  # file index
  i <- qdapRegex::rm_between(f, "/", "/", extract = T)

  type <- i[1][[1]][6]
  city <- i[1][[1]][7]
  year <- i[1][[1]][8]
  mode <- i[1][[1]][9]

  # file name
  name <- strsplit(f, split = '/')[[1]]
  if (type == 'grid') { name <- name[name %like% '.gpkg']
  } else {
    name <- name[name %like% '.csv']
  }

  # update meta data table
  # grid
  if(type=='grid'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("http://www.ipea.gov.br/geobr/aopdata/data",type,city,name,sep="/")) }

  if(type=='access'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("http://www.ipea.gov.br/geobr/aopdata/data",type,city,year,mode,name,sep="/") ) }

  if(type=='landuse'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("http://www.ipea.gov.br/geobr/aopdata/data",type,city,year,name,sep="/") ) }

  if(type=='population'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("http://www.ipea.gov.br/geobr/aopdata/data",type,city,year,name,sep="/") ) }

  return(metadata)
}

metadata <- pblapply(X=files, FUN=update_metadata) %>% rbindlist()

munis_df <- dplyr::tribble(
  ~code_muni, ~abrev_muni, ~name_muni,        ~abrev_estado, ~modo_2017, ~modo_2018, ~modo_2019, ~modo_2020, ~metro_munis,
  2304400,    "for",       "Fortaleza",       "CE",          "todos",    "todos",    "todos",    "todos",    NA,
  3550308,    "spo",       "Sao Paulo",       "SP",          "todos",    "todos",    "todos",    "todos",    NA,
  3304557,    "rio",       "Rio de Janeiro",  "RJ",          "ativo",    "todos",    "todos",    "todos",    NA,
  4106902,    "cur",       "Curitiba",        "PR",          "todos",    "todos",    "todos",    "todos",    NA,
  4314902,    "poa",       "Porto Alegre",    "RS",          "todos",    "todos",    "todos",    "todos",    NA,
  3106200,    "bho",       "Belo Horizonte",  "MG",          "todos",    "todos",    "todos",    "todos",    NA,
  5300108,    "bsb",       "Brasilia",        "DF",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  2927408,    "sal",       "Salvador",        "BA",          "ativo",    "ativo",    "todos",    "todos",    NA,
  1302603,    "man",       "Manaus",          "AM",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  2611606,    "rec",       "Recife",          "PE",          "ativo",    "ativo",    "todos",    "todos",    NA,
  5208707,    "goi",       "Goiania",         "GO",          "ativo",    "ativo",    "todos",    "todos",    NA,
  1501402,    "bel",       "Belem",           "PA",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  3518800,    "gua",       "Guarulhos",       "SP",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  3509502,    "cam",       "Campinas",        "SP",          "todos",    "todos",    "todos",    "todos",    NA,
  2111300,    "slz",       "Sao Luis",        "MA",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  3304904,    "sgo",       "Sao Goncalo",     "RJ",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  2704302,    "mac",       "Maceio",          "AL",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  3301702,    "duq",       "Duque de Caxias", "RJ",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  5002704,    "cgr",       "Campo Grande",    "MS",          "ativo",    "ativo",    "ativo",    "ativo",    NA,
  2408102,    "nat",       "Natal",           "RN",          "ativo",    "ativo",    "ativo",    "ativo",    NA
) %>% setDT()

# add name muni
metadata[munis_df, on=c('city' = 'abrev_muni'), name_muni := i.name_muni]
metadata[, name_muni := tolower(name_muni) ]
head(metadata)

table(metadata$type )
table(metadata$year )
subset(metadata, type=="grid")
subset(metadata, mode=="bicycle")
subset(metadata, type=="traveltime")


# to avoid conflict with data.table
metadata <- as.data.frame(metadata)



# save updated metadata table
# data.table::fwrite(metadata,"//storage1/geobr/aopdata/metadata/metadata.csv")




subset(meta_data, type == 'grid')
