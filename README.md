# aopdata: Data from the Access to Opportunities Project
<!-- badges: start -->
[![CRAN/METACRAN Version](https://www.r-pkg.org/badges/version/aopdata)](https://CRAN.R-project.org/package=aopdata)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

<img align="right" src="https://github.com/ipeaGIT/aopdata/blob/main/r-package/man/figures/logo.png?raw=true" alt="logo" width="140"> 

**`aopdata`** is an R package to download data from the [Access to Opportunities Project (AOP)](https://www.ipea.gov.br/acessooportunidades/en/). The AOP is a research initiative led by the Institute for Applied Economic Research (Ipea) with the aim to study transport accessibility and inequalities in access to opportunities in Brazilian cities. 

The **`aopdata`** package brings annual estimates of access to employment, health and education services by transport mode, as well as data on the spatial distribution of population, schools and healthcare facilities at a fine spatial resolution for all cities included in the study. Data for 2019 are already available, and cover accessibility estimates by active transport modes (walking and cycling) for the 20 largest cities in the country, and by public transport for 7 major cities. For more information on the [AOP website](https://www.ipea.gov.br/acessooportunidades/en/).



## Installation R

```R

# development version
  devtools::install_github("ipeaGIT/aopdata", subdir = "r-package")
  library(aopdata)
```



# Basic Usage

**Read accessibility estimates for a given transport mode**
```R
library(aopdata)

# Just a data.frame, without spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019)

# An df dataframe, with spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019, geometry = TRUE)

```
One can also download the data for all cities of thee project at once:
```R
all <- read_access(city = 'all', mode = 'walk', year = 2019)
```

**Read only the spatial grid**
```R
# Read specific city
for <- read_grid(city = 'Fortaleza')
```

Note that the `city` parameter can also be a 3-letter abbreviation of the city.
```R
cur <- read_access(city = 'cur', mode = 'public_transport', year = 2019)
for <- read_grid(city = 'for')
```


-----

# Citation <img align="right" src="https://github.com/ipeaGIT/aopdata/blob/main/r-package/man/figures/ipea_logo.png?raw=true" alt="ipea" width="300">

The R package **aopdata** is developed by a team at the Institute for Applied Economic Research (Ipea), Brazil. If you use this package in research publications, we please cite it as one of the publications below:

* Pereira, R. H. M., Braga, C. K. V., Serra, Bernardo, & Nadalin, V. (2019). Desigualdades socioespaciais de acesso a oportunidades nas cidades brasileiras, 2019. Texto para Discussão Ipea, 2535. Instituto de Pesquisa Econômica Aplicada (Ipea). Disponível em http://repositorio.ipea.gov.br/handle/11058/9586
* Pereira, R. H. M.; Braga, C. K. V.; Servo, L. M.; Serra, B.; Amaral, P.; Gouveia, N.; Paez, A. (2021) Geographic access to COVID-19 healthcare in Brazil using a balanced float catchment area approach. Social Science & Medicine. https://doi.org/10.1016/j.socscimed.2021.113773

