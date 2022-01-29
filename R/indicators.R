ui_indicators <- function(id){
  tagList(
    sidebarPanel(
      radioButtons(NS(id, "button_output"), "Choose Output", choices = c("Plot", "Table"), selected = "Table")
      )
    # ,
    # mainPanel(
    #   uiOutput(NS(id, "output_indicators"))
    #   )
    )
}

server_indicators <- function(id, data_import){
  moduleServer(id, function(input, output, session){
    
    stopifnot(!is.reactive(data_import))
    
    output_rendered <- reactive({
      switch (input$button_output,
              "Table" = renderTable({
                data_import %>%
                  as_tibble() %>% 
                  group_by(series) %>% 
                  slice_max(order_by = date, n = 1) %>% 
                  ungroup()
              }),
              "Plot" = renderPlot({
                data_import %>% 
                  autoplot(.vars = level) +
                  theme_minimal() + 
                  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
                  theme(plot.title.position = "plot") +
                  labs(
                    title = "Comparing changes in economic activity and implied long-term prices \n",
                    x = NULL,
                    y = NULL
                  )
              })
      )
    })
    
    output$output_indicators <- renderUI(
      output_rendered()
      )
    
  })
}

app_indicators <- function(){

  library(feasts)
  library(tidyquant)
  library(tidyverse)
  library(tsibble)
  
  data_economy <- tq_get(
    x = c(
      "T10YIE",  # 10 Yr Breakeven
      "OB000334Q" # Real Y-O-Y GDP
    ),
    get = "economic.data",
    from = "1990-01-01"
  ) %>% 
    mutate(
      series = if_else(
        symbol == "T10YIE", 
        "10 Yr Breakeven", 
        "Real Y-O-Y GDP"
      ),
      level = price / 100
    ) %>% 
    select(-symbol, -price) %>% 
    as_tsibble(key = series, index = date) %>%
    filter(date > '2002-01-01')
  
  ui <- fluidPage(
    titlePanel("Testing Modules with Open Economic Indicators"),
    ui_indicators(id = "indicators")
    )
  
  server <- function(input, output, session) {
    server_indicators(id = "indicators", data_import = data_economy)
  }
  
  shinyApp(ui, server)
  
}
