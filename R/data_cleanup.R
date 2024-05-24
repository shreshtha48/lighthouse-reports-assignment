#this script is used to clean up the data provided in the mail
#since spanish is not my first language and to gain more context on the data, I used google to translate the column names
#loading all the required libraries
library(dplyr)

#loading the data
livestock=read.csv("/home/shreshtha/Downloads/RER_llistat_explotacions_catalanes (1).csv")
#looking at the column names
names(livestock)

#subsetting the dataframe based on columns
data=select(livestock,OPERATING.STATUS,FARM.PROVINCE,FARM.MUNICIPALTY,FARM.ADDRESS,FARM.REGION,FARM.COUNTY,
            FARM.X.COORDINATE,FARM.Y.COORDINATE,FARM.LATITUDE,FARM.LONGITUDE,SPECIES,SUBSPECIES,DATA.CANVI.ESTAT.SUBEXPLOTACIÓ,ADS.NAME,INTEGRATOR,BREEDING.FORM,PRODUCTION.CAPACITY,ZOOTECHNICAL.CLASSIFICATION,TOTAL.NITROGEN,FARM.NAME,DATE.OF.CHANGE.OF.STATUS)
#saving the data for future use
#the original dataframe
usethis::use_data(livestock,compress = "xz",overwrite = TRUE)
#saving the modified dataframe
usethis::use_data(data, compress="xz",overwrite=TRUE)
