library(tidyverse)

csv_files <- list.files(path = "./Data", pattern = ".csv", recursive = TRUE)
length(csv_files)

df <- read.csv("Data/wingspan_vs_mass.csv")
head(df, n = 5)

b_files <- list.files(path = "./Data", pattern = "^b", ignore.case = FALSE, recursive = TRUE, full.names = TRUE)
length(b_files)

first_lines <- list()

for (file in b_files)
{
  first_line <- readLines(file, n = 1, warn = FALSE)
  first_lines[[file]] <- first_line
}
print(first_lines)

csv_lines <- list()

for (file in csv_files)
{
  first_line <- readLines(file, n = 1, warn = FALSE)
  csv_lines[[files]] <- first_line
}
print(csv_lines)
