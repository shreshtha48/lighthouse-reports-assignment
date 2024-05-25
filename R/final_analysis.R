#further analysis for pigs
#we are plotting a graph of normalized emissions per county vs number of pig farms for the said county to analyze it futher
#filtering only to find list of farms which are intensive in nature and have pigs
pig_analysis=livestock%>% filter(livestock$SPECIES=="Porcí",livestock$PRODUCTION.SYSTEM=="Intensiu")
pig_analysis=pig_analysis%>%
  group_by(FARM.REGION) %>%
  summarize(total_nitrogen_emissions = sum(TOTAL.NITROGEN, na.rm = TRUE))

total_number=livestock%>% filter(livestock$SPECIES=="Porcí",livestock$PRODUCTION.SYSTEM=="Intensiu")
total_number=total_number%>%
  group_by(FARM.REGION)%>%
  summarize(freq = n(), .groups = "drop")

pig_analysis=full_join(pig_analysis,total_number, by='FARM.REGION')
#normalizing both the columns
pig_analysis$total_nitrogen_emissions=log(pig_analysis$total_nitrogen_emissions)
pig_analysis$freq=log(pig_analysis$freq)

ggplot(pig_analysis, aes(x = FARM.REGION)) +
  geom_bar(aes(y = freq, fill = "Frequency"), stat = "identity", position = "dodge") +
  geom_bar(aes(y = total_nitrogen_emissions, fill = "Total Nitrogen Emissions"), stat = "identity", position = "dodge") +
  scale_fill_manual(values = c("Frequency" = "lightgreen", "Total Nitrogen Emissions" = "red")) +
  labs(title = "Frequency and Total Nitrogen Emissions by Region",
       x = "Region",
       y = "Value") +
  theme_minimal() +
  theme(legend.position = "top") +
  guides(fill = guide_legend(title = "Variable"))  #

plot(pig_analysis$freq,pig_analysis$total_nitrogen_emissions)

library(tidyverse)


library(tidyverse)
pig_analysis %>%
  gather(type,value,-FARM.REGION) %>%           # reshape dataset
  ggplot(aes(FARM.REGION,value,fill=type))+
  geom_bar(position = "dodge", stat = "identity")+
  labs(title = "Number of farms and Total Nitrogen Emissions by Region for intensive livestock farms having pigs",
       x = "Region",
       y = "Value",
       fill = "Type :") +  # Add a legend title
  theme_minimal() +
  theme(legend.position = "top")
