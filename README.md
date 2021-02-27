# aop: Download Data from the Access to Opportunities Project (AOP)

# geobr: Official Spatial Data Sets of Brazil 

<img align="right" src="https://github.com/ipeaGIT/aop/blob/main/r-package/man/figures/logo.png?raw=true" alt="logo" width="140"> 

R package to download data from the [Access to Opportunities Project (AOP)](https://www.ipea.gov.br/acessooportunidades/en/).


## Installation R

```R

# development version
  devtools::install_github("ipeaGIT/aop", subdir = "r-package")
  library(aop)
```



# Basic Usage

## Read accessibility estimates for a given transport mode
```R
library(aop)

# Without spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019)

# With spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019, geometry = TRUE)

cur <- read_access(city = 'cur', mode = 'public_transport', year = 2019)

```


## Read only the spatial grid
```R
library(aop)

# Read specific city
for <- read_grid(city = 'Fortaleza')
for <- read_grid(city = 'for')
```
