library(tidyverse)

covid_df <- read_csv("./Exams/Exam_1/cleaned_covid_data.csv")
colnames(df)

# Find peak of Case_Fatality_Ratio for each state and store in a new data frame
max_fatality_rate <- data.frame(State = covid_df$Province_State, 
                                Fatality = covid_df$Case_Fatality_Ratio)

state_max_fatality_rate <- max_fatality_rate %>%
  group_by(State) %>%
  filter(Fatality == max(Fatality, na.rm = TRUE)) %>%
  distinct(State, Fatality, .keep_all = TRUE) %>%
  ungroup()

# Make the ugliest plot you can
state_max_fatality_rate %>%
  ggplot(aes(x = State, y = Fatality, fill = State)) +
  geom_hex() +
  labs(x = "State", y = "Max") +
  theme(axis.text.x = element_text(angle = 25)) +
 # theme(legend.position = "none") +
  coord_cartesian(ylim = c(1.5, 6)) +
  theme(panel.background = element_rect(fill = "limegreen"), 
        panel.grid.major = element_line(color = "red", size = 1.5)) +
  geom_abline(color = "yellow")

#ggsave("uglyplot.png", width = 6, height = 4, dpi = 300)
