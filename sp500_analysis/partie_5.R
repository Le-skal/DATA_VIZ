library(tidyverse)
library(ggplot2)
library(plotly)
library(tidyquant)

# ============================================================================
# PARTIE 5 : GRAPHIQUE INTERACTIF PLOTLY - S&P 500
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

cat("Récupération des données S&P 500...\n")
sp500_data <- tq_get(sp500_symbols,
                      from = Sys.Date() - 365,
                      to = Sys.Date(),
                      get = "stock.prices") %>%
  left_join(sector_info, by = c("symbol" = "symbol"))

# ============================================================================
# GRAPHIQUE INTERACTIF 1 : Prix vs Volume (Scatter)
# ============================================================================

latest_data <- sp500_data %>%
  group_by(symbol) %>%
  slice(n()) %>%
  ungroup() %>%
  mutate(
    price_change = 0,
    price_change_pct = 0
  )

# Calculer le changement de prix par rapport à 30 jours plus tôt
price_30d_ago <- sp500_data %>%
  group_by(symbol) %>%
  arrange(date) %>%
  slice(1) %>%
  select(symbol, close_30d_ago = close) %>%
  ungroup()

latest_data <- latest_data %>%
  left_join(price_30d_ago, by = "symbol") %>%
  mutate(
    price_change = close - close_30d_ago,
    price_change_pct = (price_change / close_30d_ago) * 100
  )

p_scatter <- plot_ly(latest_data,
                     x = ~volume / 1e6,
                     y = ~close,
                     color = ~sector,
                     size = ~price_change_pct,
                     type = "scatter",
                     mode = "markers",
                     text = ~paste("<b>", symbol, "</b><br>",
                                   "Prix:", round(close, 2), "USD<br>",
                                   "Volume:", round(volume / 1e6, 2), "M<br>",
                                   "Secteur:", sector, "<br>",
                                   "30j Change:", round(price_change_pct, 2), "%"),
                     hovertemplate = "%{text}<extra></extra>",
                     marker = list(sizemode = "diameter", sizeref = 2 * max(latest_data$price_change_pct, na.rm = TRUE) / (20^2))) %>%
  layout(title = "S&P 500 : Prix vs Volume (Taille = Changement 30j)",
         xaxis = list(title = "Volume (millions)"),
         yaxis = list(title = "Prix (USD)"),
         hovermode = "closest",
         plot_bgcolor = "#f8f9fa",
         paper_bgcolor = "white")

print(p_scatter)

# ============================================================================
# GRAPHIQUE INTERACTIF 2 : Évolution temporelle des Top 5 stocks
# ============================================================================

top_5_symbols <- c("AAPL", "MSFT", "GOOGL", "AMZN", "NVDA")

top_5_data <- sp500_data %>%
  filter(symbol %in% top_5_symbols) %>%
  arrange(date)

p_line <- plot_ly(data = top_5_data,
                  x = ~date,
                  y = ~close,
                  color = ~symbol,
                  type = "scatter",
                  mode = "lines",
                  hovertemplate = "<b>%{fullData.name}</b><br>Date: %{x|%Y-%m-%d}<br>Prix: %{y:.2f} USD<extra></extra>") %>%
  layout(title = "Évolution du prix - Top 5 Actions",
         xaxis = list(title = "Date"),
         yaxis = list(title = "Prix (USD)"),
         hovermode = "x unified",
         plot_bgcolor = "#f8f9fa",
         paper_bgcolor = "white")

print(p_line)

# ============================================================================
# GRAPHIQUE INTERACTIF 3 : Distribution des prix par secteur (Box plot)
# ============================================================================

p_box <- plot_ly(data = sp500_data,
                 x = ~sector,
                 y = ~close,
                 color = ~sector,
                 type = "box",
                 hovertemplate = "Secteur: %{x}<br>Prix: %{y:.2f} USD<extra></extra>") %>%
  layout(title = "Distribution des prix par secteur",
         xaxis = list(title = "Secteur"),
         yaxis = list(title = "Prix (USD)"),
         showlegend = FALSE,
         plot_bgcolor = "#f8f9fa",
         paper_bgcolor = "white")

print(p_box)

# ============================================================================
# GRAPHIQUE INTERACTIF 4 : Heatmap interactive des corrélations secteur
# ============================================================================

latest_prices_wide <- latest_data %>%
  select(symbol, close, sector) %>%
  pivot_wider(names_from = sector, values_from = close, values_fn = mean)

sector_correlation <- sp500_data %>%
  group_by(date, sector) %>%
  summarise(avg_price = mean(close, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = sector, values_from = avg_price) %>%
  select(-date) %>%
  cor(use = "complete.obs")

p_heatmap <- plot_ly(z = sector_correlation,
                     x = colnames(sector_correlation),
                     y = rownames(sector_correlation),
                     type = "heatmap",
                     colorscale = "RdBu",
                     zmid = 0,
                     hovertemplate = "%{y} vs %{x}: %{z:.3f}<extra></extra>") %>%
  layout(title = "Matrice de corrélation des prix par secteur",
         xaxis = list(title = "Secteur"),
         yaxis = list(title = "Secteur"))

print(p_heatmap)

cat("\n✓ Partie 5 complétée : 4 graphiques interactifs Plotly\n")
