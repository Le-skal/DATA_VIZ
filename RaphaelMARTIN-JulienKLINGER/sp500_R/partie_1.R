library(tidyverse)
library(ggplot2)
library(tidyquant)

# ============================================================================
# PARTIE 1 : ANALYSE EXPLORATOIRE - S&P 500 STOCKS (EN TEMPS RÉEL)
# ============================================================================

# Définir les stocks principaux du S&P 500 (top 50)
sp500_symbols <- c(
  "AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V",
  "WMT", "JPM", "PG", "MA", "UNH", "HD", "DIS", "CRM", "MCD", "KO",
  "NFLX", "CSCO", "PEP", "ABT", "ABBV", "MMM", "XOM", "CVX", "BA", "COST",
  "AMD", "INTC", "QCOM", "PYPL", "TXN", "ADBE", "IBM", "AVGO", "ACN", "GILD",
  "CDNS", "MRVL", "OKTA", "CCI", "ANET", "SNPS", "ASML", "NOW", "PANW", "LRCX"
)

# Récupérer les données historiques (dernière année)
cat("Récupération des données S&P 500...\n")
sp500_data <- tq_get(sp500_symbols,
                      from = Sys.Date() - 365,
                      to = Sys.Date(),
                      get = "stock.prices")

# Ajouter les informations de secteur
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

# Joindre les secteurs
sp500_data <- sp500_data %>%
  left_join(sector_info, by = c("symbol" = "symbol"))

# ============================================================================
# EXPLORATION INITIALE DES DONNÉES
# ============================================================================
cat("\n=== EXPLORATION DES DONNÉES ===\n")
cat("Dimensions initiales :", nrow(sp500_data), "lignes x", ncol(sp500_data), "colonnes\n")
head(sp500_data)
str(sp500_data)
summary(sp500_data)

# ============================================================================
# NETTOYAGE DES DONNÉES
# ============================================================================
cat("\n=== NETTOYAGE DES DONNÉES ===\n")

# 1. Vérifier les valeurs manquantes (NA)
cat("\n1. Vérification des valeurs manquantes (NA) :\n")
na_count <- colSums(is.na(sp500_data))
print(na_count)
cat("Total de valeurs manquantes :", sum(na_count), "\n")

# 2. Vérifier les doublons
cat("\n2. Vérification des doublons :\n")
duplicates <- sp500_data %>%
  group_by(symbol, date) %>%
  filter(n() > 1) %>%
  nrow()
cat("Nombre de lignes dupliquées (symbol + date) :", duplicates, "\n")

# 3. Supprimer les lignes avec des valeurs manquantes importantes
cat("\n3. Suppression des lignes avec NA dans les colonnes critiques :\n")
nrow_before <- nrow(sp500_data)
sp500_data <- sp500_data %>%
  filter(!is.na(close), !is.na(volume), !is.na(sector))
nrow_after <- nrow(sp500_data)
cat("Lignes supprimées :", nrow_before - nrow_after, "\n")
cat("Lignes restantes :", nrow_after, "\n")

# 4. Supprimer les doublons exacts
cat("\n4. Suppression des doublons :\n")
nrow_before <- nrow(sp500_data)
sp500_data <- sp500_data %>%
  distinct(symbol, date, .keep_all = TRUE)
nrow_after <- nrow(sp500_data)
cat("Doublons supprimés :", nrow_before - nrow_after, "\n")

# 5. Vérifier la cohérence des données
cat("\n5. Vérification de la cohérence :\n")
cat("- Prix négatifs :", sum(sp500_data$close < 0, na.rm = TRUE), "\n")
cat("- Volumes négatifs :", sum(sp500_data$volume < 0, na.rm = TRUE), "\n")
cat("- Dates valides :", all(sp500_data$date >= (Sys.Date() - 400)), "\n")

# 6. Résumé final
cat("\n=== RÉSUMÉ DU NETTOYAGE ===\n")
cat("Dataset final :", nrow(sp500_data), "lignes x", ncol(sp500_data), "colonnes\n")
cat("Période :", min(sp500_data$date), "à", max(sp500_data$date), "\n")
cat("Nombre d'actions uniques :", n_distinct(sp500_data$symbol), "\n")
cat("Secteurs représentés :", n_distinct(sp500_data$sector), "\n\n")

# ============================================================================
# GRAPHIQUE 1 : Histogramme des prix de fermeture actuels
# ============================================================================
latest_prices <- sp500_data %>%
  group_by(symbol) %>%
  slice(n()) %>%
  ungroup()

p1 <- ggplot(latest_prices, aes(x = close)) +
  geom_histogram(bins = 20, fill = "#1f77b4", color = "black", alpha = 0.7) +
  labs(title = "Distribution des prix de fermeture actuels (S&P 500)",
       x = "Prix de fermeture (USD)",
       y = "Nombre d'actions") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

print(p1)

# ============================================================================
# GRAPHIQUE 2 : Top 15 stocks par prix de fermeture
# ============================================================================
top_price <- latest_prices %>%
  arrange(desc(close)) %>%
  head(15)

p2 <- ggplot(top_price, aes(x = reorder(symbol, close), y = close, fill = sector)) +
  geom_col(alpha = 0.8) +
  coord_flip() +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Top 15 actions par prix de fermeture",
       x = "Symbole",
       y = "Prix de fermeture (USD)",
       fill = "Secteur") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

print(p2)

# ============================================================================
# GRAPHIQUE 3 : Distribution par secteur
# ============================================================================
sector_count <- latest_prices %>%
  group_by(sector) %>%
  summarise(count = n(), avg_price = mean(close), .groups = "drop") %>%
  arrange(desc(count))

p3 <- ggplot(sector_count, aes(x = reorder(sector, count), y = count, fill = sector)) +
  geom_col(alpha = 0.8) +
  geom_text(aes(label = count), hjust = -0.2, size = 4, fontface = "bold") +
  coord_flip() +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Répartition des actions par secteur",
       x = "Secteur",
       y = "Nombre d'actions") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        legend.position = "none")

print(p3)

# ============================================================================
# GRAPHIQUE 4 : Volatilité (écart-type des rendements) par secteur
# ============================================================================
volatility <- sp500_data %>%
  mutate(returns = (close - lag(close)) / lag(close)) %>%
  group_by(symbol, sector) %>%
  summarise(volatility = sd(returns, na.rm = TRUE) * 100, .groups = "drop") %>%
  group_by(sector) %>%
  summarise(avg_volatility = mean(volatility, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(avg_volatility))

p4 <- ggplot(volatility, aes(x = reorder(sector, avg_volatility), y = avg_volatility, fill = avg_volatility)) +
  geom_col(alpha = 0.8) +
  scale_fill_viridis_c(option = "plasma", direction = -1) +
  coord_flip() +
  labs(title = "Volatilité moyenne par secteur",
       x = "Secteur",
       y = "Volatilité (%)",
       fill = "Volatilité") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        legend.position = "right")

print(p4)

# ============================================================================
# GRAPHIQUE 5 : Volume moyen par secteur
# ============================================================================
volume_by_sector <- sp500_data %>%
  group_by(sector) %>%
  summarise(avg_volume = mean(volume, na.rm = TRUE) / 1e6, .groups = "drop") %>%
  arrange(desc(avg_volume))

p5 <- ggplot(volume_by_sector, aes(x = reorder(sector, avg_volume), y = avg_volume, fill = avg_volume)) +
  geom_col(alpha = 0.8) +
  scale_fill_gradient(low = "#1f77b4", high = "#ff7f0e") +
  coord_flip() +
  labs(title = "Volume moyen de trading par secteur",
       x = "Secteur",
       y = "Volume (millions)",
       fill = "Volume") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

print(p5)

cat("\n✓ Partie 1 complétée : Analyse exploratoire\n")
