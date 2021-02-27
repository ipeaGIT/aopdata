# aopdata: Download Data from the Access to Opportunities Project (AOP)

<img align="right" src="https://github.com/ipeaGIT/aopdata/blob/main/r-package/man/figures/logo.png?raw=true" alt="logo" width="140"> 

R package to download data from the [Access to Opportunities Project (AOP)](https://www.ipea.gov.br/acessooportunidades/en/).


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

# Without spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019)

# With spatial geometry
cur <- read_access(city = 'Curitiba', mode = 'walk', year = 2019, geometry = TRUE)


```


**Read only the spatial grid**
```R
library(aopdata)

# Read specific city
for <- read_grid(city = 'Fortaleza')
```

Note that the `city` parameter can also be a 3-letter abbreviation of the city.
```R
cur <- read_access(city = 'cur', mode = 'public_transport', year = 2019)
for <- read_grid(city = 'for')
```


-----

# Citation <img align="right" src="r-package/man/figures/ipea_logo.png" alt="ipea" width="300">

The R package **aopdata** is developed by a team at the Institute for Applied Economic Research (Ipea), Brazil. If you use this package in research publications, we please cite it as one of the publications below:

* Pereira, R. H. M., Braga, C. K. V., Serra, Bernardo, & Nadalin, V. (2019). Desigualdades socioespaciais de acesso a oportunidades nas cidades brasileiras, 2019. Texto para Discussão Ipea, 2535. Instituto de Pesquisa Econômica Aplicada (Ipea). Disponível em http://repositorio.ipea.gov.br/handle/11058/9586
* Pereira, R. H. M.; Braga, C. K. V.; Servo, L. M.; Serra, B.; Amaral, P.; Gouveia, N.; Paez, A. (2021) Geographic access to COVID-19 healthcare in Brazil using a balanced float catchment area approach. Social Science & Medicine. https://doi.org/10.1016/j.socscimed.2021.113773

