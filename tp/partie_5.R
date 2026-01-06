library(tidyverse)
library(ggplot2)
library(plotly)

netflix <- read.csv("netflix_titles.csv")

netflix <- netflix %>%
  distinct() %>%
  mutate(
    date_added = as.Date(date_added, format = "%B %d, %Y"),
    release_year = as.numeric(release_year)
  ) %>%
  filter(!is.na(release_year))

netflix_scatter <- netflix %>%
  mutate(
    duration_numeric = case_when(
      type == "Movie" ~ as.numeric(gsub(" min", "", duration)),
      type == "TV Show" ~ as.numeric(gsub(" Seasons?", "", duration)),
      TRUE ~ NA_real_
    )
  ) %>%
  filter(!is.na(duration_numeric)) %>%
  select(title, director, country, release_year, duration_numeric, type)

p_scatter <- plot_ly(netflix_scatter, 
                     x = ~release_year, 
                     y = ~duration_numeric,
                     color = ~type,
                     text = ~paste("<b>", title, "</b><br>",
                                   "Réalisateur:", director, "<br>",
                                   "Pays:", country),
                     mode = "markers",
                     type = "scatter",
                     hovertemplate = "%{text}<extra></extra>") %>%
  layout(title = "Scatter plot interactif Netflix",
         xaxis = list(title = "Année de sortie"),
         yaxis = list(title = "Durée"),
         hovermode = "closest")

p_scatter