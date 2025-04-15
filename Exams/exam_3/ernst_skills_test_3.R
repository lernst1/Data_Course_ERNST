library(tidyverse)
library(janitor)
library(broom)
library(ggh4x)

# Read FacultySalaraies_1995.csv and clean column names
salary_df <- read.csv("FacultySalaries_1995.csv") |> clean_names()

# Clean the df
clean_salary_df <- salary_df |>
  select(tier, avg_full_prof_salary, avg_assoc_prof_salary, avg_assist_prof_salary) |>
  pivot_longer(cols = starts_with("avg"),
               names_to = "Rank",
               values_to = "Salary") |>
  mutate(
    Rank = case_when(
      Rank == "avg_assist_prof_salary" ~ "Assist",
      Rank == "avg_assoc_prof_salary" ~ "Assoc",
      Rank == "avg_full_prof_salary" ~ "Full"
    ),
    Rank = factor(Rank, levels = c("Assist", "Assoc", "Full")),
    tier = factor(tier, levels = c("I", "IIA", "IIB"))
  ) |>
  drop_na()

# Plot the data
clean_salary_df |>
  ggplot(aes(x = Rank, y = Salary, fill = Rank)) + 
  geom_boxplot() + 
  facet_grid(. ~ tier) + 
  scale_fill_manual(values = c("Assist" = "#F8766D", "Assoc" = "#00BA38", "Full" = "#619CFF")) +
  theme_minimal() +
  labs(x = "Rank", y = "Salary", title = "Faculty Salaries by Rank and Tier (1995)") +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    legend.position = "right"
  )

# Build ANOVA model to display summary
mod <-  aov(Salary ~ Rank * tier, data = clean_salary_df)
summary(mod)

# Load juniper oils csv
juniper_df <- read.csv("Juniper_Oils.csv") |> clean_names()
view(juniper_df)

# Filter for compound columns
compound_cols <- colnames(juniper_df)[colnames(juniper_df) %in% c(
  "alpha_pinene","para_cymene","alpha_terpineol","cedr_9_ene","alpha_cedrene",
  "beta_cedrene","cis_thujopsene","alpha_himachalene","beta_chamigrene",
  "cuparene","compound_1","alpha_chamigrene","widdrol","cedrol","beta_acorenol",
  "alpha_acorenol","gamma_eudesmol","beta_eudesmol","alpha_eudesmol",
  "cedr_8_en_13_ol","cedr_8_en_15_ol","compound_2","thujopsenal")]

# Consolidate compound columns
clean_juniper_df <- juniper_df |>
  pivot_longer(cols = all_of(compound_cols),
               names_to = "compound",
               values_to = "concentration") |>
  select(compound, concentration, years_since_burn) |>
  drop_na()

# Plot clean_juniper_df
clean_juniper_df |>
  ggplot(aes(x = years_since_burn, y = concentration)) +
  geom_smooth(color = "blue") +
  ggh4x::facet_wrap2(~compound, scales = "free_y", ncol = 5, strip.position = "top", axes = "all") +
  theme_minimal() +
  labs(title = "Compound Concentratiosn by Years Since Burn",
       x = "Years Since Burn",
       y = "Concentration")

# Build model and tidy output for each compound
significant_results <- clean_juniper_df |>
  group_by(compound) |>
  summarise(
    model = list(lm(concentration ~ years_since_burn, data = cur_data())),
    .groups = "drop"
  ) |>
  mutate(tidy_output = map(model, tidy)) |>
  unnest(tidy_output) |>
  filter(term == "years_since_burn", p.value < 0.05) |>
  select(compound, estimate, std.error, statistic, p.value) |>
  arrange(p.value)

print(significant_results)
