# aopdata: Data from the Access to Opportunities Project
<!-- badges: start -->
[![CRAN/METACRAN Version](https://www.r-pkg.org/badges/version/aopdata)](https://CRAN.R-project.org/package=aopdata)
[![CRAN/METACRAN Total downloads](http://cranlogs.r-pkg.org/badges/grand-total/aopdata?color=blue)](https://CRAN.R-project.org/package=aopdata)
[![Codecov test coverage](https://codecov.io/gh/ipeaGIT/aopdata/branch/main/graph/badge.svg)](https://app.codecov.io/gh/ipeaGIT/aopdata?branch=main)
[![R build status](https://github.com/ipeaGIT/aopdata/workflows/R-CMD-check/badge.svg)](https://github.com/ipeaGIT/aopdata/actions)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental) 

<!-- badges: end -->

<img align="right" src="https://github.com/ipeaGIT/aopdata/blob/main/r-package/man/figures/logo.png?raw=true" alt="logo" width="140"> 

**`aopdata`** is an R package to download data from the [Access to Opportunities Project (AOP)](https://www.ipea.gov.br/acessooportunidades/en/). The AOP is a research initiative led by the Institute for Applied Economic Research (Ipea) with the aim to study transport accessibility and inequalities in access to opportunities in Brazilian cities. 

The **`aopdata`** package brings annual estimates of access to employment, health and education services by transport mode, as well as data on the spatial distribution of population, schools and healthcare facilities at a fine spatial resolution for all cities included in the study. Data for 2019 are already available, and cover accessibility estimates by active transport modes (walking and cycling) for the 20 largest cities in the country, and by public transport for 7 major cities. For more information on the [AOP website](https://www.ipea.gov.br/acessooportunidades/en/).



## Installation R

```R
# From CRAN
  install.packages("aopdata")
  library(aopdata)
  
```

# Basic Usage

**Read *accessibility* estimates**
```R
# Just a data.frame, without spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019)

# An sf dataframe, with spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019, geometry = TRUE)

```
**Read only population and land use data**
```R
# Just a data.frame, without spatial geometry
df <- read_landuse(city = 'Fortaleza', year = 2019)

# An sf dataframe, with spatial geometry
df <- read_landuse(city = 'Fortaleza', year = 2019, geometry = TRUE)

```

**Read only the spatial grid**
```R
# Read specific city
df <- read_grid(city = 'Fortaleza')
```

For all of the functions above, note that:

- The `city` parameter can also be a 3-letter abbreviation of the city.
```R
df <- read_access(city = 'cur', mode = 'public_transport', year = 2019)
df <- read_grid(city = 'for')
```
- You may also download the data for all cities of the project at once using `city = 'all'`:
```R
all <- read_landuse(city = 'all', year = 2019)
```

-----

# Citation <img align="right" src="https://github.com/ipeaGIT/aopdata/blob/main/r-package/man/figures/ipea_logo.png?raw=true" alt="ipea" width="300">

The R package **aopdata** is developed by a team at the Institute for Applied Economic Research (Ipea), Brazil. If you use this package in research publications, please cite it as one of the publications below:

* Pereira, R. H. M., Braga, C. K. V., Serra, Bernardo, & Nadalin, V. (2019). Desigualdades socioespaciais de acesso a oportunidades nas cidades brasileiras, 2019. Texto para Discussão Ipea, 2535. Instituto de Pesquisa Econômica Aplicada (Ipea). Disponível em http://repositorio.ipea.gov.br/handle/11058/9586
* Pereira, R. H. M.; Braga, C. K. V.; Servo, L. M.; Serra, B.; Amaral, P.; Gouveia, N.; Paez, A. (2021) Geographic access to COVID-19 healthcare in Brazil using a balanced float catchment area approach. Social Science & Medicine. https://doi.org/10.1016/j.socscimed.2021.113773

