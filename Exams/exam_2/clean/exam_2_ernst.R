library(tidyverse)
library(janitor)

# Read in the unicef data and clean the column names
uni_dat <- read.csv("./Exams/exam_2/raw/unicef-u5mr.csv") %>%
  clean_names()

# Tidy the data - create a new column for the year and mortality_rate
# Rearrange cols, remove region column, and remove NAs from mortality_rate
uni_dat <- uni_dat %>%
pivot_longer(cols = starts_with("u5mr_"), 
             names_to = "year",
             values_to = "mortality_rate") %>%  
  mutate(year = as.numeric(str_remove(year, "u5mr_"))) %>%
  filter(!is.na(mortality_rate)) %>%
  dplyr::select(continent, country_name, year, mortality_rate)

view(uni_dat)

# Plot each country's u5mr over time
# Create a line plot for each country and facet by continent
uni_dat %>%
  ggplot(aes(x = year, y = mortality_rate, group = country_name)) +
  geom_line() +
  facet_wrap(~ continent) +
  labs(
    title = "U5MR over Time",
    x = "Year",
    y = "U5MR") +
  theme_bw()

# Save the plot
ggsave("ernst_plot_1.png", width = 10, height = 6, dpi = 300)

# Plot mean u5mr for all countries in a given continent
# Calculate mean u5mr for each country
mean_dat <- uni_dat %>%
  group_by(continent, year) %>%
  summarize(mean_mortality_rate = mean(mortality_rate, na.rm = TRUE), .groups = "drop")

# Line plot colored by continent
mean_dat %>%
  ggplot(aes(x = year, y = mean_mortality_rate, color = continent, group = continent)) + 
  geom_line(size = 1) +
  labs(
    x = "Year",
    y = "Mean_U5MR") +
  theme_bw()

# Save the plot
ggsave("ernst_plot_2.png", width = 10, height = 6, dpi = 300)

# Model u5mr based on year, year + continent, year, continent + their interaction term
mod1 <- glm(mortality_rate ~ year, data = uni_dat, family = poisson())
mod2 <- glm(mortality_rate ~ year + continent, data = uni_dat, family = poisson())
mod3 <- glm(mortality_rate ~ year * continent, data = uni_dat, family = poisson())

# Compare the models
mod1 %>% summary
mod2 %>% summary
mod3 %>% summary
compare_performance(mod1, mod2, mod3) %>% plot

# Model 3 has the highest values in each category and is the best fit model