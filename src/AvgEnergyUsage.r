library(dplyr)
library(ggplot2)

building_data <- read.csv(
  ".\\datafeed\\multifamily_building_energy_consumption_training_dataset.csv",
  na.strings = c("Not Available", "")
)

testing_data <- read.csv(
  ".\\datafeed\\multifamily_building_energy_consumption_testing_dataset.csv",
  na.strings = c("Not Available", "")
)

building_data$EUI <- with(
  building_data,
  Weather.Normalized.Site.Energy.Use..kBtu. /
    Largest.Property.Use.Type...Gross.Floor.Area..ft..
)

testing_data$EUI <- with(
    testing_data,
    Weather.Normalized.Site.Energy.Use..kBtu. /
      Largest.Property.Use.Type...Gross.Floor.Area..ft..
)

model_data <- building_data %>%
  select(
    EUI,
    Year.Built,
    Multifamily.Housing...Number.of.Bedrooms
  ) %>%
  filter(is.finite(EUI), EUI > 0)

model_data <- model_data[complete.cases(model_data), ]

# Log EUI reduces the effect of unusually high-energy buildings.
energy_prediction <- lm(
  log(EUI) ~ Year.Built +
    Multifamily.Housing...Number.of.Bedrooms,
  data = model_data
)

print(summary(energy_prediction))

average_energy_usage <- model_data %>%
  group_by(Year.Built) %>%
  summarise(
    average_EUI = mean(EUI),
    average_bedrooms = mean(
      Multifamily.Housing...Number.of.Bedrooms
    ),
    buildings = n(),
    .groups = "drop"
  )

print(average_energy_usage)

testing_model_data <- testing_data %>%
  select(
    EUI,
    Year.Built,
    Multifamily.Housing...Number.of.Bedrooms
  ) %>%
  filter(is.finite(EUI), EUI > 0)

testing_model_data <- testing_model_data[
  complete.cases(testing_model_data),
]

prediction_data <- data.frame(
  actual_EUI = testing_model_data$EUI,
  predicted_EUI = exp(predict(
    energy_prediction,
    newdata = testing_model_data
  ))
)

print(cor(
  prediction_data$actual_EUI,
  prediction_data$predicted_EUI
))

scatter <- ggplot(
  prediction_data,
  aes(x = actual_EUI, y = predicted_EUI)
) +
  geom_point(alpha = 0.5) +
  geom_abline(
    slope = 1,
    intercept = 0,
    linetype = "dashed",
    color = "firebrick"
  ) +
  labs(
    title = "Predicted vs. Actual EUI",
    x = "Actual EUI (kBtu/ft²)",
    y = "Predicted EUI (kBtu/ft²)"
  ) +
  theme_minimal()


print(scatter)

ggsave(
  filename = ".\\scatterBeginner.png",
  plot = scatter,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300
)
htmlwidgets::saveWidget(
  ggplotly(scatter),
  "scatterBeginner.html",
  selfcontained = TRUE
)
View(training_dataset)
ggsave(
  filename = "scatterBeginner.png",
  plot = scatter,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300
)