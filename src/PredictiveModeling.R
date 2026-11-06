install.packages("tidymodels")

training_dataset <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_training_dataset.csv") #nolint
testining_dataset <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_testing_dataset.csv") #nolint


View(training_dataset)
View(testining_dataset)




# Yangel stuff
testing_dataset <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_testing_dataset.csv") #nolint

data(training_dataset)

print(colnames(training_dataset))

#BuiltEighteenth <- filter(training_dataset, `Year.Built` < 1900)


View(Eighteenth)
