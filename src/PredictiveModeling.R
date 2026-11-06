install.packages("tidymodels")
install.packages("ggplot2")
library(tidymodels)
library(ggplot2)

training_dataset <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_training_dataset.csv") #nolint
testing_dataset <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_testing_dataset.csv") #nolint

print(colnames(training_dataset))

#BuiltEighteenth <- filter(training_dataset, `Year.Built` < 1900)


future_estimation <- lm(
  `Weather.Normalized.Site.Energy.Use..kBtu.` ~
    `Largest.Property.Use.Type...Gross.Floor.Area..ft..` +
      `Year.Built` +
    Occupancy,
  data = training_dataset
)

future_predictions <- predict(
  future_estimation,
  newdata = testing_dataset
)

prediction_data <- data.frame(
  actual_energy_usage = testing_dataset$Weather.Normalized.Site.Energy.Use..kBtu.,
  predicted_energy_usage = future_predictions
)
prediction_data <- prediction_data[complete.cases(prediction_data), ]

scatter <- ggplot(
  prediction_data,
  aes(x = actual_energy_usage, y = predicted_energy_usage)
) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_abline(
    slope = 1,
    intercept = 0,
    linetype = "dashed",
    color = "firebrick"
  ) +
  labs(
    title = "Predicted vs. Actual Energy Usage",
    x = "Actual Energy Usage (kBtu)",
    y = "Predicted Energy Usage (kBtu)"
  ) +
  theme_minimal()

print(summary(future_estimation))
print(scatter)