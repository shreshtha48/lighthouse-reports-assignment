#extracting the date into a seprate column
livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ <- format(as.Date(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ, "%d/%m/%y"))
livestock$year<- ifelse(is.na(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ), NA, substr(livestock$DATA.CANVI.ESTAT.SUBEXPLOTACIÓ, 1, 4))

#filtering to see only for intensive systems
subtype=livestock%>%
  filter(PRODUCTION.SYSTEM =="Intensiu") %>%
  group_by(year,SUBTYPE.OF.FARM) %>%
  summarize(freq=n()) %>%
  arrange(desc(freq))
#removing null values
subtype=na.omit(subtype)

#going to plot the actual data
colors <- brewer.pal(n = length(unique(subtype$SUBTYPE.OF.FARM)), name = "Set1")
ggplot(subtype, aes(x = as.factor(year), y = freq, fill = SUBTYPE.OF.FARM)) +
  scale_fill_manual(values = colors)+
  geom_bar(stat = "identity") +
  labs(title = "A closer look at the growth of intensive farms over the years",
       subtitle ="Registered intensive farms for the year grouped by the type of farm",
       x = "Year",
       y = "Number of farms",) +
  theme_linedraw() +theme(legend.position = "top", axis.text.x = element_text(angle = 45, hjust = 1)) +
  guides(fill = guide_legend(title = "Subtype", ncol = 2, byrow = TRUE))# Rotate x-axis labels by 45 degrees # Position legend at the top
