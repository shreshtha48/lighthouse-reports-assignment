library(sf)
library(sp)
library(dplyr)
library(tidyverse)
#data analysis for pig farms
#SECTION 1 cleanup
#reading the shapefile
shp=read_sf("/home/shreshtha/Downloads/shapefiles_catalunya_comarcas/shapefiles_catalunya_comarcas.shp")
#filtering only to find list of farms which are intensive in nature and have pigs
pig_livestock=livestock%>% filter(livestock$SPECIES=="Porcí",livestock$PRODUCTION.SYSTEM=="Intensiu")
#sub-setting the data frame to only contain the relevant columns

pig_livestock <- pig_livestock[c("FARM.LATITUDE","FARM.LONGITUDE","FARM.X.COORDINATE", "FARM.Y.COORDINATE", "FARM.POSTAL.CODE", "FARM.ADDRESS", "FARM.REGION", "FARM.PROVINCE", "FARM.COUNTY", "FARM.MUNICIPALTY","TOTAL.NITROGEN")]

#replacing blank spaces with NA and removing the missing values
pig_livestock[pig_livestock == ""] <- NA
pig_livestock=pig_livestock %>% drop_na("FARM.LATITUDE","FARM.LONGITUDE","FARM.X.COORDINATE","FARM.Y.COORDINATE")

#the data frame contains columns for x and y coordinates but we have commas so we replace them with point
pig_livestock$FARM.X.COORDINATE <- gsub(",", ".", pig_livestock$FARM.X.COORDINATE)
pig_livestock$FARM.Y.COORDINATE <- gsub(",", ".", pig_livestock$FARM.Y.COORDINATE)

#converting the data frame to an sf object for smoother data analysis

pig_livestock_sf <- st_as_sf(pig_livestock,
                             coords = c("FARM.X.COORDINATE", "FARM.Y.COORDINATE"),
                             crs = 23031

)

#getting the shapefiles and reading them
ordered=pig_livestock %>% group_by(pig_livestock$FARM.COUNTY) %>%
  summarize(freq=n()) %>%
  arrange(desc(freq))

#rename the file to join with shp obj

# Rename the column
ordered <- ordered %>%
  rename(nom_comar = `pig_livestock$FARM.COUNTY`)
#perform a full outer join
combined_sf <- full_join(shp, ordered, by = "nom_comar")


#plotting the results for total number of intensive farms per county
ggplot(data = combined_sf) +
  geom_sf(aes(fill = freq))  +
  scale_fill_gradient(low="lightyellow",high="red",na.value="white",name="Farms") +  # Use a color scale, e.g., viridis
  labs(title = "farms per county",
       subtitle="Number of intensive farms containing pigs",
       fill = "freq")+
  theme_gray()




