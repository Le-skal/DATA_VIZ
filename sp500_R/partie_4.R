library(tidyverse)
library(ggplot2)
library(gganimate)
library(tidyquant)

# ============================================================================
# PARTIE 4 : ANIMATION - ÉVOLUTION S&P 500
# ============================================================================

# Définir le dossier de sortie (même dossier que le script)
output_dir <- "C:/Users/USER/Desktop/bachelor-3-ece/Visualisation/TP6/sp500_analysis"

# Vérifier que le dossier existe
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

cat("Les GIFs seront sauvegardés dans :", output_dir, "\n")
cat("Le dossier existe :", dir.exists(output_dir), "\n\n")

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

cat("Récupération des données S&P 500...\n")
sp500_data <- tq_get(sp500_symbols,
                      from = Sys.Date() - 365,
                      to = Sys.Date(),
                      get = "stock.prices") %>%
  left_join(sector_info, by = c("symbol" = "symbol"))

# ============================================================================
# ANIMATION 1 : Évolution du prix des Top 10 stocks
# ============================================================================

top_10_symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V")

top_10_data <- sp500_data %>%
  filter(symbol %in% top_10_symbols) %>%
  arrange(date) %>%
  group_by(symbol) %>%
  mutate(normalized_price = close / first(close) * 100) %>%
  ungroup() %>%
  mutate(year_month = format(date, "%Y-%m"))

p_anim_1 <- ggplot(top_10_data, aes(x = symbol, y = close, fill = sector)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Évolution du prix - Période: {frame_time}",
       x = "Symbole",
       y = "Prix (USD)",
       fill = "Secteur") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1)) +
  transition_time(date) +
  ease_aes("linear")

cat("Création de l'animation 1...\n")
anim_1 <- animate(p_anim_1, nframes = 100, fps = 10, width = 800, height = 600, renderer = gifski_renderer())
anim_save(file.path(output_dir, "sp500_price_evolution.gif"), animation = anim_1)

# ============================================================================
# ANIMATION 2 : Évolution cumulée du prix par secteur
# ============================================================================

sector_cumulative <- sp500_data %>%
  arrange(date) %>%
  group_by(symbol, sector) %>%
  mutate(price_change_pct = (close - first(close)) / first(close) * 100) %>%
  ungroup() %>%
  group_by(date, sector) %>%
  summarise(avg_change = mean(price_change_pct, na.rm = TRUE), .groups = "drop") %>%
  arrange(date)

p_anim_2 <- ggplot(sector_cumulative, aes(x = sector, y = avg_change, fill = sector)) +
  geom_col(alpha = 0.8) +
  scale_fill_brewer(palette = "Set3") +
  coord_flip() +
  labs(title = "Changement cumulé de prix par secteur - {frame_time}",
       x = "Secteur",
       y = "Changement (%)",
       fill = "Secteur") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        legend.position = "none") +
  transition_time(date) +
  ease_aes("linear")

cat("Création de l'animation 2...\n")
anim_2 <- animate(p_anim_2, nframes = 100, fps = 10, width = 800, height = 600, renderer = gifski_renderer())
anim_save(file.path(output_dir, "sp500_sector_change.gif"), animation = anim_2)

# ============================================================================
# ANIMATION 3 : Classement des Top 5 stocks
# ============================================================================

ranking_data <- sp500_data %>%
  arrange(date) %>%
  group_by(date) %>%
  mutate(rank = rank(-close)) %>%
  ungroup() %>%
  filter(rank <= 5) %>%
  arrange(date, rank)

p_anim_3 <- ggplot(ranking_data, aes(x = -rank, y = close, fill = sector)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = symbol), hjust = -0.1, size = 5, fontface = "bold") +
  scale_fill_brewer(palette = "Set3") +
  coord_flip() +
  labs(title = "Top 5 Actions par prix - {frame_time}",
       x = "Rang",
       y = "Prix (USD)",
       fill = "Secteur") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.y = element_blank(),
        legend.position = "right") +
  transition_time(date) +
  ease_aes("linear")

cat("Création de l'animation 3...\n")
anim_3 <- animate(p_anim_3, nframes = 100, fps = 10, width = 800, height = 600, renderer = gifski_renderer())
anim_save(file.path(output_dir, "sp500_top5_ranking.gif"), animation = anim_3)

cat("\n✓ Partie 4 complétée : 3 animations créées\n")
cat("  - sp500_price_evolution.gif\n")
cat("  - sp500_sector_change.gif\n")
cat("  - sp500_top5_ranking.gif\n")
cat("\nFichiers sauvegardés dans :", output_dir, "\n")
