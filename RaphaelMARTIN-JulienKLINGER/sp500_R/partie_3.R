library(tidyverse)
library(ggplot2)
library(tidyquant)
library(maps)

# ============================================================================
# PARTIE 3 : VISUALISATION GÉOGRAPHIQUE - S&P 500
# ============================================================================

sp500_symbols <- c(
  "AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V",
  "WMT", "JPM", "PG", "MA", "UNH", "HD", "DIS", "CRM", "MCD", "KO",
  "NFLX", "CSCO", "PEP", "ABT", "ABBV", "MMM", "XOM", "CVX", "BA", "COST",
  "AMD", "INTC", "QCOM", "PYPL", "TXN", "ADBE", "IBM", "AVGO", "ACN", "GILD",
  "CDNS", "MRVL", "OKTA", "CCI", "ANET", "SNPS", "ASML", "NOW", "PANW", "LRCX"
)

sector_info <- data.frame(
  symbol = c("AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V",
             "WMT", "JPM", "PG", "MA", "UNH", "HD", "DIS", "CRM", "MCD", "KO",
             "NFLX", "CSCO", "PEP", "ABT", "ABBV", "MMM", "XOM", "CVX", "BA", "COST",
             "AMD", "INTC", "QCOM", "PYPL", "TXN", "ADBE", "IBM", "AVGO", "ACN", "GILD",
             "CDNS", "MRVL", "OKTA", "CCI", "ANET", "SNPS", "ASML", "NOW", "PANW", "LRCX"),
  sector = c("Technology", "Technology", "Technology", "Consumer", "Technology", "Technology", "Consumer", "Finance", "Healthcare", "Finance",
            "Consumer", "Finance", "Consumer", "Finance", "Healthcare", "Consumer", "Consumer", "Technology", "Consumer", "Consumer",
            "Technology", "Technology", "Consumer", "Healthcare", "Healthcare", "Industrial", "Energy", "Energy", "Industrial", "Consumer",
            "Technology", "Technology", "Technology", "Finance", "Technology", "Technology", "Technology", "Technology", "Technology", "Healthcare",
            "Technology", "Technology", "Technology", "Real Estate", "Technology", "Technology", "Technology", "Technology", "Technology", "Technology")
)

# Informations de localisation des sièges sociaux (États USA)
location_info <- data.frame(
  symbol = c("AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V",
             "WMT", "JPM", "PG", "MA", "UNH", "HD", "DIS", "CRM", "MCD", "KO",
             "NFLX", "CSCO", "PEP", "ABT", "ABBV", "MMM", "XOM", "CVX", "BA", "COST",
             "AMD", "INTC", "QCOM", "PYPL", "TXN", "ADBE", "IBM", "AVGO", "ACN", "GILD",
             "CDNS", "MRVL", "OKTA", "CCI", "ANET", "SNPS", "ASML", "NOW", "PANW", "LRCX"),
  state = c("CA", "WA", "CA", "WA", "CA", "CA", "TX", "NE", "NJ", "CA",
           "AR", "NY", "OH", "NY", "MN", "GA", "FL", "CA", "IL", "GA",
           "CA", "CA", "NY", "NJ", "IL", "MN", "TX", "TX", "WA", "WA",
           "CA", "CA", "CA", "CA", "TX", "CA", "NY", "CA", "TX", "NJ",
           "CA", "CA", "CA", "MA", "CA", "CA", "CA", "CA", "CA", "CA"),
  lat = c(37.33, 47.61, 37.42, 47.61, 37.49, 37.48, 30.27, 41.14, 40.37, 37.57,
         34.74, 40.71, 39.96, 40.76, 44.98, 33.75, 28.43, 37.79, 41.88, 33.75,
         37.77, 37.39, 42.66, 40.37, 42.68, 46.73, 29.76, 29.76, 47.61, 47.61,
         37.49, 47.61, 37.57, 37.77, 30.27, 37.79, 40.75, 37.49, 40.37, 40.37,
         37.77, 37.49, 37.75, 42.28, 37.75, 37.75, 37.49, 37.97, 37.49, 37.49),
  lon = c(-122.03, -122.33, -122.08, -122.33, -122.19, -122.15, -97.74, -95.68, -74.06, -122.27,
         -92.28, -74.01, -84.27, -73.97, -93.28, -84.39, -81.38, -122.27, -87.63, -84.27,
         -122.27, -122.27, -71.06, -74.06, -93.30, -93.30, -95.38, -95.38, -122.33, -122.33,
         -122.19, -122.33, -122.27, -122.27, -97.74, -122.27, -73.98, -122.19, -74.06, -74.06,
         -122.27, -122.19, -122.27, -71.06, -122.27, -122.27, -122.19, -122.27, -122.19, -122.19)
)

cat("Récupération des données S&P 500...\n")
sp500_data <- tq_get(sp500_symbols,
                      from = Sys.Date() - 365,
                      to = Sys.Date(),
                      get = "stock.prices") %>%
  left_join(sector_info, by = c("symbol" = "symbol")) %>%
  left_join(location_info, by = "symbol")

# ============================================================================
# GRAPHIQUE 1 : Distribution des stocks par état (États-Unis)
# ============================================================================
latest_prices <- sp500_data %>%
  group_by(symbol) %>%
  slice(n()) %>%
  ungroup()

state_distribution <- latest_prices %>%
  group_by(state) %>%
  summarise(count = n(), avg_price = mean(close, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(count))

p1 <- ggplot(state_distribution %>% head(15), 
             aes(x = reorder(state, count), y = count, fill = count)) +
  geom_col(alpha = 0.8) +
  scale_fill_gradient(low = "#1f77b4", high = "#ff7f0e") +
  coord_flip() +
  labs(title = "Top 15 États avec le plus de sièges sociaux S&P 500",
       x = "État",
       y = "Nombre de sociétés",
       fill = "Nombre") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

print(p1)

# ============================================================================
# GRAPHIQUE 2 : Prix moyen par état
# ============================================================================
p2 <- ggplot(state_distribution %>% head(15),
             aes(x = reorder(state, avg_price), y = avg_price, fill = avg_price)) +
  geom_col(alpha = 0.8) +
  scale_fill_viridis_c(option = "plasma") +
  coord_flip() +
  labs(title = "Prix moyen des actions par état",
       x = "État",
       y = "Prix moyen (USD)",
       fill = "Prix moyen") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

print(p2)

# ============================================================================
# GRAPHIQUE 3 : Scatter géographique (lat/lon)
# ============================================================================
p3 <- ggplot(latest_prices %>% distinct(symbol, .keep_all = TRUE), 
             aes(x = lon, y = lat, size = close, color = sector)) +
  geom_point(alpha = 0.6) +
  scale_color_brewer(palette = "Set3") +
  scale_size_continuous(range = c(2, 10)) +
  labs(title = "Localisation des sièges sociaux S&P 500 (lat/lon)",
       x = "Longitude",
       y = "Latitude",
       color = "Secteur",
       size = "Prix (USD)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

print(p3)

# ============================================================================
# GRAPHIQUE 4 : Heatmap secteur par état
# ============================================================================
sector_state <- latest_prices %>%
  group_by(state, sector) %>%
  summarise(count = n(), .groups = "drop") %>%
  filter(!is.na(state), !is.na(sector))

p4 <- ggplot(sector_state %>% 
             filter(state %in% (latest_prices %>% group_by(state) %>% summarise(n = n()) %>% 
                               arrange(desc(n)) %>% head(10) %>% pull(state))),
             aes(x = sector, y = state, fill = count)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_viridis_c(option = "viridis") +
  labs(title = "Heatmap : Secteur × État (Top 10 États)",
       x = "Secteur",
       y = "État",
       fill = "Nombre") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank())

print(p4)

# ============================================================================
# GRAPHIQUE 5 : CARTE USA avec nombre de sociétés par état
# ============================================================================

# Récupérer la carte des états USA
usa_states <- map_data("state")

# Préparer les données par état (conversion en minuscules)
state_mapping <- data.frame(
  state_code = c("CA", "WA", "NY", "TX", "NJ", "OH", "IL", "GA", "FL", "MN", 
                 "AR", "NE", "MA"),
  state_name = c("california", "washington", "new york", "texas", "new jersey", 
                 "ohio", "illinois", "georgia", "florida", "minnesota", 
                 "arkansas", "nebraska", "massachusetts")
)

state_counts <- latest_prices %>%
  group_by(state) %>%
  summarise(count = n(), avg_price = mean(close, na.rm = TRUE), .groups = "drop") %>%
  left_join(state_mapping, by = c("state" = "state_code")) %>%
  filter(!is.na(state_name))

# Joindre avec la carte
usa_map_data <- usa_states %>%
  left_join(state_counts, by = c("region" = "state_name"))

p5 <- ggplot(usa_map_data, aes(x = long, y = lat, group = group, fill = count)) +
  geom_polygon(color = "white", linewidth = 0.3) +
  scale_fill_gradient(low = "#f0f0f0", high = "#E50914", 
                      na.value = "lightgrey",
                      name = "Nombre de\nsociétés") +
  coord_fixed(1.3) +
  labs(title = "Carte USA : Nombre de sièges sociaux S&P 500 par État",
       x = NULL,
       y = NULL) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        panel.background = element_rect(fill = "white", color = NA))

print(p5)

cat("\n✓ Partie 3 complétée : Visualisation géographique avec carte USA\n")
