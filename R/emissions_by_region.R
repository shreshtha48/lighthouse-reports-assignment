library(dplyr)
nitrogen_emissions=livestock %>%
  group_by(FARM.REGION,PRODUCTION.SYSTEM) %>%
  summarize(total_nitrogen_emissions = sum(TOTAL.NITROGEN, na.rm = TRUE))
nitrogen_emissions[nitrogen_emissions == ""] <- NA

nitrogen_emissions=na.omit(nitrogen_emissions)

nitrogen_emissions <- nitrogen_emissions %>%
  filter(PRODUCTION.SYSTEM != "No")


library(tidyverse)
library(ggplot2)
library(tidyverse)

# Assuming nitrogen_emissions is your dataframe with columns 'FARM.REGION', 'PRODUCTION.SYSTEM', 'total_nitrogen_emissions', and 'freq'

# Reshape the dataset to long format
library(RColorBrewer)
colors <- brewer.pal(n = length(unique(nitrogen_emissions$PRODUCTION.SYSTEM)), name = "Set1")
ggplot(nitrogen_emissions, aes(x = as.factor(FARM.REGION), y = total_nitrogen_emissions, fill = PRODUCTION.SYSTEM)) +
  scale_fill_manual(values = colors)+
  geom_bar(stat = "identity") +
  labs(title = "Emissions by region",
       x = "region",
       y = "emissions by farms",) +
  theme_linedraw() +theme(legend.position = "top", axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(axis.text.y = element_blank())+
  guides(fill = guide_legend(title = "type of farm", ncol = 2, byrow = TRUE))# Rotate x-axis labels by 45 degrees # Position legend at the top
