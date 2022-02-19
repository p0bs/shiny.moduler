#' @title Running the main app that controls the shiny sub modules
#' @description This function runs the main app that controls the shiny sub-modules.
#' @keywords module
#' @examples
#' \dontrun{
#' app_main()
#' }
app_main <- function(){
  
  data_import <- get_data_sectors()
  data_economy <- get_data_indicators()
  
  ui <- shiny::fluidPage(
    shiny::titlePanel("Testing Modules"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3,
        shiny::selectInput("analysis", "Analysis", choices = c("Sectors", "Indicators"), multiple = FALSE, selected = "Indicators"),
        shiny::uiOutput("inputs")
        ),
      shiny::mainPanel(
        shiny::uiOutput("outputs")
        )
      )
    )
  
  server <- function(input, output) {
    
    ui_inputs <- shiny::reactive({
      switch (
        input$analysis,
        "Sectors" = ui_sectors(id = "sectors", data_import = data_import),
        "Indicators" = ui_indicators(id = "indicators"))
    })
    
    output$inputs <- shiny::renderUI(ui_inputs())
    
    ui_outputs <- shiny::reactive({
      switch (
        input$analysis,
        "Sectors" = server_sectors(id = "sectors", data_import = data_import),
        "Indicators" = server_indicators(id = "indicators", data_import = data_economy))
    })
    
    output$outputs <- shiny::renderUI(ui_outputs())
  }
  
  shiny::shinyApp(ui, server)
  
}
