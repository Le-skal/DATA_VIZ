library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(tidyquant)

# ============================================================================
# PARTIE 6 : DASHBOARD INTERACTIF SHINY - S&P 500
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

cat("Chargement des données S&P 500...\n")
sp500_data <- tq_get(sp500_symbols,
                      from = Sys.Date() - 365,
                      to = Sys.Date(),
                      get = "stock.prices") %>%
  left_join(sector_info, by = c("symbol" = "symbol"))

# ============================================================================
# INTERFACE UTILISATEUR (UI)
# ============================================================================

ui <- fluidPage(
  titlePanel(h1("S&P 500 Analytics Dashboard", style = "text-align: center; color: #1f77b4;")),
  
  sidebarLayout(
    sidebarPanel(
      h3("Filtres"),
      
      # Filtre par secteur
      selectInput("sector_filter", "Secteur:", 
                  choices = c("Tous", unique(na.omit(sector_info$sector)))),
      
      # Filtre par symbole
      selectInput("symbol_filter", "Actions (top 10):", 
                  choices = c("Tous", "AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V"),
                  multiple = TRUE),
      
      # Filtre par plage de prix
      sliderInput("price_range", "Plage de prix (USD):",
                  min = 0,
                  max = 500,
                  value = c(0, 500),
                  step = 10),
      
      # Filtre par plage de dates
      dateRangeInput("date_range", "Plage de dates:",
                     start = Sys.Date() - 365,
                     end = Sys.Date(),
                     format = "yyyy-mm-dd"),
      
      hr(),
      h4("À propos"),
      p("Dashboard en temps réel des données du S&P 500.")
    ),
    
    mainPanel(
      tabsetPanel(
        # ================================================================
        # TAB 1 : GRAPHIQUE PRINCIPAL
        # ================================================================
        tabPanel("Vue principale",
                 h3("Évolution du prix"),
                 plotlyOutput("main_plot", height = "600px"),
                 br(),
                 h4("Statistiques clés"),
                 fluidRow(
                   column(3, 
                          wellPanel(
                            h4("Actions", style = "text-align: center;"),
                            h2(textOutput("total_actions"), style = "text-align: center; color: #3c8dbc;")
                          )),
                   column(3, 
                          wellPanel(
                            h4("Prix moyen (USD)", style = "text-align: center;"),
                            h2(textOutput("avg_price"), style = "text-align: center; color: #00a65a;")
                          )),
                   column(3, 
                          wellPanel(
                            h4("Prix max (USD)", style = "text-align: center;"),
                            h2(textOutput("max_price"), style = "text-align: center; color: #f39c12;")
                          )),
                   column(3, 
                          wellPanel(
                            h4("Prix min (USD)", style = "text-align: center;"),
                            h2(textOutput("min_price"), style = "text-align: center; color: #dd4b39;")
                          ))
                 )
        ),
        
        # ================================================================
        # TAB 2 : ANALYSE PAR SECTEUR
        # ================================================================
        tabPanel("Analyse par secteur",
                 h3("Distribution par secteur"),
                 plotlyOutput("sector_plot", height = "500px"),
                 br(),
                 h3("Volatilité par secteur"),
                 plotlyOutput("volatility_plot", height = "500px")
        ),
        
        # ================================================================
        # TAB 3 : TABLEAU DE DONNÉES
        # ================================================================
        tabPanel("Données filtrées",
                 h3("Tableau des prix actuels"),
                 dataTableOutput("data_table")
        ),
        
        # ================================================================
        # TAB 4 : STATISTIQUES DÉTAILLÉES
        # ================================================================
        tabPanel("Statistiques",
                 h3("Résumé des statistiques"),
                 fluidRow(
                   column(6, verbatimTextOutput("stats_summary")),
                   column(6, verbatimTextOutput("price_summary"))
                 ),
                 br(),
                 h3("Rendements par secteur"),
                 plotlyOutput("returns_plot", height = "500px")
        ),
        
        # ================================================================
        # TAB 5 : COMPARAISON D'ACTIONS
        # ================================================================
        tabPanel("Comparaison",
                 h3("Comparaison des actions sélectionnées"),
                 plotlyOutput("comparison_plot", height = "600px"),
                 br(),
                 h3("Volume de trading"),
                 plotlyOutput("volume_plot", height = "500px")
        )
      )
    )
  )
)

# ============================================================================
# LOGIQUE DU SERVEUR (SERVER)
# ============================================================================

server <- function(input, output, session) {
  
  # Filtrées les données selon les sélections
  filtered_data <- reactive({
    data <- sp500_data
    
    # Filtre par secteur
    if (input$sector_filter != "Tous") {
      data <- data %>%
        filter(sector == input$sector_filter)
    }
    
    # Filtre par symbole
    if (!is.null(input$symbol_filter) && length(input$symbol_filter) > 0 && input$symbol_filter[1] != "Tous") {
      data <- data %>%
        filter(symbol %in% input$symbol_filter)
    }
    
    # Filtre par plage de prix
    data <- data %>%
      filter(close >= input$price_range[1],
             close <= input$price_range[2])
    
    # Filtre par plage de dates
    data <- data %>%
      filter(date >= input$date_range[1],
             date <= input$date_range[2])
    
    return(data)
  })
  
  # ====================================================================
  # TAB 1 : GRAPHIQUE PRINCIPAL
  # ====================================================================
  
  output$main_plot <- renderPlotly({
    if (nrow(filtered_data()) == 0) {
      return(plot_ly() %>% add_text(x = 0.5, y = 0.5, text = "Aucune donnée disponible",
                                     textposition = "center"))
    }
    
    plot_data <- filtered_data() %>%
      arrange(date)
    
    plot_ly(plot_data, x = ~date, y = ~close, color = ~symbol,
            type = "scatter", mode = "lines",
            hovertemplate = "<b>%{fullData.name}</b><br>Date: %{x|%Y-%m-%d}<br>Prix: %{y:.2f} USD<extra></extra>") %>%
      layout(title = "Évolution du prix",
             xaxis = list(title = "Date"),
             yaxis = list(title = "Prix (USD)"),
             hovermode = "x unified")
  })
  
  # Boîtes statistiques
  output$total_actions <- renderText({
    n_actions <- filtered_data() %>% distinct(symbol) %>% nrow()
    as.character(n_actions)
  })
  
  output$avg_price <- renderText({
    avg <- filtered_data() %>% summarise(mean(close, na.rm = TRUE)) %>% pull()
    paste0("$", round(avg, 2))
  })
  
  output$max_price <- renderText({
    max_p <- filtered_data() %>% summarise(max(close, na.rm = TRUE)) %>% pull()
    paste0("$", round(max_p, 2))
  })
  
  output$min_price <- renderText({
    min_p <- filtered_data() %>% summarise(min(close, na.rm = TRUE)) %>% pull()
    paste0("$", round(min_p, 2))
  })
  
  # ====================================================================
  # TAB 2 : ANALYSE PAR SECTEUR
  # ====================================================================
  
  output$sector_plot <- renderPlotly({
    sector_data <- filtered_data() %>%
      group_by(sector) %>%
      summarise(count = n(), avg_price = mean(close, na.rm = TRUE), .groups = "drop") %>%
      arrange(desc(count))
    
    plot_ly(sector_data, x = ~reorder(sector, count), y = ~count,
            type = "bar", color = ~sector,
            hovertemplate = "<b>%{x}</b><br>Nombre: %{y}<extra></extra>") %>%
      layout(title = "Distribution par secteur",
             xaxis = list(title = "Secteur"),
             yaxis = list(title = "Nombre d'actions"),
             showlegend = FALSE)
  })
  
  output$volatility_plot <- renderPlotly({
    volatility_data <- filtered_data() %>%
      mutate(returns = (close - lag(close)) / lag(close) * 100) %>%
      group_by(sector) %>%
      summarise(volatility = sd(returns, na.rm = TRUE), .groups = "drop") %>%
      arrange(desc(volatility))
    
    plot_ly(volatility_data, x = ~reorder(sector, volatility), y = ~volatility,
            type = "bar", color = ~volatility,
            hovertemplate = "<b>%{x}</b><br>Volatilité: %{y:.2f}%<extra></extra>") %>%
      layout(title = "Volatilité par secteur",
             xaxis = list(title = "Secteur"),
             yaxis = list(title = "Volatilité (%)"))
  })
  
  # ====================================================================
  # TAB 3 : TABLEAU DE DONNÉES
  # ====================================================================
  
  output$data_table <- renderDataTable({
    filtered_data() %>%
      group_by(symbol) %>%
      slice(n()) %>%
      ungroup() %>%
      select(symbol, sector, close, volume, date) %>%
      arrange(desc(close)) %>%
      rename("Action" = symbol,
             "Secteur" = sector,
             "Prix (USD)" = close,
             "Volume" = volume,
             "Date" = date)
  })
  
  # ====================================================================
  # TAB 4 : STATISTIQUES
  # ====================================================================
  
  output$stats_summary <- renderPrint({
    data <- filtered_data()
    cat("=== RÉSUMÉ STATISTIQUE ===\n\n")
    cat("Nombre de lignes:", nrow(data), "\n")
    cat("Nombre d'actions:", n_distinct(data$symbol), "\n")
    cat("Nombre de secteurs:", n_distinct(data$sector), "\n")
    cat("Plage de dates:", min(data$date), "à", max(data$date), "\n")
  })
  
  output$price_summary <- renderPrint({
    data <- filtered_data()
    summary(data$close)
  })
  
  output$returns_plot <- renderPlotly({
    returns_data <- filtered_data() %>%
      mutate(returns = (close - lag(close)) / lag(close) * 100) %>%
      filter(!is.na(returns)) %>%
      group_by(sector) %>%
      summarise(avg_returns = mean(returns, na.rm = TRUE), .groups = "drop")
    
    plot_ly(returns_data, x = ~sector, y = ~avg_returns,
            type = "bar", color = ~ifelse(avg_returns >= 0, "positive", "negative"),
            hovertemplate = "<b>%{x}</b><br>Rendement moyen: %{y:.2f}%<extra></extra>") %>%
      layout(title = "Rendements quotidiens moyens par secteur",
             xaxis = list(title = "Secteur"),
             yaxis = list(title = "Rendement moyen (%)"),
             showlegend = FALSE)
  })
  
  # ====================================================================
  # TAB 5 : COMPARAISON
  # ====================================================================
  
  output$comparison_plot <- renderPlotly({
    comparison_data <- filtered_data() %>%
      group_by(symbol) %>%
      summarise(avg_price = mean(close, na.rm = TRUE),
                max_price = max(close, na.rm = TRUE),
                min_price = min(close, na.rm = TRUE),
                .groups = "drop") %>%
      arrange(desc(avg_price)) %>%
      head(10)
    
    plot_ly(comparison_data,
            x = ~symbol,
            y = ~avg_price,
            error_y = list(
              symmetric = FALSE,
              array = ~(max_price - avg_price),
              arrayminus = ~(avg_price - min_price)
            ),
            type = "bar",
            hovertemplate = "<b>%{x}</b><br>Prix moyen: %{y:.2f} USD<extra></extra>") %>%
      layout(title = "Comparaison des prix (min/moyen/max)",
             xaxis = list(title = "Action"),
             yaxis = list(title = "Prix (USD)"))
  })
  
  output$volume_plot <- renderPlotly({
    volume_data <- filtered_data() %>%
      group_by(symbol) %>%
      summarise(avg_volume = mean(volume, na.rm = TRUE) / 1e6, .groups = "drop") %>%
      arrange(desc(avg_volume)) %>%
      head(10)
    
    plot_ly(volume_data,
            x = ~reorder(symbol, avg_volume),
            y = ~avg_volume,
            type = "bar",
            color = ~avg_volume,
            hovertemplate = "<b>%{x}</b><br>Volume moyen: %{y:.2f}M<extra></extra>") %>%
      layout(title = "Volume de trading moyen",
             xaxis = list(title = "Action"),
             yaxis = list(title = "Volume (millions)"),
             showlegend = FALSE)
  })
}

# ============================================================================
# LANCER L'APPLICATION
# ============================================================================

shinyApp(ui = ui, server = server)
