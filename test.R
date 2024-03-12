library(tidyverse)

# plot iris data set

iris %>%
   ggplot(aes(x = Sepal.Length, y = Sepal.Width, col = Species)) +
	geom_point() +
	theme_minimal()
