install.packages("dplyr")
library(dplyr)

data <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_training_dataset.csv") |> #nolint
  aggregate(`Largest.Property.Use.Type...Gross.Floor.Area..ft..`,mean(Weather.Normalized.Site.Energy.Use..kBtu.))
View(data)