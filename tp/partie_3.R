library(tidyverse)
library(ggplot2)
library(sf)
library(rnaturalearth)

netflix <- read.csv("netflix_titles.csv")

netflix <- netflix %>%
  distinct() %>%
  mutate(
    date_added = as.Date(date_added, format = "%B %d, %Y"),
    release_year = as.numeric(release_year)
  ) %>%
  filter(!is.na(release_year))

netflix_by_country <- netflix %>%
  separate_rows(country, sep = ", ") %>%
  filter(!is.na(country)) %>%
  group_by(country) %>%
  summarise(count = n(), .groups = "drop")

world <- ne_countries(returnclass = "sf")

world_netflix <- world %>%
  left_join(netflix_by_country, by = c("name" = "country"))

p_map <- ggplot(world_netflix) +
  geom_sf(aes(fill = log10(count + 1)), color = NA) +
  scale_fill_viridis_c(option = "viridis", na.value = "lightgrey") +
  labs(title = "Production Netflix par pays",
       fill = "Nombre de titres\n(échelle log)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text = element_blank(),
        panel.grid = element_blank())

print(p_map)
