# update metadata.csv

library(qdapRegex)
library(data.table)
library(pbapply)
library(dplyr)
library(piggyback)



######### Etapa 1 - create github release where data will be uploaded to ----------------------

usethis::edit_r_environ()
Sys.setenv(GITHUB_PAT="xxxxxxx")

# create new release
pb_new_release("ipeaGIT/aopdata", "v1.0.0")



######### Etapa 2 - list all files  ----------------------

# create empty metadata
metadata <- data.frame(matrix(ncol = 5, nrow = 0))
colnames(metadata) <- c("type","city","year","mode","download_path2")

# list all files
files = list.files("//storage1/geobr/aopdata/data", full.names = T, recursive = T)



######### Etapa 3 - upload data to github  ----------------------

# upload data
piggyback::pb_upload(files,
                     repo = "ipeaGIT/aopdata",
                     tag = "v1.0.0")



######### Etapa 4 - create/update metadata table ( geo/ano/arquivo) ----------------------

# function to update metadata
update_metadata <- function(f){
  # f <- files[1]  # access
  # f <- files[210] # grid
  # f <- files[200] # land_use
  # f <- files[250] # population

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
  if(type=='grid'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("https://www.ipea.gov.br/geobr/aopdata/data",type,city,name,sep="/")) }

  if(type=='access'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("https://www.ipea.gov.br/geobr/aopdata/data",type,city,year,mode,name,sep="/") ) }

  if(type=='land_use'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("https://www.ipea.gov.br/geobr/aopdata/data",type,city,year,name,sep="/") ) }

  if(type=='population'){ metadata[nrow(metadata) + 1,] = list(type,city,year,mode,paste("https://www.ipea.gov.br/geobr/aopdata/data",type,city,year,name,sep="/") ) }

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

# add file name
metadata[, file_name := basename(download_path2)]

# order by file_name
metadata <- unique(metadata)
metadata <- metadata[order(file_name)]
head(metadata)





######### Etapa 5 - add github url paths ----------------------

# get url to all data files on github repo release
github_liks <- pb_download_url(repo = "ipeaGIT/aopdata",
                               tag = "v1.0.0")

# ignore urls to metadata and package binaries
github_liks <- github_liks[ ! (github_liks %like% 'metadata.csv') ]
github_liks <- github_liks[ ! (github_liks %like% '.tar.gz') ]


# add url paths from github to metadata
metadata[, download_path := github_liks ]


### check if both url likns correspond to the same files
metadata[, check := basename(download_path) == basename(download_path2)]

sum(metadata$check) == nrow(metadata)
metadata$check <- NULL
metadata$file_name <- NULL

# reorder columns
setcolorder(metadata, c("type", "city", "year", "mode", "download_path", "download_path2", "name_muni"))




######### Etapa 6 - check and save metadata ----------------------

# to avoid conflict with data.table
metadata <- as.data.frame(metadata)

table(metadata$type )
table(metadata$year )
subset(metadata, type=="grid")
subset(metadata, type=="land_use")
subset(metadata, mode=="bicycle")
subset(metadata, mode=="car")
subset(metadata, mode=="public_transport")


# save updated metadata table to Ipea server
# data.table::fwrite(metadata,"//storage1/geobr/aopdata/metadata/metadata.csv")

# upload updated metadata table github
temp_dir <- tempdir()
data.table::fwrite(metadata, paste0(temp_dir,'./metadata.csv'))

piggyback::pb_upload(paste0(temp_dir,'./metadata.csv'),
                     repo = "ipeaGIT/aopdata",
                     tag = "v1.0.0")

