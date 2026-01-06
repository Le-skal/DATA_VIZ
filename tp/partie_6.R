library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)

netflix <- read.csv("netflix_titles.csv")

netflix <- netflix %>%
  distinct() %>%
  mutate(
    date_added = as.Date(date_added, format = "%B %d, %Y"),
    release_year = as.numeric(release_year)
  ) %>%
  filter(!is.na(release_year))

netflix_scatter_prep <- netflix %>%
  mutate(
    duration_numeric = case_when(
      type == "Movie" ~ as.numeric(gsub(" min", "", duration)),
      type == "TV Show" ~ as.numeric(gsub(" Seasons?", "", duration)),
      TRUE ~ NA_real_
    )
  ) %>%
  filter(!is.na(duration_numeric))

ui <- fluidPage(
  titlePanel("Netflix Analytics Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("country_filter", "Pays:", 
                  choices = c("Tous", unique(na.omit(unlist(strsplit(netflix$country, ", ")))))),
      selectInput("type_filter", "Type:", 
                  choices = c("Tous", unique(netflix$type))),
      sliderInput("year_filter", "Plage d'années:",
                  min = min(netflix$release_year, na.rm = TRUE),
                  max = max(netflix$release_year, na.rm = TRUE),
                  value = c(min(netflix$release_year, na.rm = TRUE), 
                           max(netflix$release_year, na.rm = TRUE)))
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Graphique principal",
                 plotOutput("histogram_plot")),
        tabPanel("Statistiques",
                 h3("Statistiques filtrées"),
                 textOutput("total_movies"),
                 textOutput("total_series"),
                 textOutput("avg_genres")),
        tabPanel("Graphique interactif",
                 plotlyOutput("scatter_plot"))
      )
    )
  )
)

server <- function(input, output) {
  
  filtered_data <- reactive({
    data <- netflix
    
    if (input$country_filter != "Tous") {
      data <- data %>%
        filter(grepl(input$country_filter, country, ignore.case = TRUE))
    }
    
    if (input$type_filter != "Tous") {
      data <- data %>%
        filter(type == input$type_filter)
    }
    
    data <- data %>%
      filter(release_year >= input$year_filter[1],
             release_year <= input$year_filter[2])
    
    return(data)
  })
  
  output$histogram_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = release_year)) +
      geom_histogram(bins = 30, fill = "#E50914", alpha = 0.7) +
      labs(title = "Distribution des années de sortie",
           x = "Année de sortie",
           y = "Nombre de contenus") +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, face = "bold"))
  })
  
  output$total_movies <- renderText({
    count <- filtered_data() %>% filter(type == "Movie") %>% nrow()
    paste("Nombre total de films:", count)
  })
  
  output$total_series <- renderText({
    count <- filtered_data() %>% filter(type == "TV Show") %>% nrow()
    paste("Nombre de séries:", count)
  })
  
  output$avg_genres <- renderText({
    avg <- filtered_data() %>%
      mutate(num_genres = sapply(strsplit(listed_in, ", "), length)) %>%
      summarise(avg = mean(num_genres, na.rm = TRUE)) %>%
      pull(avg)
    paste("Nombre moyen de genres différents:", round(avg, 2))
  })
  
  output$scatter_plot <- renderPlotly({
    scatter_data <- filtered_data() %>%
      mutate(
        duration_numeric = case_when(
          type == "Movie" ~ as.numeric(gsub(" min", "", duration)),
          type == "TV Show" ~ as.numeric(gsub(" Seasons?", "", duration)),
          TRUE ~ NA_real_
        )
      ) %>%
      filter(!is.na(duration_numeric))
    
    plot_ly(scatter_data,
            x = ~release_year,
            y = ~duration_numeric,
            color = ~type,
            text = ~paste("<b>", title, "</b><br>",
                         "Réalisateur:", director, "<br>",
                         "Pays:", country),
            mode = "markers",
            type = "scatter",
            hovertemplate = "%{text}<extra></extra>") %>%
      layout(title = "Scatter plot dynamique",
             xaxis = list(title = "Année de sortie"),
             yaxis = list(title = "Durée"),
             hovermode = "closest")
  })
}

shinyApp(ui = ui, server = server)
