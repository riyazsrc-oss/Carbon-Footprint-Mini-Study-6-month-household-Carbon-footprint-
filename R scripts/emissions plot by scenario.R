install.packages
library(tidyverse)

install.packages
library(conflicted)
library(dplyr)

df <- read.csv("EnergyScenario_Sensitivity.csv")
print(head(df))
print(glimpse(df))
df_prepared <- df %>%
  mutate(
    Period = lubridate::ymd(paste0(Period, "-01"))
  )
  
emissions_plot <- ggplot(
  data = df_prepared,
  aes(
    x = Period,
    y = "Total Emissions AvgEF",
    color = Scenario
  )
)
 geom_line(linewidth = 1)
 labs(
   title = "Total Emissions Over time by Scenario",
   subtitle = "Comparing Baseline, Renewable, and 50% Solar Scenario",
   x = "Date",
   y = "Total Emissions (Avg. Emissions Factor)",
   color = "Scenario"
)
   
 
print(emissions_plot)
