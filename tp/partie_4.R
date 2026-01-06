library(tidyverse)
library(ggplot2)
library(gganimate)
library(gifski)

netflix <- read.csv("netflix_titles.csv")

netflix <- netflix %>%
  distinct() %>%
  mutate(
    date_added = as.Date(date_added, format = "%B %d, %Y"),
    release_year = as.numeric(release_year)
  ) %>%
  filter(!is.na(release_year))

netflix_yearly <- netflix %>%
  group_by(release_year, type) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(release_year) %>%
  group_by(type) %>%
  mutate(cumulative = cumsum(count)) %>%
  ungroup()

p_anim <- ggplot(netflix_yearly, aes(x = type, y = cumulative, fill = type)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = cumulative), vjust = -0.5, size = 5, fontface = "bold") +
  scale_fill_manual(values = c("Movie" = "#E50914", "TV Show" = "#221F1F")) +
  labs(title = "Progression Netflix - Year: {frame_time}",
       x = "Type",
       y = "Nombre cumulatif",
       fill = "Type") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        legend.position = "none") +
  transition_time(release_year) +
  ease_aes("linear")

anim <- animate(p_anim, fps = 10, duration = 10, width = 800, height = 600, renderer = magick_renderer())
anim_save("netflix_animation.gif", animation = anim)