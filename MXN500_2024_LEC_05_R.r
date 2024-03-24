# We're going to use data from the ALA library, a collection of pulmonary
# function in females in Topeka, Kansas. Parameter of interest is logFEV1.

install.packages("ALA", repos = "http://R-Forge.R-project.org")
library(ALA)
library(tidyverse)

# Load data for children between 10 and 11 years old and retrieve the raw values
# for FEV1 by taking the exponent of logFEV1.
fev1_df <- fev1 %>%
  filter(age > 10, age < 11) %>%
  mutate(FEV1 = exp(logFEV1))

# Let's look at the data and see if it's normal.
ggplot(data = fev1_df) +
  geom_histogram(aes(x = FEV1),
    bins = 15,
    fill = "lightgray",
    col = "black"
  ) +
  xlab("FEV1 (L)") +
  theme_bw()

# We don't know the true shape of the density function yet.
# Let's add an estimated density curve R (can do this to a plot automatically).
ggplot(data = fev1_df) +
  geom_histogram(aes(x = FEV1, y = after_stat(density)), # change to density
    bins = 15,
    fill = "lightgray",
    col = "black"
  ) +
  geom_density(aes(x = FEV1)) + # added a new line here
  xlab("FEV (L)") +
  theme_bw()


# We can also estimate the density function ourselves by estimating our
# parameters, x-bar and s.
x_bar <- mean(fev1_df$FEV1); x_bar
s_est <- sd(fev1_df$FEV1); s_est

# These two parameters uniquely define the normal function
?dnorm # (density function)

# More or less same plotting code as before, but now we add a code to draw
# our estimated Normal distribution.
ggplot(data = fev1_df) +
  geom_histogram(aes(x = FEV1, y = after_stat(density)),
    bins = 15,
    fill = "lightgray",
    col = "black"
  ) +
  geom_density(aes(x = FEV1)) +
  stat_function(
    fun = dnorm, col = "red", linetype = "dashed", 
    args = list(mean = x_bar, sd = s_est)
  ) +
  xlab("FEV (L)") +
  theme_bw()

# Can use our estimated Normal distribution as a model describing lung function
# in our population - 10 year old girls in Topeka.

# We can use this distribution to answer questions!

# [Q1] What is the probability a 10 year old from Topeka has FEV1 > 2.5L?
ggplot(data = fev1_df, aes(x = FEV1)) +
  geom_area(
    stat = "function", fun = dnorm,
    args = list(mean = x_bar, sd = s_est),
    fill = "red", alpha = 0.2,
    xlim = c(2.5, max(fev1_df$FEV1))
  ) +
  stat_function(
    fun = dnorm, col = "black",
    args = list(mean = x_bar, sd = s_est)
  ) +
  labs(x = "FEV (L)", y = "f") +
  theme_bw()

# Answer? Use the pnorm function!
pnorm(q = 2.5, mean = x_bar, sd = s_est, lower.tail = FALSE)

# Alternative, can think the opposite way and achieve the same result!
ggplot(data = fev1_df, aes(x = FEV1)) +
  geom_area(
    stat = "function", fun = dnorm,
    args = list(mean = x_bar, sd = s_est),
    fill = "green", alpha = 0.2,
    xlim = c(min(fev1_df$FEV1), 2.5)
  ) +
  stat_function(
    fun = dnorm, col = "black",
    args = list(mean = x_bar, sd = s_est)
  ) +
  labs(x = "FEV (L)", y = "f") +
  theme_bw()


1 - pnorm(q = 2.5, mean = x_bar, sd = s_est)

# [Q2] What proportion of the population has FEV between 1.5 and 2.5 L?
ggplot(data = fev1_df, aes(x = FEV1)) +
  geom_area(
    stat = "function", fun = dnorm,
    args = list(mean = x_bar, sd = s_est),
    fill = "red",
    xlim = c(1.5, 2.5),
    alpha = 0.2
  ) +
  stat_function(
    fun = dnorm, col = "black",
    args = list(mean = x_bar, sd = s_est)
  ) +
  labs(x = "FEV (L)", y = "f") +
  theme_bw()

# which is the same as the area less than the right-most bound...
ggplot(data = fev1_df, aes(x = FEV1)) +
  geom_area(
    stat = "function", fun = dnorm,
    args = list(mean = x_bar, sd = s_est),
    fill = "red",
    xlim = c(min(fev1_df$FEV1), 2.5),
    alpha = 0.2
  ) +
  stat_function(
    fun = dnorm, col = "black",
    args = list(mean = x_bar, sd = s_est)
  ) +
  labs(x = "FEV (L)", y = "f") +
  theme_bw()

# ...Minus the area less than the left-most bound!
ggplot(data = fev1_df, aes(x = FEV1)) +
  geom_area(
    stat = "function", fun = dnorm,
    args = list(mean = x_bar, sd = s_est),
    fill = "green",
    xlim = c(min(fev1_df$FEV1), 1.5),
    alpha = 0.2
  ) +
  stat_function(
    fun = dnorm, col = "black",
    args = list(mean = x_bar, sd = s_est)
  ) +
  labs(x = "FEV (L)", y = "f") +
  theme_bw()

# first thing minus the second  thing
pnorm(q = 2.5, mean = x_bar, sd = s_est) -
  pnorm(q = 1.5, mean = x_bar, sd = s_est)


# What is value of FEV that only 5% of the population exceeds?

# (Can't plot a picture yet - need to know the range for shading)

# using qnorm and the upper tail.
q_est <- qnorm(p = 0.05, mean = x_bar, sd = s_est, lower.tail = FALSE); q_est

# using qnorm and the lower tail.
q_est <- qnorm(p = 1 - 0.05, mean = x_bar, sd = s_est); q_est

# Then we can use the value in our ggplot function.
ggplot(data = fev1_df, aes(x = FEV1)) +
  geom_area(
    stat = "function", fun = dnorm,
    args = list(mean = x_bar, sd = s_est),
    fill = "red",
    xlim = c(q_est, max(fev1_df$FEV1)),
    alpha = 0.2
  ) +
  stat_function(
    fun = dnorm, col = "black",
    args = list(mean = x_bar, sd = s_est)
  ) +
  labs(x = "FEV (L)", y = "f") +
  theme_bw()

# We'll start by making a standardised version of FEV1. This is easy using R.
fev1_df <-
  mutate(fev1_df,
    FEV.std = (FEV1 - mean(FEV1)) /
      sd(FEV1)
  )

# confirm mean is aprox 0 and sd == 1
mean(fev1_df$FEV.std)
sd(fev1_df$FEV.std)

# Now we plot the result, using stat_qq from the ggplot2 library.
fev1_dfqq <- ggplot(
  data = fev1_df,
  aes(sample = FEV.std)
) +
  stat_qq(alpha = 0.4, geom = "point", pch = 16) +
  coord_equal() +
  geom_abline() +
  theme_bw() +
  xlab("Z ~ N(0,1)") +
  ylab(expression(Standardised ~ FEV[1]))

fev1_dfqq

# We can show how the t distribution changes with sample size using ggplot.
ggplot(data = data.frame(x = c(-4, 4)), aes(x = x)) +
  stat_function(fun = dt, col = "blue", args = list(df = 1)) +
  stat_function(fun = dt, col = "orange", args = list(df = 2)) +
  stat_function(fun = dt, col = "darkgreen", args = list(df = 5)) +
  stat_function(fun = dt, col = "purple", args = list(df = 10)) +
  stat_function(fun = dt, col = "red", args = list(df = 30)) +
  stat_function(fun = dnorm, col = "black", linetype = "dashed") +
  labs(x = "t", y = "f") +
  ylim(c(0, 0.5))

ggplot(data = data.frame(x = c(-4, 4)), aes(x = x)) +
  stat_function(fun = dt, args = list(df = Inf)) +
  labs(x = "t", y = "f") +
  ylim(c(0, 0.5)) +
  stat_function(fun = dnorm, col = "red", linetype = "dashed")

# Let's look at three different rates visually.
ggplot(data.frame(x = c(0, 3)), aes(x = x)) +
  stat_function(fun = dexp, args = list(rate = 1), colour = "red") +
  stat_function(fun = dexp, args = list(rate = 2), colour = "blue") +
  stat_function(fun = dexp, args = list(rate = 3), colour = "green") +
  labs(x = expression(lambda),y = expression(f(lambda)) ) +
  theme_bw()

# As lambda increases, the density shifts to earlier in the distribution.
# i.e., as the rate per time step (lambda) increases, the average time between
# events decreases.

# generate a specific set of random numbers
set.seed(125) # setting the seed means we can get the same numbers again
rand_vals <- rexp(10, 2)
rand_vals

# remember our random set?
set.seed(125)
rand_vals <- rexp(10, 2)
1 / mean(rand_vals)

set.seed(125)
rand_vals <- rexp(100, 2)
1 / mean(rand_vals)

set.seed(125)
rand_vals <- rexp(10000, 2)
1 / mean(rand_vals)


