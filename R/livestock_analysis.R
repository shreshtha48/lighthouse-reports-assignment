
#loading the libraries sf and ggplot2
library(sf)
library(ggplot2)
library(dplyr)

#plotting the data for top ten species by number of farms
#getting the top 10 species
#print(sort(table(data$SPECIES),decreasing=TRUE))
species_count=as.data.frame((sort(table(data$SPECIES),decreasing=TRUE)))
graph=species_count[1:10, ]
#plotting the top ten species using a simple bar graph
ggplot(graph, aes(x=Var1, y=Freq),ylab="species",xlab="number of farms") +
  labs(x="number of farms", y="species")+
  ggtitle("top ten number of species by farm")+
  geom_bar(stat = "identity")+
  theme_minimal()+
  #flipped it because it looks neat
  coord_flip()

#creating a pie chart analysis which shows the percentage of active farms

# Create the outer pie chart for SUBTYPE.OF.FARM within "Activa" OPERATION.STATUS
#print(sort(table(livestock$FARM.TYPE), decreasing = TRUE))

slices_labels <- round(farm_subtype$x/sum(farm_subtype$x) * 100, 1)

# Concatenate a '%' char after each value
slices_labels <- paste(slices_labels, "%", sep="")
colors <- c("#7fc97f", "#beaed4", "#fdc086", "#ffff99", "#386cb0")
pie3D(farm_subtype$x, sep = " " ,theta=0.8, explode=0,
    col =colors,lablecex=0.5,main = "Distribution of subtypes of farms",labels=slices_labels)
par(xpd=TRUE)

# Add legend with labels and corresponding colors
legend(1,0.7,yjust=0.6, xjust = -0.1, legend = farm_subtype$y, fill = colors, cex=0.68,title = "Farm Subtypes")  # Adjusting inset to avoid cutoff


# Plotting the 3D pie chart
# Plotting the 3D pie chart
pie3D(farm_subtype$x, sep = " ", radius = 1, explode = 0,
      col = colors, labelcex = 0.5, main = "Distribution of subtypes of farms", labels = slices_labels)

# Add legend with labels and corresponding colors
legend("topright", legend = farm_subtype$y, fill = colors,
       cex = 0.68, title = "Farm Subtypes", bty = "n")

data=as_tibble(data)

livestock <- as_tibble(livestock)

# Filter, group by species, summarize total nitrogen emissions, sort, and get top 5 species
result <- livestock %>%
  filter(PRODUCTION.SYSTEM == "Intensiu") %>%
  group_by(SPECIES) %>%
  summarize(total_nitrogen_emissions = sum(TOTAL.NITROGEN, na.rm = TRUE)) %>%
  arrange(desc(total_nitrogen_emissions))

species=livestock%>%
  filter(PRODUCTION.SYSTEM =="Intensiu") %>%
  group_by(SPECIES) %>%
  summarize(freq=n()) %>%
  arrange(desc(freq))
#join result and species
 result=merge(result, species, by ="SPECIES", all = TRUE)
#remove values where the value of total nitrogen emissions is 0
 result <- result[apply(result!=0, 1, all),]
 result$normalized_nitrogen_emissions=as.numeric(result$total_nitrogen_emissions/result$freq)
 result=result[order(-result$normalized_nitrogen_emissions),]

ggplot(result, aes(x= reorder(SPECIES, -normalized_nitrogen_emissions), y=normalized_nitrogen_emissions),ylab="nitrogen emissions",xlab="species") +
  labs(x="species", y="nitrogen emissions")+
  ggtitle("nitrogen emission by species")+
  geom_bar(stat = "identity")+
  coord_flip()
  #flipped it because it looks
#combine both of them in a single plot
library(ggplot2)
library(gridExtra)

plot1 <- ggplot(graph, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity") +
  labs(title = "Top Ten Number of Species by Farm", x = "Species", y = "Number of Farms") +
  theme_minimal() +
  coord_flip()

plot2 <- ggplot(result, aes(x = reorder(SPECIES, -normalized_nitrogen_emissions), y = normalized_nitrogen_emissions)) +
  geom_bar(stat = "identity") +
  labs(title = "Nitrogen Emission by Species", x = "Species", y = "Nitrogen Emissions") +
  theme_minimal() +
  coord_flip()

# Arrange plots in a grid
grid.arrange(plot1, plot2, nrow = 1)




usethis::use_data(result,compress = "xz", overwrite=TRUE)
usethis::use_data(graph, compress="xz", overwrite=TRUE)
# View the result
print(result)

