rm(list=ls())

# Load libraries
library(dplyr)
library(stringr)
library(rmarkdown)
library(htmltools)
library(knitr)
library(kableExtra)

# Load functions
source("R/set_exercises.R")

# Load data
exercises <- read.csv("data/exercises.csv", stringsAsFactors = FALSE)

# Set workout params
n_warm.up <- 5
n_exercises <- 10
workout_type <- NULL
n_cool.down <- 5

# Run functions to generate tables
warmup <- set_exercises(n_ex = n_warm.up, warmup = TRUE, type = NULL)
workout <- set_exercises(n_ex = n_exercises, type = workout_type)
cooldown <- set_exercises(n_ex = n_cool.down, cooldown = TRUE, type = NULL)

# Run function to generate workout
rmarkdown::render("workout_viewer.Rmd")

#-- Save Workout with date -----------------------------------------------------

# Bind tables together
whole_workout <- bind_rows(warmup, workout, cooldown)

# Write filename
fn <- paste0("outputs/workout_", format(Sys.Date(), format="%Y_%m_%d"), ".csv")

# Save file
write.csv(whole_workout, fn, row.names = FALSE)
