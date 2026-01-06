library(tidyverse)
library(ggplot2)
library(plotly)
library(sf)
library(gganimate)

netflix <- read.csv("netflix_titles.csv")

head(netflix)
dim(netflix)
str(netflix)
summary(netflix)

netflix <- netflix %>%
  distinct() %>%
  mutate(
    date_added = as.Date(date_added, format = "%B %d, %Y"),
    release_year = as.numeric(release_year)
  ) %>%
  filter(!is.na(release_year))

glimpse(netflix)

# Histogramme année de sortie
p1 <- ggplot(netflix, aes(x = release_year)) +
  geom_histogram(bins = 30, fill = "#E50914", color = "black", alpha = 0.7) +
  labs(title = "Distribution des années de sortie",
       x = "Année de sortie",
       y = "Nombre de contenus") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

print(p1)

# Top 10 pays producteurs
netflix_countries <- netflix %>%
  separate_rows(country, sep = ", ") %>%
  filter(!is.na(country)) %>%
  group_by(country) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(desc(count)) %>%
  head(10)

p2 <- ggplot(netflix_countries, aes(x = reorder(country, count), y = count)) +
  geom_col(fill = "#E50914", alpha = 0.8) +
  coord_flip() +
  labs(title = "Top 10 des pays producteurs",
       x = "Pays",
       y = "Nombre de contenus") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

print(p2)

# Répartition films vs séries
netflix_type <- netflix %>%
  group_by(type) %>%
  summarise(count = n(), .groups = "drop")

p3 <- ggplot(netflix_type, aes(x = type, y = count, fill = type)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = count), vjust = -0.5, size = 5, fontface = "bold") +
  scale_fill_manual(values = c("Movie" = "#E50914", "TV Show" = "#221F1F")) +
  labs(title = "Répartition films vs séries",
       x = "Type",
       y = "Nombre") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        legend.position = "none")

print(p3)
