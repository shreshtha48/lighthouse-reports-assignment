library(lubridate)
library(ggplot2)
library(RColorBrewer)
library(dplyr)

#extracting the date into a seprate column
livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ <- format(as.Date(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ, "%d/%m/%y"))
livestock$year<- ifelse(is.na(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ), NA, substr(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ, 1, 4))

#filtering to see only for intensive systems
intensive=livestock%>%
  filter(PRODUCTION.SYSTEM =="Intensiu") %>%
  group_by(year,FARM.REGION) %>%
  summarize(freq=n()) %>%
  arrange(desc(freq))
#removing null values
intensive=na.omit(intensive)

#going to plot the actual data
colors <- brewer.pal(n = length(unique(intensive$FARM.REGION)), name = "Set1")
ggplot(intensive, aes(x = as.factor(year), y = freq, fill = FARM.REGION)) +
  scale_fill_manual(values = colors)+
  geom_bar(stat = "identity") +
  labs(title = "A closer look at intensive farms over the years",
       x = "Year",
       y = "Number of farms",) +
  theme_linedraw() +theme(legend.position = "top", axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(fill = guide_legend(title = "Region", ncol = 2, byrow = TRUE))# Rotate x-axis labels by 45 degrees # Position legend at the top
