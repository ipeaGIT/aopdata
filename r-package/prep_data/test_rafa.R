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

aop_data19 <- aopdata::read_access(city = "all", mode = "public_transport", year = 2019, geometry = TRUE)
aop_data18 <- aopdata::read_access(city = "all", mode = "public_transport", year = 2018, geometry = TRUE)
aop_data17 <- aopdata::read_access(city = "all", mode = "public_transport", year = 2017, geometry = TRUE)


aopdata::read_access(city = c('rio', 'bho', 'rec'))

a <- read_access(city = 'Fortaleza', mode = 'walk', year = 2019, showProgress = FALSE)
a <- read_access(city = c('Fortaleza', 'rio de janeiro'), mode = 'public_transport', year = 2017, showProgress = T)
head(a)
unique(a$name_muni)
table(a$abbrev_muni)
table(a$mode)








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

b <- aopdata::read_access(city='for',
                      mode = 'walk',
                      peak=F)

table(b$peak)

a <- rbind(a,a,a,a,a,a)
library(feather)
system.time(fwrite(a, 'test.csv'))
system.time(write_feather(a, 'test.feather'))
rm(a,b)
gc(reset = T,full = T)

system.time(cc <- fread('test.csv'))
system.time(dd <- read_feather('test.feather'))



library(aopdata)


a <- read_access(city='são paulo', mode='public_transport', year=2019)
table(a$name_muni)
table(a$mode)

system.time(read_access(city='po', geometry = T,year =2019))

system.time(a <- read_access(city=c('spo', 'nat'), geometry = T,year =2019))
table(a$name_muni)
table(a$mode)

system.time(a <- read_access(city=c('rec', 'bho'), mode='public_transport', geometry = T,year =2019))
table(a$name_muni)
table(a$mode)

system.time(a <- read_access(city=c('rec', 'nat'), mode='public_transport', geometry = F,year =2019))
table(a$name_muni)
table(a$mode)


### fun remove accents  ----------------


#' Remove accents from string
#'
#' @description Removes non-ASCII characters from a string.
#'
#' @param str A string
#' @param pattern A pattern
#'
#' @return Returns a string with non-ASCII characters replaced with "\'uxxxx" escapes
#'
#' @export
#' @family support functions
#'
rm_accent <- function(str, pattern="all") {
  if(!is.character(str))
    str <- as.character(str)
  pattern <- unique(pattern)
  if(any(pattern=="\u00c7")) # "Ç"
    pattern[pattern=="\u00c7"] <- "\u00e7" # "Ç"] <- "ç"
  symbols <- c(
    acute = "\u00e1\u00e9\u00ed\u00f3\u00fa\u00c1\u00c9\u00cd\u00d3\u00da\u00fd\u00dd", # "áéíóúÁÉÍÓÚýÝ",
    grave = "\u00e0\u00e8\u00ec\u00f2\u00f9\u00c0\u00c8\u00cc\u00d2\u00d9", # "àèìòùÀÈÌÒÙ",
    circunflex = "\u00e2\u00ea\u00ee\u00f4\u00fb\u00c2\u00ca\u00ce\u00d4\u00db", # "âêîôûÂÊÎÔÛ",
    tilde = "\u00e3\u00f5\u00c3\u00d5\u00f1\u00d1", # "ãõÃÕñÑ",
    umlaut = "\u00e4\u00eb\u00ef\u00f6\u00fc\u00c4\u00cb\u00cf\u00d6\u00dc\u00ff", # "äëïöüÄËÏÖÜÿ",
    cedil = "\u00e7\u00c7" # "çÇ"
  )
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  accentTypes <- c("\u00b4", "`", "^", "~", "\u00a8", "\u00e7") # c("´","`","^","~","¨","ç")
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern)) # opcao retirar todos
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str)
  return(str)
}




### Test coverage  ----------------

# TRAVIS
#  https://travis-ci.org/ipeaGIT/aop

library(covr)
library(testthat)
library(aopdata)
Sys.setenv(NOT_CRAN = "true")

function_coverage(fun='read_grid', test_file("tests/testthat/test_read_grid.R"))
function_coverage(fun='read_landuse', test_file("tests/testthat/test_read_landuse.R"))
function_coverage(fun='read_population', test_file("tests/testthat/test_read_population.R"))
function_coverage(fun='read_access', test_file("tests/testthat/test_read_access.R"))

function_coverage(fun='check_connection', test_file("tests/testthat/test_check_connection.R"))



# update Package coverage
  Sys.setenv(NOT_CRAN = "true")
  system.time(  aop_cov <- covr::package_coverage() )
  aop_cov
  beepr::beep()

#  covr::codecov( coverage = aop_cov, token ='f09e3b22-d365-4239-8dd3-55a6c921d31b' )





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

# CRAN
Sys.setenv(NOT_CRAN = "false")
devtools::check(pkg = ".",  cran = TRUE, env_vars = c(NOT_CRAN = "false"))

devtools::check_win_release(pkg = ".")
devtools::check_win_devel(pkg = ".")

beepr::beep()


devtools::build_vignettes()

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


library(aopdata)

url_ok <- 'http://google.com/'
url_timeout <- 'http://www.google.com:81/'
url_error <- 'http://httpbin.org/status/300'

test1 <- function(x, url){

  check_con <- aopdata::check_connection(url)
  if(is.null(check_con) | isFALSE(check_con)){ return(invisible(NULL)) }

  x <- x+2
  return(x)
}

# this should work and return output.
test(2, url_ok )

# these should NOT work and return a message.
test(2, url_timeout )
test(2, url_error )


library(aopdata)
d <- read_population(city = 'bel', year = 2010, geometry = F, showProgress = T)
d <- read_landuse(city = 'bel',  geometry = F, showProgress = T)
d <- read_access(city = 'bel',  geometry = F, showProgress = T)

d <- read_grid(city = c('bel','bho'), showProgress=T)


inception <- function(url){

  check_con <- aopdata::check_connection(url)
  if(is.null(check_con) | isFALSE(check_con)){ return(invisible(NULL)) }

}

test2 <- function(x, url){

a <- inception(url)
  x <- x+2
  return(x)
}

inception(url_ok)

test2(2, url_ok )
test2(2, url_timeout )
test2(2, url_error )


df <- read_access(city=c('all'),
                  mode='public_transport',
                  peak = TRUE,
                  year=2019,
                  showProgress = T)

read_population(city=c('all'))
read_grid(city='poa')
read_landuse(city=c('poa'))
