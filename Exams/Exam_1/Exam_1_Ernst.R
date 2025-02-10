library(dplyr)
library(ggplot2)
library(tidyverse)

# Read cleaned_covid_data.csv into a data frame
covid_df <- read_csv("./Exams/Exam_1/data/cleaned_covid_data.csv")

# Subset the data to read only A-named states
A_states <- covid_df[grep("^A", covid_df$Province_State), ]

# Create a scatterplot of A_states showing death over time, with a separate facet for each state
A_states %>%
  ggplot(aes(x = Last_Update, y = Deaths, color = Province_State)) + 
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE) +
  facet_wrap(~ Province_State, scales = "free")

# Find peak of Case_Fatality_Ratio for each state and store in a new data frame
max_fatality_rate <- data.frame(State = covid_df$Province_State, 
                            Fatality = covid_df$Case_Fatality_Ratio)

state_max_fatality_rate <- max_fatality_rate %>%
  group_by(State) %>%
  filter(Fatality == max(Fatality, na.rm = TRUE)) %>%
  distinct(State, Fatality, .keep_all = TRUE) %>%
  ungroup() %>%
  arrange(desc(Fatality))

# Make a bar plot of state_max_fatality with x-axis descending and labels turn 90-degrees
state_max_fatality_rate %>%
  ggplot(aes(x = reorder(State, -Fatality), y = Fatality, fill = Fatality)) +
  scale_fill_gradient(low = "blue", high = "red") +
  geom_col() +
  labs(x = "State", y = "Max Fatality Rate") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Plot the cumulative deaths for the entire US over time
us_fatality <- covid_df %>%
  group_by(Last_Update) %>% 
  summarise(cumulative_deaths = sum(Deaths, na.rm = TRUE)) %>% 
  arrange(Last_Update)

us_fatality %>%
  ggplot(aes(x = Last_Update, y = cumulative_deaths)) + 
  geom_line(color = "red", size = 1) + 
  labs(title = "Cumulative Deaths in the US Over Time", x = "Time", y = "Total Deaths") +
  theme_minimal()
