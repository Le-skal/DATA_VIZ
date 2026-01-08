library(tidyverse)
library(ggplot2)
library(tidyquant)

# ============================================================================
# PARTIE 2 : ANALYSES TEMPORELLES - S&P 500
# ============================================================================

# Stocks à analyser
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
# GRAPHIQUE 1 : Évolution du prix moyen par secteur
# ============================================================================
price_timeline <- sp500_data %>%
  group_by(date, sector) %>%
  summarise(avg_price = mean(close, na.rm = TRUE), .groups = "drop") %>%
  arrange(date)

p1 <- ggplot(price_timeline, aes(x = date, y = avg_price, color = sector)) +
  geom_line(linewidth = 0.8, alpha = 0.6) +
  geom_smooth(method = "loess", se = TRUE, linewidth = 1.2, alpha = 0.2) +
  scale_color_brewer(palette = "Set3") +
  labs(title = "Évolution du prix moyen par secteur (avec courbe de lissage)",
       x = "Date",
       y = "Prix moyen (USD)",
       color = "Secteur") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1))

print(p1)

# ============================================================================
# GRAPHIQUE 2 : Évolution du volume de trading par secteur
# ============================================================================
volume_timeline <- sp500_data %>%
  group_by(date, sector) %>%
  summarise(total_volume = sum(volume, na.rm = TRUE) / 1e9, .groups = "drop") %>%
  arrange(date)

p2 <- ggplot(volume_timeline, aes(x = date, y = total_volume, fill = sector)) +
  geom_area(alpha = 0.6) +
  scale_fill_brewer(palette = "Set3") +
  labs(title = "Volume total de trading par secteur",
       x = "Date",
       y = "Volume (milliards)",
       fill = "Secteur") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1))

print(p2)

# ============================================================================
# GRAPHIQUE 3 : Heatmap - Rendements par secteur et mois
# ============================================================================
returns_heatmap <- sp500_data %>%
  mutate(
    returns = (close - lag(close)) / lag(close) * 100,
    year_month = format(date, "%Y-%m")
  ) %>%
  group_by(year_month, sector) %>%
  summarise(avg_returns = mean(returns, na.rm = TRUE), .groups = "drop") %>%
  arrange(year_month)

p3 <- ggplot(returns_heatmap, aes(x = year_month, y = sector, fill = avg_returns)) +
  geom_tile(color = "white", linewidth = 0.3) +
  scale_fill_gradient2(low = "#d73027", mid = "#f7f7f7", high = "#1a9850") +
  labs(title = "Heatmap : Rendements moyens par secteur et mois",
       x = "Année-Mois",
       y = "Secteur",
       fill = "Rendement (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
        panel.grid = element_blank())

print(p3)

# ============================================================================
# GRAPHIQUE 4 : Box plot des rendements par secteur
# ============================================================================
returns_sector <- sp500_data %>%
  mutate(returns = (close - lag(close)) / lag(close) * 100) %>%
  filter(!is.na(returns))

p4 <- ggplot(returns_sector, aes(x = reorder(sector, returns, FUN = median), y = returns, fill = sector)) +
  geom_boxplot(alpha = 0.7) +
  scale_fill_brewer(palette = "Set3") +
  coord_flip() +
  labs(title = "Distribution des rendements quotidiens par secteur",
       x = "Secteur",
       y = "Rendement (%)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        legend.position = "none")

print(p4)

# ============================================================================
# GRAPHIQUE 5 : Évolution du prix des Top 5 actions
# ============================================================================
top_5_symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN", "NVDA")

top_5_data <- sp500_data %>%
  filter(symbol %in% top_5_symbols) %>%
  group_by(symbol) %>%
  mutate(normalized_price = close / first(close) * 100) %>%
  ungroup()

p5 <- ggplot(top_5_data, aes(x = date, y = normalized_price, color = symbol)) +
  geom_line(linewidth = 1) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Évolution normalisée des Top 5 actions (100 = premier prix)",
       x = "Date",
       y = "Prix normalisé (indice)",
       color = "Action") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text.x = element_text(angle = 45, hjust = 1))

print(p5)

cat("\n✓ Partie 2 complétée : Analyses temporelles\n")
