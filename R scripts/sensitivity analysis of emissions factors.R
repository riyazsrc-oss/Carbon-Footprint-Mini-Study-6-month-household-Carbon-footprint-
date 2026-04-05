
library(tidyverse)
library(lubridate)


library(readr)
EnergyScenario_Sensitivity <- read_csv("CSVs/EnergyScenario_Sensitivity.csv")
View(EnergyScenario_Sensitivity)

show_col_types = FALSE ##Got rid of warning message!

# Clean and prepare the data
df_prepared <- EnergyScenario_Sensitivity %>%
  # 3a. Remove all rows that contain NA values in the columns we care about
  drop_na(Period, `Total Emissions AvgEF`, Scenario) %>% ##
  
  # 3b. Convert 'Period' to a proper date object (YYYY-MM-DD)
  mutate(
    Period = ymd(paste0(Period, "-01"))
  )

# --- DIAGNOSTIC STEP ---

print(glimpse(df_prepared))

# Create the line chart
emissions_plot <- ggplot(
  data = df_prepared,
  aes(
    # Set Period on the x-axis
    x = Period,
    # Set Total Emissions (AvgEF) on the y-axis
    y = `Total Emissions AvgEF`,
    # Use the Scenario to create different colored lines
    color = Scenario
  )
) +
  # Add the line geometry
  geom_line(linewidth = 1) +
  
  # Add informative labels
  labs(
    title = "Total Emissions Over Time by Scenario (Complete Data Only)",
    subtitle = paste0(nrow(df_prepared), " data points used."),
    x = "Date",
    y = "Total Emissions (Avg. Emission Factor)",
    color = "Scenario"
  ) +
  
  # Clean up the appearance
  theme_minimal()

# Display the plot
print(emissions_plot)



df_long <- df_prepared %>%
  # Use the pipe operator to start the pivot
  pivot_longer(
    # Select the three columns you want to combine into one
    cols = c(`Total Emissions LowEF`, `Total Emissions AvgEF`, `Total Emissions HighEF`),
    
    # Create a new column called 'Factor_Type' to store the original column names
    names_to = "Factor_Type",
    
    # Create a new column called 'Emissions' to store the numeric values
    values_to = "Emissions"
  )

print(head(df_long))

emissions_comparison_plot <- ggplot(
  data = df_long,
  aes(
    x = Period,
    y = Emissions,
    # Color the lines based on the new 'Factor_Type' column
    color = Factor_Type
  )
) +
  # Draw the lines
  geom_line(linewidth = 1) +
  
  # Separate the plot into panels, one for each 'Scenario'
  # 'scales = "free_y"' allows the y-axis to be different for each panel,
  # which helps visualize differences when values vary greatly.
  facet_wrap(~ Scenario, scales = "free_y") +
  
  # Add informative labels
  labs(
    title = "Emissions Sensitivity Comparison Over Time",
    subtitle = "Low, Average, and High Emission Factors by Scenario",
    x = "Date",
    y = "Total Emissions",
    color = "Emission Factor" # Relabel the legend title
  ) +
  
  # Apply a clean theme and improve the legend names
  theme_minimal() +
  scale_color_discrete(
    # Define simple labels for the legend
    labels = c("Avg (Base)", "High", "Low") 
  )
theme_minimal()

# Display the final plot
print(emissions_comparison_plot)
ggsave("Emissions_Sensitivity_Comparison_OverTime.png", emissions_comparison_plot, height = 6, width = 10, dpi = 300)
