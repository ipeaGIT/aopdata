
###### get all data sets on github ----------------------------------
library(piggyback)
library(data.table)




# upload data
pb_upload(files,
          repo = "ipeaGIT/aopdata",
          tag = "v1.0.0")



# get url to all data files
github_liks <- pb_download_url(
                repo = "ipeaGIT/aopdata",
                tag = "v1.0.0")



