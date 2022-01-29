ui_sectors <- function(id, data_import){
  tagList(
    sidebarPanel(
      selectInput(NS(id, "year_start"), "Starting Year", choices = unique(year(data_import$Date)), selected = min(year(data_import$Date), na.rm = TRUE)),
      selectInput(NS(id, "year_end"), "Final Year", choices = unique(year(data_import$Date)), selected = max(year(data_import$Date), na.rm = TRUE)),
      radioButtons(NS(id, "button_output"), "Choose Output", choices = c("Plot", "Table"), selected = "Table")
      )
    # ,
    # mainPanel(
    #   uiOutput(NS(id, "output_sectors"))
    #   )
    )
}

server_sectors <- function(id, data_import){
  moduleServer(id, function(input, output, session){
    
    stopifnot(!is.reactive(data_import))
    
    summary_sectors <- reactive({
      data_import %>% 
        filter(Date >= make_date(year = input$year_start),
               Date <= make_date(year = input$year_end, month = 12L, day = 31L)
        ) %>% 
        group_by(Sector) %>% 
        summarise(
          mean = mean(Return, na.rm = TRUE), 
          sd = sd(Return, na.rm = TRUE)
        )
    })
    
    output_rendered <- reactive({
      switch (input$button_output,
              "Table" = renderTable({
                summary_sectors() %>%
                  arrange(desc(mean), desc(sd))
              }),
              "Plot" = renderPlot({
                summary_sectors() %>%
                  ggplot(
                    aes(
                      x = sd,
                      y = mean,
                      colour = Sector
                    )
                  ) + 
                  geom_point() + 
                  scale_x_continuous(labels = scales::percent_format(accuracy = 0.01)) +
                  scale_y_continuous(labels = scales::percent_format(accuracy = 0.01)) +
                  theme_minimal() + 
                  theme(plot.title.position = "plot") +
                  labs(
                    title = "Comparing the typical return and risk of sectors",
                    subtitle = "\nTypical daily return",
                    x = "\n Variability of daily returns",
                    y = NULL, 
                    colour = NULL
                  )
              })
      )
    })
    
    output$output_sectors <- renderUI(
      output_rendered()
      )
    
  })
}

app_sectors <- function(){

  library(lubridate)
  library(shiny)
  library(tidyverse)
  
  # Sector data
  link_17 <- 'http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/17_Industry_Portfolios_daily_CSV.zip'
  temp <- tempfile()
  download.file(link_17 ,temp)
  data_import <- read_csv(temp, skip = 9, na = c(-99.99, -999, "NA", "N/A", "n/a", "na")) %>% 
    mutate(
      across(.cols = is.numeric, .fns = ~ .x/100),
      Date = ymd(as.integer(`...1`)), 
      .before = 1
    ) %>% 
    select(-`...1`) %>% 
    gather(key = "Sector", value = "Return", -Date)
  
  # Ignore error checking of start and end years for now
  ui <- fluidPage(
    titlePanel("Testing Modules with Open Financial Data"),
    ui_sectors(id = "sectors", data_import = data_import)
    )
  
  server <- function(input, output, session) {
    server_sectors(id = "sectors", data_import = data_import)
  }
  
  shinyApp(ui, server)
  
}
