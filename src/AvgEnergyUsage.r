install.packages("dplyr")
library(dplyr)

data <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_training_dataset.csv")

aggregated_data <- aggregate(
  Weather.Normalized.Site.Energy.Use..kBtu. ~ Largest.Property.Use.Type...Gross.Floor.Area..ft.., 
  data = data, 
  FUN = mean, 
  na.rm = TRUE
)

View(aggregated_data)