library(feasts)
library(lubridate)
library(shiny)
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

ui <- fluidPage(
    titlePanel("Testing Modules"),
    fluidPage(
      selectInput("analysis", "Analysis", choices = c("Sectors", "Indicators"), multiple = FALSE, selected = "Indicators"),
      uiOutput("inputs"),
      uiOutput("outputs"))
    )

server <- function(input, output) {
  
  ui_inputs <- reactive({
    switch (
      input$analysis,
      "Sectors" = ui_sectors(id = "sectors", data_import = data_import),
      "Indicators" = ui_indicators(id = "indicators"))
  })
  
  output$inputs <- renderUI(ui_inputs())
  
  ui_outputs <- reactive({
    switch (
      input$analysis,
      "Sectors" = server_sectors(id = "sectors", data_import = data_import),
      "Indicators" = server_indicators(id = "indicators", data_import = data_economy))
  })
  
  output$outputs <- renderUI(ui_outputs())
}

# Run the application 
shinyApp(ui = ui, server = server)
