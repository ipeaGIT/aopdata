library(piggyback)
library(data.table)

usethis::edit_r_environ()
Sys.setenv(GITHUB_PAT="xxxxxxx")

# create new release
pb_new_release("ipeaGIT/aopdata", "v0.2.4")


# upload data
data("mtcars")
head(mtcars)

fwrite(mtcars, 'mtcars.csv')
fwrite(mtcars, 'mtcars2.csv')
fwrite(mtcars, 'mtcars3.csv')

files <- list.files(pattern = '.csv')
pb_upload(files,
          repo = "ipeaGIT/aopdata",
          tag = "v0.2.4")



# get url to download the data
df <- pb_download_url("mtcars2.csv",
                repo = "ipeaGIT/aopdata",
                tag = "v0.2.4")
fread(df)
fread(df)



a <- aopdata:::download_metadata()

