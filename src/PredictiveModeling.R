install.packages("tidymodels")
install.packages("ggplot2")
library(tidymodels)
library(ggplot2)

training_dataset <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_training_dataset.csv", na.strings = c("Not Available", "")) #nolint
testing_dataset <- read.csv(".\\datafeed\\multifamily_building_energy_consumption_testing_dataset.csv") #nolint

training_dataset$EUI <-
  training_dataset$Weather.Normalized.Site.Energy.Use..kBtu. /
  training_dataset$Largest.Property.Use.Type...Gross.Floor.Area..ft..

testing_dataset$EUI <-
  testing_dataset$Weather.Normalized.Site.Energy.Use..kBtu. /
  testing_dataset$Largest.Property.Use.Type...Gross.Floor.Area..ft..

#bad correlation
# future_estimation <- lm(
#   `Weather.Normalized.Site.Energy.Use..kBtu.` ~
#     `Largest.Property.Use.Type...Gross.Floor.Area..ft..` +
#     Occupancy,
#   data = training_dataset
# )

future_estimation <- lm(
  EUI ~
    Occupancy +
    `Year.Built` +
    `Multifamily.Housing...Percent.That.Can.Be.Cooled` +
    `Multifamily.Housing...Percent.That.Can.Be.Heated` +
    `Multifamily.Housing...Number.of.Bedrooms.Density..Number.per.1.000.sq.ft.` +
    `Multifamily.Housing...Total.Number.of.Residential.Living.Units.Density..Number.per.1.000.sq.ft.`,
  data = training_dataset
)



prediction_data <- data.frame(
  actual_EUI = testing_dataset$EUI,
  predicted_EUI = future_predictions
)

prediction_data <- prediction_data[complete.cases(prediction_data), ]

prediction_data$error <-
  prediction_data$actual_EUI - prediction_data$predicted_EUI

rmse <- sqrt(mean(prediction_data$error^2))
mae <- mean(abs(prediction_data$error))

print(paste("RMSE:", rmse))
print(paste("MAE:", mae))

scatter <- ggplot(
  prediction_data,
  aes(x = actual_EUI, y = predicted_EUI)
) +
  geom_point(alpha = 0.6, color = "steelblue") +
  geom_abline(
    slope = 1,
    intercept = 0,
    linetype = "dashed",
    color = "firebrick"
  ) +
  labs(
    title = "Predicted vs. Actual EUI",
    x = "Actual EUI (kBtu)",
    y = "Predicted EUI (kBtu)"
  ) +
  theme_minimal()


print(summary(future_estimation))
View(prediction_data)
View(training_dataset)
print(scatter)
