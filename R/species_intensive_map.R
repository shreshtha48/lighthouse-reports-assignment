ivestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ <- format(as.Date(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ, "%d/%m/%y"))
livestock$year<- ifelse(is.na(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ), NA, substr(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ, 1, 4))

#filtering to see only for intensive systems
pig_growth <- livestock %>%
  filter(SPECIES %in% c("Porcí", "Èquid", "Boví", "Oví", "Gallines i pollastres")) %>%
  group_by(year, SPECIES) %>%
  summarize(freq = n(), .groups = "drop")

#removing null values
pig_growth=na.omit(pig_growth)

#going to plot the actual data
colors <- brewer.pal(n = length(unique(pig_growth$SPECIES)), name = "Set1")
ggplot(pig_growth, aes(x = as.factor(year), y = freq, fill = SPECIES)) +
  scale_fill_manual(values = colors)+
  geom_bar(stat = "identity") +
  labs(title = "A closer look at intensive farms over the years",
       subtitle="for the top 5 species by count",
       x = "Year",
       y = "Number of farms",) +
  theme_linedraw() +theme(legend.position = "top", axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(fill = guide_legend(title = "SPECIES", ncol = 2, byrow = TRUE))# Rotate x-axis labels by 45 degrees # Position legend at the top
