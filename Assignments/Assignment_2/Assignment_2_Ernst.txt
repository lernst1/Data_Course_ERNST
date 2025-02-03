#Lists all .csv files found in the Data/ directory
#Stores .csv files into object csv_files
csv_files <- list.files(path = ".", pattern = ".csv")

#Finds how many .csv files there are
length(csv_files)

#Reads wingspan_vs_mass file and assigns to object df
df <- read.csv("wingspan_vs_mass.csv")

#Reads the first 5 lines of the file
head(df, n = 5)

#Recursively finds files in Data/ that begin with "b" and assigns to b_files
b_files <- list.files(path = ".", pattern = "^b", recursive = TRUE, 
                      full.names = TRUE)

#Displays the first line of each b_file
first_lines <- list()

for (file in b_files)
{

    first_line <- readLines(file, n = 1, warn = FALSE)
    first_lines[[file]] <- first_line
}
print(first_lines)

#Read the first line for all files that end in .csv
csv_lines <- list()

for (file in csv_files)
{
  first_line <- readLines(file, n = 1)
  csv_lines[[file]] <- first_line
}
print(csv_lines)