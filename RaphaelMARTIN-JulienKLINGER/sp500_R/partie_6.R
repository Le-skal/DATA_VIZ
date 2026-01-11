library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(tidyquant)
library(shinydashboard)

# ============================================================================
# PARTIE 6 : DASHBOARD INTERACTIF SHINY - S&P 500 (STYLE MINIMALISTE)
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
# CUSTOM CSS STYLING - MINIMALISTE NOIR/BEIGE
# ============================================================================

custom_css <- "
  @import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@300;400;500;600;700&display=swap');
  
  * {
    border-radius: 0 !important;
  }
  
  body {
    font-family: 'IBM Plex Mono', monospace;
    background: #0a0a0a;
    color: #d4c5b9;
  }
  
  .main-header .logo {
    background: #000000 !important;
    font-weight: 700;
    font-size: 18px;
    letter-spacing: 2px;
    text-transform: uppercase;
    border-bottom: 2px solid #d4c5b9;
  }
  
  .main-header .navbar {
    background: #000000 !important;
    border-bottom: 2px solid #d4c5b9;
  }
  
  .content-wrapper {
    background: #0a0a0a !important;
  }
  
  .box {
    background: #1a1a1a !important;
    border: 2px solid #d4c5b9 !important;
    box-shadow: 4px 4px 0px #d4c5b9 !important;
    transition: all 0.2s ease;
  }
  
  .box:hover {
    transform: translate(-2px, -2px);
    box-shadow: 6px 6px 0px #d4c5b9 !important;
  }
  
  .box-header {
    background: #000000 !important;
    color: #d4c5b9 !important;
    border-bottom: 2px solid #d4c5b9 !important;
    padding: 20px !important;
  }
  
  .box-title {
    font-size: 16px !important;
    font-weight: 700 !important;
    text-transform: uppercase;
    letter-spacing: 1px;
    color: #d4c5b9 !important;
  }
  
  .small-box {
    background: #1a1a1a !important;
    border: 2px solid #d4c5b9 !important;
    box-shadow: 4px 4px 0px #d4c5b9 !important;
    transition: all 0.2s ease;
  }
  
  .small-box:hover {
    transform: translate(-3px, -3px);
    box-shadow: 7px 7px 0px #d4c5b9 !important;
  }
  
  .small-box h3, .small-box p {
    color: #d4c5b9 !important;
  }
  
  .small-box .icon-large {
    color: rgba(212, 197, 185, 0.2) !important;
  }
  
  .sidebar {
    background: #000000 !important;
    border-right: 2px solid #d4c5b9 !important;
  }
  
  .sidebar-menu > li > a {
    color: #d4c5b9 !important;
    border-left: 4px solid transparent;
    transition: all 0.2s ease;
    font-weight: 500;
    text-transform: uppercase;
    font-size: 12px;
    letter-spacing: 1px;
  }
  
  .sidebar-menu > li > a:hover {
    background: #1a1a1a !important;
    border-left: 4px solid #d4c5b9;
  }
  
  .sidebar-menu > li.active > a {
    background: #1a1a1a !important;
    border-left: 4px solid #d4c5b9;
    font-weight: 700;
  }
  
  .nav-tabs-custom {
    background: transparent !important;
    box-shadow: none !important;
  }
  
  .nav-tabs-custom > .nav-tabs > li.active {
    border-top: 3px solid #d4c5b9 !important;
  }
  
  .nav-tabs-custom > .nav-tabs > li > a {
    color: #888888 !important;
    background: #1a1a1a !important;
    border: 2px solid #333333 !important;
    transition: all 0.2s ease;
    text-transform: uppercase;
    font-size: 11px;
    letter-spacing: 1px;
    font-weight: 600;
  }
  
  .nav-tabs-custom > .nav-tabs > li.active > a {
    color: #d4c5b9 !important;
    background: #000000 !important;
    border: 2px solid #d4c5b9 !important;
  }
  
  .nav-tabs-custom > .nav-tabs > li > a:hover {
    background: #0a0a0a !important;
    color: #d4c5b9 !important;
    border: 2px solid #d4c5b9 !important;
  }
  
  .form-control, .selectize-input {
    background: #1a1a1a !important;
    border: 2px solid #d4c5b9 !important;
    color: #d4c5b9 !important;
    transition: all 0.2s ease;
    font-family: 'IBM Plex Mono', monospace !important;
  }
  
  .form-control:focus, .selectize-input.focus {
    border-color: #d4c5b9 !important;
    box-shadow: 3px 3px 0px #d4c5b9 !important;
    transform: translate(-1px, -1px);
  }
  
  .selectize-dropdown {
    background: #1a1a1a !important;
    border: 2px solid #d4c5b9 !important;
    color: #d4c5b9 !important;
  }
  
  .selectize-dropdown-content .option {
    color: #d4c5b9 !important;
    padding: 10px 12px !important;
    border-bottom: 1px solid #333333 !important;
  }
  
  .selectize-dropdown-content .option:hover {
    background: #000000 !important;
  }
  
  .dataTables_wrapper {
    color: #d4c5b9 !important;
  }
  
  table.dataTable {
    background: #1a1a1a !important;
    color: #d4c5b9 !important;
    border: 2px solid #d4c5b9 !important;
  }
  
  table.dataTable thead th {
    background: #000000 !important;
    color: #d4c5b9 !important;
    border-bottom: 2px solid #d4c5b9 !important;
    font-weight: 700 !important;
    text-transform: uppercase;
    font-size: 11px;
    letter-spacing: 1px;
  }
  
  table.dataTable tbody tr {
    background: #1a1a1a !important;
    border-bottom: 1px solid #333333 !important;
    transition: all 0.1s ease;
  }
  
  table.dataTable tbody tr:hover {
    background: #000000 !important;
  }
  
  table.dataTable tbody td {
    border-right: 1px solid #333333 !important;
  }
  
  .dataTables_filter input, .dataTables_length select {
    background: #1a1a1a !important;
    border: 2px solid #d4c5b9 !important;
    color: #d4c5b9 !important;
  }
  
  .btn-primary {
    background: #d4c5b9 !important;
    border: 2px solid #d4c5b9 !important;
    color: #000000 !important;
    font-weight: 700 !important;
    text-transform: uppercase;
    letter-spacing: 1px;
    transition: all 0.2s ease !important;
    box-shadow: 3px 3px 0px #000000 !important;
  }
  
  .btn-primary:hover {
    transform: translate(-2px, -2px);
    box-shadow: 5px 5px 0px #000000 !important;
  }
  
  .info-box {
    background: #1a1a1a !important;
    border: 2px solid #d4c5b9 !important;
    box-shadow: 3px 3px 0px #d4c5b9 !important;
    transition: all 0.2s ease;
  }
  
  .info-box:hover {
    transform: translate(-2px, -2px);
    box-shadow: 5px 5px 0px #d4c5b9 !important;
  }
  
  h1, h2, h3, h4 {
    color: #d4c5b9 !important;
    font-weight: 700 !important;
    text-transform: uppercase;
    letter-spacing: 2px;
  }
  
  hr {
    border-color: #d4c5b9 !important;
    border-width: 2px !important;
  }
  
  .js-irs-0 .irs-bar, .js-irs-0 .irs-from, .js-irs-0 .irs-to, .js-irs-0 .irs-single {
    background: #d4c5b9 !important;
    border: 2px solid #000000 !important;
  }
  
  .irs-bar {
    background: #d4c5b9 !important;
    border: 2px solid #000000 !important;
  }
  
  .irs-from, .irs-to, .irs-single {
    background: #d4c5b9 !important;
    color: #000000 !important;
    font-weight: 700 !important;
  }
  
  .irs-slider {
    background: #d4c5b9 !important;
    border: 2px solid #000000 !important;
  }
  
  label {
    color: #d4c5b9 !important;
    font-weight: 600 !important;
    text-transform: uppercase;
    font-size: 11px;
    letter-spacing: 1px;
  }
"

# ============================================================================
# INTERFACE UTILISATEUR (UI)
# ============================================================================

ui <- dashboardPage(
  skin = "black",
  
  dashboardHeader(
    title = span(
      icon("chart-bar"),
      " S&P 500 Analytics"
    ),
    titleWidth = 300
  ),
  
  dashboardSidebar(
    width = 300,
    tags$head(tags$style(HTML(custom_css))),
    
    sidebarMenu(
      menuItem("Vue principale", tabName = "main", icon = icon("square")),
      menuItem("Analyse sectorielle", tabName = "sector", icon = icon("th")),
      menuItem("Données", tabName = "data", icon = icon("table")),
      menuItem("Statistiques", tabName = "stats", icon = icon("calculator")),
      menuItem("Comparaison", tabName = "comparison", icon = icon("minus"))
    ),
    
    hr(),
    
    h4("Filtres", style = "padding-left: 15px;"),
    
    selectInput("sector_filter", "Secteur:", 
                choices = c("Tous", unique(na.omit(sector_info$sector)))),
    
    selectInput("symbol_filter", "Actions:", 
                choices = c("Tous", "AAPL", "MSFT", "GOOGL", "AMZN", "NVDA", "META", "TSLA", "BRK.B", "JNJ", "V"),
                multiple = TRUE),
    
    sliderInput("price_range", "Plage de prix (USD):",
                min = 0, max = 500, value = c(0, 500), step = 10),
    
    dateRangeInput("date_range", "Plage de dates:",
                   start = Sys.Date() - 365, end = Sys.Date(),
                   format = "yyyy-mm-dd"),
    
    hr(),
    
    div(style = "padding: 15px;",
        icon("circle", style = "color: #d4c5b9; font-size: 8px;"),
        span(" TEMPS RÉEL", style = "color: #888888; font-size: 11px; letter-spacing: 1px;")
    )
  ),
  
  dashboardBody(
    tags$head(tags$style(HTML(custom_css))),
    
    tabItems(
      # ================================================================
      # TAB 1 : VUE PRINCIPALE
      # ================================================================
      tabItem(
        tabName = "main",
        
        fluidRow(
          valueBoxOutput("total_actions_box", width = 3),
          valueBoxOutput("avg_price_box", width = 3),
          valueBoxOutput("max_price_box", width = 3),
          valueBoxOutput("min_price_box", width = 3)
        ),
        
        fluidRow(
          box(
            width = 12,
            title = "Évolution des prix",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("main_plot", height = "500px")
          )
        )
      ),
      
      # ================================================================
      # TAB 2 : ANALYSE SECTORIELLE
      # ================================================================
      tabItem(
        tabName = "sector",
        
        fluidRow(
          box(
            width = 6,
            title = "Distribution par secteur",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("sector_plot", height = "400px")
          ),
          box(
            width = 6,
            title = "Volatilité par secteur",
            status = "warning",
            solidHeader = TRUE,
            plotlyOutput("volatility_plot", height = "400px")
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            title = "Performance sectorielle",
            status = "success",
            solidHeader = TRUE,
            plotlyOutput("returns_plot", height = "400px")
          )
        )
      ),
      
      # ================================================================
      # TAB 3 : DONNÉES
      # ================================================================
      tabItem(
        tabName = "data",
        
        fluidRow(
          box(
            width = 12,
            title = "Tableau des prix actuels",
            status = "primary",
            solidHeader = TRUE,
            dataTableOutput("data_table")
          )
        )
      ),
      
      # ================================================================
      # TAB 4 : STATISTIQUES
      # ================================================================
      tabItem(
        tabName = "stats",
        
        fluidRow(
          box(
            width = 6,
            title = "Résumé statistique",
            status = "info",
            solidHeader = TRUE,
            verbatimTextOutput("stats_summary")
          ),
          box(
            width = 6,
            title = "Distribution des prix",
            status = "info",
            solidHeader = TRUE,
            verbatimTextOutput("price_summary")
          )
        )
      ),
      
      # ================================================================
      # TAB 5 : COMPARAISON
      # ================================================================
      tabItem(
        tabName = "comparison",
        
        fluidRow(
          box(
            width = 12,
            title = "Comparaison des prix (Min/Moyen/Max)",
            status = "primary",
            solidHeader = TRUE,
            plotlyOutput("comparison_plot", height = "450px")
          )
        ),
        
        fluidRow(
          box(
            width = 12,
            title = "Volume de trading moyen",
            status = "success",
            solidHeader = TRUE,
            plotlyOutput("volume_plot", height = "400px")
          )
        )
      )
    )
  )
)

# ============================================================================
# LOGIQUE DU SERVEUR (SERVER)
# ============================================================================

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    data <- sp500_data
    
    if (input$sector_filter != "Tous") {
      data <- data %>% filter(sector == input$sector_filter)
    }
    
    if (!is.null(input$symbol_filter) && length(input$symbol_filter) > 0 && input$symbol_filter[1] != "Tous") {
      data <- data %>% filter(symbol %in% input$symbol_filter)
    }
    
    data <- data %>%
      filter(close >= input$price_range[1], close <= input$price_range[2]) %>%
      filter(date >= input$date_range[1], date <= input$date_range[2])
    
    return(data)
  })
  
  # Value Boxes
  output$total_actions_box <- renderValueBox({
    n_actions <- filtered_data() %>% distinct(symbol) %>% nrow()
    valueBox(
      value = n_actions,
      subtitle = "ACTIONS",
      icon = icon("briefcase"),
      color = "black"
    )
  })
  
  output$avg_price_box <- renderValueBox({
    avg <- filtered_data() %>% summarise(mean(close, na.rm = TRUE)) %>% pull()
    valueBox(
      value = paste0("$", round(avg, 2)),
      subtitle = "PRIX MOYEN",
      icon = icon("dollar-sign"),
      color = "black"
    )
  })
  
  output$max_price_box <- renderValueBox({
    max_p <- filtered_data() %>% summarise(max(close, na.rm = TRUE)) %>% pull()
    valueBox(
      value = paste0("$", round(max_p, 2)),
      subtitle = "PRIX MAX",
      icon = icon("arrow-up"),
      color = "black"
    )
  })
  
  output$min_price_box <- renderValueBox({
    min_p <- filtered_data() %>% summarise(min(close, na.rm = TRUE)) %>% pull()
    valueBox(
      value = paste0("$", round(min_p, 2)),
      subtitle = "PRIX MIN",
      icon = icon("arrow-down"),
      color = "black"
    )
  })
  
  # Graphique principal
  output$main_plot <- renderPlotly({
    if (nrow(filtered_data()) == 0) {
      return(plot_ly() %>% add_text(x = 0.5, y = 0.5, text = "AUCUNE DONNÉE DISPONIBLE"))
    }

    plot_data <- filtered_data() %>% arrange(date)

    # Palette contrastée pour fond noir (couleurs vibrantes et distinctes)
    colors <- c("#d4c5b9", "#00CED1", "#FF6B6B", "#4ECDC4", "#FFE66D",
                "#95E1D3", "#F38181", "#AA96DA", "#FCBAD3", "#A8E6CF",
                "#FF8B94", "#85D4E3", "#F7DC6F", "#BB8FCE", "#F8B739",
                "#52B788", "#E85D75", "#6A8EAE", "#FFA07A", "#98D8C8")

    plot_ly(plot_data, x = ~date, y = ~close, color = ~symbol,
            colors = colors,
            type = "scatter", mode = "lines",
            line = list(width = 2.5),
            hovertemplate = "<b>%{fullData.name}</b><br>DATE: %{x|%Y-%m-%d}<br>PRIX: $%{y:.2f}<extra></extra>") %>%
      layout(
        xaxis = list(title = "DATE", gridcolor = "#333333", showgrid = TRUE, zeroline = FALSE),
        yaxis = list(title = "PRIX (USD)", gridcolor = "#333333", showgrid = TRUE, zeroline = FALSE),
        hovermode = "x unified",
        plot_bgcolor = "#0a0a0a",
        paper_bgcolor = "#0a0a0a",
        font = list(color = "#d4c5b9", family = "IBM Plex Mono"),
        legend = list(font = list(size = 10))
      )
  })
  
  # Distribution par secteur
  output$sector_plot <- renderPlotly({
    sector_data <- filtered_data() %>%
      group_by(sector) %>%
      summarise(count = n(), .groups = "drop") %>%
      arrange(desc(count))

    # Couleurs distinctes par secteur
    sector_colors <- c("Technology" = "#00CED1", "Consumer" = "#FFE66D",
                       "Finance" = "#95E1D3", "Healthcare" = "#F38181",
                       "Energy" = "#FF8B94", "Industrial" = "#AA96DA",
                       "Real Estate" = "#FCBAD3")

    plot_ly(sector_data, x = ~reorder(sector, count), y = ~count,
            type = "bar",
            marker = list(color = ~sector_colors[sector],
                          line = list(color = "#000000", width = 2)),
            hovertemplate = "<b>%{x}</b><br>%{y} ACTIONS<extra></extra>") %>%
      layout(
        xaxis = list(title = "SECTEUR", gridcolor = "#333333"),
        yaxis = list(title = "NOMBRE", gridcolor = "#333333"),
        plot_bgcolor = "#0a0a0a",
        paper_bgcolor = "#0a0a0a",
        font = list(color = "#d4c5b9", family = "IBM Plex Mono"),
        showlegend = FALSE
      )
  })
  
  # Volatilité
  output$volatility_plot <- renderPlotly({
    volatility_data <- filtered_data() %>%
      mutate(returns = (close - lag(close)) / lag(close) * 100) %>%
      group_by(sector) %>%
      summarise(volatility = sd(returns, na.rm = TRUE), .groups = "drop") %>%
      arrange(desc(volatility))

    # Gradient de couleur selon volatilité (rouge = élevé, vert = faible)
    plot_ly(volatility_data, x = ~reorder(sector, volatility), y = ~volatility,
            type = "bar",
            marker = list(color = ~volatility,
                          colorscale = list(c(0, "#52B788"), c(0.5, "#FFE66D"), c(1, "#E85D75")),
                          line = list(color = "#000000", width = 2),
                          showscale = FALSE),
            hovertemplate = "<b>%{x}</b><br>VOLATILITÉ: %{y:.2f}%<extra></extra>") %>%
      layout(
        xaxis = list(title = "SECTEUR", gridcolor = "#333333"),
        yaxis = list(title = "VOLATILITÉ (%)", gridcolor = "#333333"),
        plot_bgcolor = "#0a0a0a",
        paper_bgcolor = "#0a0a0a",
        font = list(color = "#d4c5b9", family = "IBM Plex Mono")
      )
  })
  
  # Rendements par secteur
  output$returns_plot <- renderPlotly({
    returns_data <- filtered_data() %>%
      mutate(returns = (close - lag(close)) / lag(close) * 100) %>%
      filter(!is.na(returns)) %>%
      group_by(sector) %>%
      summarise(avg_returns = mean(returns, na.rm = TRUE), .groups = "drop")

    plot_ly(returns_data, x = ~sector, y = ~avg_returns,
            type = "bar",
            marker = list(color = ~ifelse(avg_returns >= 0, "#52B788", "#E85D75"),
                          line = list(color = "#000000", width = 2)),
            hovertemplate = "<b>%{x}</b><br>RENDEMENT: %{y:.2f}%<extra></extra>") %>%
      layout(
        xaxis = list(title = "SECTEUR", gridcolor = "#333333"),
        yaxis = list(title = "RENDEMENT MOYEN (%)", gridcolor = "#333333"),
        shapes = list(type = "line", x0 = 0, x1 = 1, xref = "paper",
                      y0 = 0, y1 = 0, line = list(color = "#d4c5b9", width = 2, dash = "dash")),
        plot_bgcolor = "#0a0a0a",
        paper_bgcolor = "#0a0a0a",
        font = list(color = "#d4c5b9", family = "IBM Plex Mono")
      )
  })
  
  # Tableau
  output$data_table <- renderDataTable({
    filtered_data() %>%
      group_by(symbol) %>%
      slice(n()) %>%
      ungroup() %>%
      select(symbol, sector, close, volume, date) %>%
      arrange(desc(close)) %>%
      rename("ACTION" = symbol, "SECTEUR" = sector, "PRIX (USD)" = close,
             "VOLUME" = volume, "DATE" = date)
  }, options = list(pageLength = 15, scrollX = TRUE))
  
  # Statistiques
  output$stats_summary <- renderPrint({
    data <- filtered_data()
    cat("═══ RÉSUMÉ STATISTIQUE ═══\n\n")
    cat("□ LIGNES:", nrow(data), "\n")
    cat("□ ACTIONS:", n_distinct(data$symbol), "\n")
    cat("□ SECTEURS:", n_distinct(data$sector), "\n")
    cat("□ DATES:", as.character(min(data$date)), "→", as.character(max(data$date)), "\n")
  })
  
  output$price_summary <- renderPrint({
    summary(filtered_data()$close)
  })
  
  # Comparaison
  output$comparison_plot <- renderPlotly({
    comparison_data <- filtered_data() %>%
      group_by(symbol) %>%
      summarise(avg_price = mean(close, na.rm = TRUE),
                max_price = max(close, na.rm = TRUE),
                min_price = min(close, na.rm = TRUE),
                .groups = "drop") %>%
      arrange(desc(avg_price)) %>%
      head(10)

    # Couleur gradient selon le prix moyen
    plot_ly(comparison_data, x = ~symbol, y = ~avg_price,
            type = "bar",
            marker = list(color = ~avg_price,
                          colorscale = list(c(0, "#4ECDC4"), c(0.5, "#FFE66D"), c(1, "#FF6B6B")),
                          line = list(color = "#000000", width = 2),
                          showscale = FALSE),
            error_y = list(symmetric = FALSE,
                           array = ~(max_price - avg_price),
                           arrayminus = ~(avg_price - min_price),
                           color = "#d4c5b9",
                           thickness = 2.5),
            hovertemplate = "<b>%{x}</b><br>MOYEN: $%{y:.2f}<extra></extra>") %>%
      layout(
        xaxis = list(title = "ACTION", gridcolor = "#333333"),
        yaxis = list(title = "PRIX (USD)", gridcolor = "#333333"),
        plot_bgcolor = "#0a0a0a",
        paper_bgcolor = "#0a0a0a",
        font = list(color = "#d4c5b9", family = "IBM Plex Mono")
      )
  })
  
  # Volume
  output$volume_plot <- renderPlotly({
    volume_data <- filtered_data() %>%
      group_by(symbol) %>%
      summarise(avg_volume = mean(volume, na.rm = TRUE) / 1e6, .groups = "drop") %>%
      arrange(desc(avg_volume)) %>%
      head(10)

    plot_ly(volume_data, x = ~reorder(symbol, avg_volume), y = ~avg_volume,
            type = "bar",
            marker = list(color = ~avg_volume,
                          colorscale = list(c(0, "#95E1D3"), c(0.5, "#F8B739"), c(1, "#F38181")),
                          line = list(color = "#000000", width = 2),
                          showscale = FALSE),
            hovertemplate = "<b>%{x}</b><br>VOLUME: %{y:.2f}M<extra></extra>") %>%
      layout(
        xaxis = list(title = "ACTION", gridcolor = "#333333"),
        yaxis = list(title = "VOLUME (MILLIONS)", gridcolor = "#333333"),
        plot_bgcolor = "#0a0a0a",
        paper_bgcolor = "#0a0a0a",
        font = list(color = "#d4c5b9", family = "IBM Plex Mono")
      )
  })
}

# ============================================================================
# LANCER L'APPLICATION
# ============================================================================

shinyApp(ui = ui, server = server)