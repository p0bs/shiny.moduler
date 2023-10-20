#' @title Running the main app that controls the shiny sub modules
#' @description This function runs the main app that controls the shiny sub-modules.
#' @keywords module
#' @examples
#' \dontrun{
#' app_main()
#' }
app_main <- function(){
  
  data_import <- shiny.moduler::sectors_data
  data_economy <- get_data_indicators()
  
  ui <- bslib::page_fillable(
    bslib::card(
      full_screen = TRUE,
      bslib::card_header("Demonstrating the use of modules"),
      bslib::layout_sidebar(
        sidebar = bslib::sidebar(
          shiny::selectInput("analysis", "Analysis", choices = c("Sector Market History", "Economic Indicators"), multiple = FALSE, selected = "Economic Indicators"),
          shiny::uiOutput("inputs", fill = "item")),
        shiny::uiOutput("outputs"))),
    title = "Testing modules", 
    theme = bslib::bs_theme(
      bootswatch = "minty",
      version = 5, bg = "white", fg = "black",
      primary = "#63431c", secondary = "#f9f3ec",
      code_font = bslib::font_collection("Arial", "sans-serif"),
      "dropdown-bg" = "#f9f3ec",
      "dropdown-link-hover-bg" = "#63431c",
      "card-border-color" = "white",
      "navbar-bg" = "#f9f3ec"
      )
    )
  
  server <- function(input, output) {
    
    ui_inputs <- shiny::reactive({
      switch (
        input$analysis,
        "Sector Market History" = ui_sectors(id = "sectors", data_import = data_import),
        "Economic Indicators" = ui_indicators(id = "indicators"))
    })
    
    output$inputs <- shiny::renderUI(ui_inputs())
    
    ui_outputs <- shiny::reactive({
      switch (
        input$analysis,
        "Sector Market History" = server_sectors(id = "sectors", data_import = data_import),
        "Economic Indicators" = server_indicators(id = "indicators", data_import = data_economy))
    })
    
    output$outputs <- shiny::renderUI(ui_outputs())
  }
  
  shiny::shinyApp(ui, server)
  
}
