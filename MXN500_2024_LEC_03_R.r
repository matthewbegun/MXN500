# A "string" or character variable in R is anything entered in quotes.
character_string <- "This is a string"
single_character <- "a"
character_vector <- c("a", "b", "b", "c", "a")
str(character_string)
str(single_character)
str(character_vector[1])
str(character_vector)

# Selecting with vectors
sel_vec <- c(1,2,4)
character_vector[sel_vec]
character_vector[c(1,2,4)]

# Sorting with vectors
sort_vec <- c(4,1,2)
character_vector[sort_vec]

# Selection *and* sorting
sort2_vec <- c(3,1,2)
sel2_vec <- sel_vec[sort2_vec]
str(sel2_vec)
character_vector[sel2_vec]

# Composed select + sort
character_vector[sel_vec[sort2_vec]]

# A factor variable is how R treats categories of data.
factor_vector <- as.factor(character_vector)
str(factor_vector)
levels(factor_vector)


library(tidyverse)
# To create a data frame with categorical variables, use a vector of strings.
# This vector is treated as a factor by default.
hml_df <- data.frame(category = c("High", "Medium", "Low"))
summary(hml_df)
str(hml_df)
hml_df

# Factors default to an alphabetical order:
factor(hml_df$category)

# To change the order, you need to provide levels.
hml_df_ordered_factors <- hml_df
hml_df_ordered_factors$category <-
  factor(hml_df_ordered_factors$category,
         levels = c("Low", "Medium", "High")) # change the levels

# Compare the result:
factor(hml_df$category) # Order we don't want.
factor(hml_df_ordered_factors$category) # Order we want.

# Beware of strings defaulting to factors in data frames. While this is the
# default, you Can turn this off if you want:
hml_characters_df <- data.frame(category = c("High", "Medium", "Low"),
                                stringsAsFactors = FALSE)
str(hml_characters_df)
summary(hml_characters_df)
hml_characters_df

# Look what happens to these "numbers". Need to be careful to make sure you
# data is the correct type.
num_df <- data.frame(numbers = c("3.14", "-2", "15"))
str(num_df)
class(num_df$numbers)
mean(num_df$numbers)

# To make the data numeric need to change it's type
now_numbers <- as.numeric(num_df$numbers)
str(now_numbers)
mean(now_numbers)

# Be careful of these steps, can cause uncaught problems!
more_numbers <- c(2, 6, "*8")
mean(more_numbers)
str(more_numbers)



# OK fix this issue through 'coercion' i.e. `as.numeric()`
now_more_numbers = as.numeric(more_numbers)
mean(now_more_numbers, na.rm = T)
str(now_more_numbers)

# Takeaway - retain intermediate steps as seperate variables while you are developing
#  your code / analysis

# change in the data frame
num_df$numbers = as.numeric(as.character(num_df$numbers))
str(num_df$numbers)
summary(num_df)

# or
library(dplyr) # in general, best to put library calls a the start of the file
num_df = mutate(num_df,
                numbers = as.numeric(as.character(numbers)))
str(num_df$numbers)
summary(num_df)

# of course you can also just provide the data in a
# numberic format - ie. no quotations
num_df <- data.frame(numbers = c(3.14, -2, 15))
str(num_df)
class(num_df$numbers)

# Some basic examples:
add_one <- function(x){
  x_new <- x + 1
  return(x_new)
}
str(add_one)
# In this case, a function called "add_one" is a function which takes some
# input, x, adds one to it, and returns the result.

# Test it out
add_one(5)
add_one(c(1,2,3,4))
x <- add_one(0)
x

# And break it
add_one("a")
# Note that the error message isn't very helpful - what is `x+1`?
# We don't know if we can't see inside the fucntion

# Here's another:
make_negative <- function(x){
  x_new <- -x
  return(x_new)
}
make_negative(-6)
make_negative(1:10)

# Check how they work.
x <- 1
add_one(x)
make_negative(x)

# This `x` is different from the `x` in the function. Confusing!
# Better to use meaningful variable names.

# Interested in applying them one after each other? Composition of functions:
x_new <- make_negative(add_one(x))
x_new


# For example, the pipe we can our code clear and readable
# x_new <- make_negative(add_one(x))
x_new <- x %>%
  add_one() %>%
  make_negative()
x_new

install.packages("Lahman") # Install the package.
library(Lahman) # Load the package.
? Lahman # Read the help so you know what's in the package.

data(Batting) # Get the data.

dim(Batting) # Get a feel for the data (how big).
# View(Batting)
head(Batting) # What variables look like.
# ? Batting # Column name definitions.

# For reshaping we need our favourite:
library(tidyverse)

# Let's look a one player, Manny Ramirez
manny <- filter(Batting, playerID == "ramirma02")

# Remember to use a logical operator to filter.
x = 1  # Single equals assigns in this case.
x == 1 # Double equals is asked are these two things equal.
x == 2

# What info do we have on Manny?
nrow(manny)
View(manny)

# Let's look at some tools to get some summary stats:
# unique values
n_distinct(c("a", "a", "b"))


# concatenate values / variables
paste("a", "b", sep = "-")

# paste defaults to " " as the seperator
paste("a","b","c")
paste("a","b","c", sep = ";")
paste("a","b","c", sep = "")



# `paste0()` is a short cut for no seperator
paste0("a","b","c")



# works with other objects (variables, functions)
a <- "hello"
b <- "world"
paste(a,b,42)
paste0(paste(a,b,42),"!")



# sums
sum(1:3)

manny_stats <- summarise(manny,
                         span = paste(min(yearID), max(yearID), sep = "-"),
                         numYears = n_distinct(yearID),
                         numTeams = n_distinct(teamID),
                         BA = sum(H)/ sum(AB),
                         tH = sum(H),
                         tHR = sum(HR),
                         tRBI = sum(RBI))
head(manny_stats)


# With the pipe, you could do this:
manny_being_manny <- Batting %>%
  filter(playerID == "ramirma02") %>%
  summarise(span = paste(min(yearID), max(yearID), sep = "-"), # Note also the paste() function here.
            numYears = n_distinct(yearID),
            numTeams = n_distinct(teamID),
            BA = sum(H) / sum(AB),
            tH = sum(H),
            tHR = sum(HR),
            tRBI = sum(RBI))

head(manny_being_manny)


# Might be interesting to break the stats down by team:
manny_team_stats <- Batting %>%
  filter(playerID == "ramirma02") %>%
  group_by(teamID) %>% # added in a group operator
  summarise(span = paste(min(yearID), max(yearID), sep = "-"),
            numYears = n_distinct(yearID),
            numTeams = n_distinct(teamID),
            BA = sum(H) / sum(AB),
            tH = sum(H),
            tHR = sum(HR),
            tRBI = sum(RBI))
head(manny_team_stats)

# To make the data more intuitive / readable.
# Might want to reorder by the years played for each team.
# Can use arrange for that.
example <- data.frame(number = c(2, 5, 1))
arrange(example, number)

manny_team_stats <- Batting %>%
  filter(playerID == "ramirma02") %>%
  group_by(teamID) %>%
  summarise(span = paste(min(yearID), max(yearID), sep = "-"),
            numYears = n_distinct(yearID),
            numTeams = n_distinct(teamID),
            BA = sum(H)/ sum(AB),
            tH = sum(H),
            tHR = sum(HR),
            tRBI = sum(RBI)) %>%
  arrange(span) # Now arrange by the span

head(manny_team_stats) # almost, of course Boston should be on top...

# Let's start with a toy example:
df1 <- data.frame(number = 1:3,
                 first_letters = c("a", "b", "c"))
df1

df2 <- data.frame(number = c(1:2, NA_real_, 4),
                 last_letters = c("w", "x", "y", "z"))
df2

# terminology of joins is Left and Right sides, so could use:
dfL <- df1
dfR <- df2

# Rows must exist in both data sets,
# Bi-directional:
inner_join(dfL, dfR)

# Combine everything:
full_join(dfL, dfR)

# Rows must exist in the first data set.
# Directional joins - order matters:
left_join(df1, df2) # Add df2 to df1.
left_join(df2, df1) # Add df1 to df2.

# Now lets combine some real data sets
# Can use Master and batting data from Lahman package
data(Batting)
dim(Batting)
data(People)
dim(People)

# first let's understand what we will join
# Manny - just get his data
manny_data <- Batting %>%
  filter(playerID == "ramirma02")
nrow(manny_data)
head(manny_data)

# combine using common entries in both
inner_join_batting_people <- manny_data %>%
  inner_join(People, by = "playerID")
head(inner_join_batting_people)

# most of the time join functions are clever enough
# to know what to join by
inner_join_batting_people <- manny_data %>%
  inner_join(People)


# playerID is the only common column in this example
names_batting <- names(Batting)
names_people <- names(People)
intersect(names_batting, names_people)

# Let's look at what happened
View(inner_join_batting_people)
# basically, repeat the player details for each row of the players' batting
# stats.

# What if we used left_join instead
left_join_batting_people <- manny_data %>%
  left_join(People)
head(left_join_batting_people)
# same thing, because common rows in Manny player data were the constraint.

# What if we change the order?
left_join_people_batting <- People %>%
  left_join(manny_data)
head(left_join_people_batting)


# We don't just get the information about Manny.
# Can see we have no stats for the other players.
# Join order is important!
# Have to think about what you need before you join your data.

# Actually wish I'd done it this way in the lecture for consistency!
# filter(left_join_people_batting, playerID == "ramirma02")
left_join_people_batting %>%
  filter(, playerID == "ramirma02")


