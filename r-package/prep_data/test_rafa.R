#### testing functions of aop




#library(magrittr)
library(aopdata)
library(sf)
library(dplyr)
library(data.table)
library(ggplot2)
library(mapview)

a <- read_access(city='bho',
                           mode='public_transport',
                           year=2019,
                           peak=F,
                           geometry = F,
                           showProgress = T)

read_access(city = 'Fortaleza', mode = 'walk', year = 2019, showProgress = FALSE)

for <- read_access(city = 'for', mode = 'walk', year = 2019, showProgress = FALSE)
bho <- read_access(city = 'Belo Horizonte', mode = 'walk', year = 2019)
head(bho)

g <- read_grid(city = 'bho')
head(g)

aop <- read_access(city = 'Belo Horizonte', mode = 'walk', year = 2019, geometry = T)
head(aop)

### Install package
install.packages("aop")
library(aop)

  # or use development version of aop
    # devtools::install_github("ipeaGIT/aop")


# Rafael
devtools::load_all('R:/Dropbox/git_projects/aop')
devtools::load_all('C:/Users/r1701707/Desktop/aop')



### Uninstall aop

utils::remove.packages("aop")
devtools::uninstall(pkg = "aop")





### 0. Data tests  -------------------------

data("grid_state_correspondence_table")
head(grid_state_correspondence_table)


data("brazil_2010")
head(brazil_2010)


### Test file size  ----------------

a <- aop::read_access(city='all',
                      mode = 'walk',
                      year = 2019)

a <- rbind(a,a,a,a,a,a)
library(feather)
system.time(fwrite(a, 'test.csv'))
system.time(write_feather(a, 'test.feather'))
rm(a,b)
gc(reset = T,full = T)

system.time(cc <- fread('test.csv'))
system.time(dd <- read_feather('test.feather'))



library(stringi)

stringi::stri_escape_unicode("çÇ")
666

read_access(city='são paulo', mode='walk', year=2019)




### Test examples  ----------------
library(devtools)

devtools::run_examples(pkg = ".", run = T)



### Test coverage  ----------------

# TRAVIS
#  https://travis-ci.org/ipeaGIT/aop

library(covr)
library(testthat)
library(aop)
Sys.setenv(NOT_CRAN = "true")


function_coverage(fun='download_metadata', test_file("tests/testthat/test-download_metadata.R"))

function_coverage(fun='read_schools', test_file("tests/testthat/test-read_schools.R"))
function_coverage(fun='read_neighborhood', test_file("tests/testthat/test-read_neighborhood.R"))
function_coverage(fun='read_biomes', test_file("tests/testthat/test-read_biomes.R"))
function_coverage(fun='read_region', test_file("tests/testthat/test-read_region.R"))
function_coverage(fun= 'read_amazon', test_file("tests/testthat/test-read_amazon.R"))
function_coverage(fun= 'read_semiarid', test_file("tests/testthat/test-read_semiarid.R"))
function_coverage(fun= 'read_metro_area', test_file("tests/testthat/test-read_metro_area.R"))
function_coverage(fun= 'read_conservation_units', test_file("tests/testthat/test-read_conservation_units.R"))

# create githubl shield with code coverage
  # usethis::use_coverage( type = c("codecov"))

# update Package coverage
  Sys.setenv(NOT_CRAN = "true")
  system.time(  aop_cov <- covr::package_coverage() )
  aop_cov
  beepr::beep()

  x <- as.data.frame(aop_cov)
#  covr::codecov( coverage = aop_cov, token ='e3532778-1d8d-4605-a151-2a88593e1612' )





### update package documentation ----------------
# http://r-pkgs.had.co.nz/release.html#release-check


rm(list = ls())

library(roxygen2)
library(devtools)
library(usethis)
library(testthat)
library(usethis)




setwd("C:/Users/r1701707/Desktop/git/aop")
setwd("R:/Dropbox/git/aop")
setwd("..")

# update `NEWS.md` file
# update `DESCRIPTION` file
# update ``cran-comments.md` file


# checks spelling
library(spelling)
devtools::spell_check(pkg = ".", vignettes = TRUE, use_wordlist = TRUE)

# Write package manual.pdf
  system("R CMD Rd2pdf --title=Package aop --output=./aop/manual.pdf")
  # system("R CMD Rd2pdf aop")




# Ignore these files/folders when building the package (but keep them on github)
  setwd("R:/Dropbox/git/aop")


  usethis::use_build_ignore(".travis.yml")
  usethis::use_build_ignore("prep_data")
  usethis::use_build_ignore("manual.pdf")
  usethis::use_build_ignore("README.md")
  usethis::use_build_ignore("aop_logo_b.svg")



  # script da base de dados e a propria base armazenada localmente, mas que eh muito grande para o CRAN
    usethis::use_build_ignore("brazil_2010.R")
    usethis::use_build_ignore("brazil_2010.RData")
    usethis::use_build_ignore("brazil_2010.Rd")

  # Vignette que ainda nao esta pronta
    usethis::use_build_ignore("Georeferencing-gain.R")
    usethis::use_build_ignore("Georeferencing-gain.Rmd")



### update pkgdown website ----------------
    library(aopdata)
    library(pkgdown)

# # Run once to configure your package to use pkgdown
# usethis::use_pkgdown()

# Run to build the website
pkgdown::build_site()


### CMD Check ----------------
# Check package errors

# LOCAL
Sys.setenv(NOT_CRAN = "true")
devtools::check(pkg = ".",  cran = FALSE, env_vars = c(NOT_CRAN = "true"))

Sys.setenv(NOT_CRAN = "false")
devtools::check(pkg = ".",  cran = TRUE, env_vars = c(NOT_CRAN = "false"))

devtools::check_win_release(pkg = ".")

beepr::beep()


####################################################3
a <- grid_state_correspondence_table
names(a)[2] <- 'abbrev_state'


for (col in colnames(a)){
  Encoding(a[[col]]) <- "ASCII"}


stringi::stri_encode(a$abbrev_state, from='latin1', to="ASCII")

Encoding(a$name_uf)
Encoding(a$code_state)
a
Encoding(a$name_uf) <- stringi::stri_encode(a$name_uf, from='latin1', to="ASCII")
a

stringi::stri_encode(a$, from='latin1', to="ASCII")
Encoding(a$name_uf)

save
Encoding(a$name_uf) <- "ASCII"

grid_state_correspondence_table <- a

save(grid_state_correspondence_table, file='grid_state_correspondence_table.RData', ascii = T)


load(file='grid_state_correspondence_table.RData')
Encoding(grid_state_correspondence_table$name_uf)
Encoding(grid_state_correspondence_table$name_uf) <- "ASCII"
grid_state_correspondence_table

# build binary --------------------------------

 system("R CMD build . --resave-data") # build tar.gz
 # devtools::build(pkg = ".", binary = T, manual=T) # build .zip



