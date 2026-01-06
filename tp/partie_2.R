library(tidyverse)
library(ggplot2)

netflix <- read.csv("netflix_titles.csv")

netflix <- netflix %>%
  distinct() %>%
  mutate(
    date_added = as.Date(date_added, format = "%B %d, %Y"),
    release_year = as.numeric(release_year)
  ) %>%
  filter(!is.na(release_year))

# Analyse temporelle
netflix_timeline <- netflix %>%
  group_by(date_added) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(!is.na(date_added)) %>%
  arrange(date_added)

p_timeline <- ggplot(netflix_timeline, aes(x = date_added, y = count)) +
  geom_area(fill = "#E50914", alpha = 0.4) +
  geom_line(color = "#E50914", linewidth = 1) +
  geom_smooth(method = "loess", color = "black", se = TRUE, alpha = 0.1) +
  labs(title = "Évolution du nombre de contenus ajoutés",
       x = "Date d'ajout",
       y = "Nombre de contenus") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        panel.grid.major = element_line(color = "grey90"),
        axis.text.x = element_text(angle = 45, hjust = 1))

print(p_timeline)

# Analyse des genres
netflix_genres <- netflix %>%
  separate_rows(listed_in, sep = ", ") %>%
  filter(!is.na(listed_in)) %>%
  group_by(listed_in) %>%
  summarise(count = n(), .groups = "drop") %>%
  arrange(desc(count)) %>%
  head(15)

p_genres <- ggplot(netflix_genres, aes(x = reorder(listed_in, count), y = count, fill = count)) +
  geom_col(alpha = 0.85) +
  scale_fill_viridis_c(option = "plasma", direction = -1) +
  coord_flip() +
  labs(title = "Top 15 des genres les plus fréquents",
       x = "Genre",
       y = "Nombre de titres",
       fill = "Fréquence") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        legend.position = "right")

print(p_genres)

# Heatmap multivariée
netflix_heatmap <- netflix %>%
  group_by(release_year, rating) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(!is.na(rating)) %>%
  arrange(release_year, rating)

p_heatmap <- ggplot(netflix_heatmap, aes(x = as.factor(release_year), y = rating, fill = count)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_viridis_c(option = "viridis", direction = 1) +
  labs(title = "Heatmap : Année de sortie × Rating",
       x = "Année de sortie",
       y = "Rating",
       fill = "Nombre de titres") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        panel.grid = element_blank())

print(p_heatmap)
