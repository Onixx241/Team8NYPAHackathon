
install.packages("dplyr")
install.packages("ggplot2")
install.packages("plotly")
install.packages("htmlwidgets")

library(dplyr)
library(ggplot2)
library(plotly)
library(htmlwidgets)

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
    Multifamily.Housing...Number.of.Bedrooms.Density..Number.per.1.000.sq.ft.
  ) %>%
  filter(is.finite(EUI), EUI > 0)

model_data <- model_data[complete.cases(model_data), ]

energy_prediction <- lm(
  EUI ~ Year.Built +
    Multifamily.Housing...Number.of.Bedrooms.Density..Number.per.1.000.sq.ft.,
  data = model_data
)

print(summary(energy_prediction))

average_energy_usage <- model_data %>%
  group_by(Year.Built) %>%
  summarise(
    average_EUI = mean(EUI),
    average_bedroom_density = mean(
      Multifamily.Housing...Number.of.Bedrooms.Density..Number.per.1.000.sq.ft.
    ),
    buildings = n(),
    .groups = "drop"
  )

print(average_energy_usage)

testing_model_data <- testing_data %>%
  select(
    EUI,
    Year.Built,
    Multifamily.Housing...Number.of.Bedrooms.Density..Number.per.1.000.sq.ft.
  ) %>%
  filter(is.finite(EUI), EUI > 0)

testing_model_data <- testing_model_data[
  complete.cases(testing_model_data),
]

prediction_data <- data.frame(
  actual_EUI = testing_model_data$EUI,
  predicted_EUI = predict(
    energy_prediction,
    newdata = testing_model_data
  )
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
    title = "Correlation of Energy Use Intensity with Building Year and Bedroom Density",
    x = "Actual Energy Use per Square Foot (kBtu/ft²)",
    y = "Predicted Energy Use per Square Foot (kBtu/ft²)"
  ) +
  coord_cartesian(
    xlim = c(
      0,
      quantile(prediction_data$actual_EUI, 0.99, na.rm = TRUE)
    ),
    ylim = c(
      0,
      quantile(prediction_data$predicted_EUI, 0.99, na.rm = TRUE)
    )
  ) +
  theme_minimal()


print(scatter)

output_directory <- normalizePath(
  ".",
  winslash = "\\",
  mustWork = TRUE
)
png_file <- file.path(
  output_directory,
  "energy_usage_per_square_foot.png"
)
html_file <- file.path(
  output_directory,
  "energy_usage_per_square_foot.html"
)

ggsave(
  filename = png_file,
  plot = scatter,
  width = 8,
  height = 6,
  units = "in",
  dpi = 300,
  device = "png"
)

htmlwidgets::saveWidget(
  plotly::ggplotly(scatter),
  html_file,
  selfcontained = TRUE
)

print(paste("PNG saved to:", png_file))
print(paste("HTML saved to:", html_file))
