library(aopdata)
library(data.table)
library(dplyr)

df <- lapply(X=c(2017, 2018, 2019), 
             FUN = function(i){
               temp <- read_landuse(city='all', year=i)
               return(temp)
             }
) |> rbindlist()



hex_summary <- df %>%
  select(id_hex, name_muni, year,
         # P001, pop_homens, pop_mulheres,
         # starts_with("cor_"),
         # starts_with("idade_"),
         starts_with("T001"),
         starts_with("S001"),
         starts_with("E001")) %>%
         # starts_with("mat_"),
         # starts_with("cras_")) 
  tidyr::pivot_longer(cols = T001:E001, names_to = "var", values_to = "values")


# refactor

hex_summary1 <- hex_summary %>%
  mutate(values = round(values)) %>%
  group_by(name_muni, year, var) %>%
  summarise(sum = sum(values, na.rm = TRUE)) %>%
  ungroup()

hex_summary1 <- hex_summary1 %>%
  tidyr::pivot_wider(names_from = year, values_from = "sum")



# tables with summaries
hex_summary_jobs <- hex_summary1 %>%
  filter(var == "T001") %>%
  arrange(across(starts_with("2017"), desc))

hex_summary_health <- hex_summary1 %>%
  filter(var == "S001") %>%
  arrange(across(starts_with("2017"), desc))

hex_summary_schools <- hex_summary1 %>%
  filter(var == "E001") %>%
  arrange(across(starts_with("2017"), desc))
