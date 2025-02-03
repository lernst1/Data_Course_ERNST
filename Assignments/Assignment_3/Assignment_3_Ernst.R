data("iris")

# 1.  Get a subset of the "iris" data frame where it's just even-numbered rows
even_rows <- iris[seq(2, nrow(iris), by = 2), ]
head(even_rows)

# 2.  Create a new object called iris_chr which is a copy of iris, except where every column is a character class
iris_chr <- data.frame(apply(iris, 2, as.character))
str(iris_chr)

# 3.  Create a new numeric vector object named "Sepal.Area" which is the product of Sepal.Length and Sepal.Width
Sepal.Area <- iris$Sepal.Length * iris$Sepal.Width
head(Sepal.Area)

# 4.  Add Sepal.Area to the iris data frame as a new column
iris$Sepal.Area <- Sepal.Area
head(iris)

# 5.  Create a new dataframe that is a subset of iris using only rows where Sepal.Area is greater than 20 
# (name it big_area_iris)
big_area_iris <- iris[iris$Sepal.Area > 20, ]
head(big_area_iris)
