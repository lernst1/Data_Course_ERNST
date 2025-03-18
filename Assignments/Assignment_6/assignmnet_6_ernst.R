library(tidyverse)
library(janitor)
library(gganimate)

# Make new column for time, absorbance, split sample_id between water and soil

# Relative path to BioLog from Assignment_6 directory
dat <- read_csv("../../Data/BioLog_Plate_Data.csv")

# Clean column names
dat <- dat %>% clean_names()

# Specify whether a sample is from soil or water
tidy_dat <- dat %>%
  mutate(sample_type = case_when(
    sample_id %in% c("Clear_Creek", "Waste_Water") ~ "Water",
    sample_id %in% c("Soil_1", "Soil_2") ~ "Soil"
  ))

# Reduce Hr_ columns to a single column
tidy_dat <- tidy_dat %>%
  pivot_longer(cols = starts_with("hr_"),
               names_to = "time",
               values_to = "value") %>%
  mutate(time = as.numeric(gsub("hr_", "", time)))

# Mutate Value to absorbance
tidy_dat <- tidy_dat %>%
  rename(absorbance = value)

# Reorder columns
tidy_dat <- tidy_dat %>%
  select(sample_id, sample_type, rep, well, substrate, dilution, time, absorbance)
view(tidy_dat)

# Filter dilution
tidy_plot <- tidy_dat %>%
  filter(dilution == 0.1)

# Plot Absorbance vs Time
tidy_plot %>%
  ggplot(aes(x = time, y = absorbance, color = sample_type)) +
  geom_smooth(method = "loess", se = FALSE) +
  labs(
    title = "Just dilution 0.1",
    x = "Time",
    y = "Absorbance") +
   facet_wrap(~ substrate) +
  theme_minimal()

# Compute the average absorbance values
tidy_avg <- tidy_dat %>%
  group_by(sample_id, time, sample_type, substrate, dilution) %>%
  summarise(avg_absorbance = mean(absorbance, na.rm = TRUE), groups = 'drop')

# Plot the average absorbance
tidy_ani <- tidy_avg %>%
  filter(substrate == "Itaconic Acid") %>%
  ggplot(aes(x = time, y = avg_absorbance, color = sample_id, group = sample_id)) + 
  geom_line(size = 1) + 
  geom_point(size = 2) +
  labs(
    title = "Average Absorbance over Time (Itaconic Acid)",
    x = "Time",
    y = "Mean Absorbance", 
    color = "Sample ID") +
  facet_wrap(~ dilution) +
  theme_minimal() +
  # Animate
  transition_reveal(time) +
  ease_aes('linear')

tidy_ani