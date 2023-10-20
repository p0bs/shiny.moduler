#' @name ui_indicators
#' @title Components relating to the economic indicators module
#' @description This function provides the components for running the economic indicators module, be that as a sub-module of a bigger app or on a standalone basis.
#' @param id The identifier used in shiny to namespace a module, thereby linking the ui and server components
#' @param standalone Whether to view the module on a standalone basis (TRUE) or not (FALSE, the default)
#' @keywords module
#' @examples
#' \dontrun{
#' ui_indicators(id = "indicators", standalone = TRUE)
#' }
#' 
NULL

#' @name server_indicators
#' @title Components relating to the economic indicators module
#' @description This function provides the components for running the economic indicators module, be that as a sub-module of a bigger app or on a standalone basis.
#' @param id The identifier used in shiny to namespace a module, thereby linking the ui and server components
#' @param data_import The data imported on economic indicators
#' @keywords module
#' @examples
#' \dontrun{
#' server_indicators(id = "indicators", data_import = data_imported)
#' }
#'
#' @importFrom rlang .data
#' 
NULL

#' @name app_indicators
#' @title Components relating to the economic indicators module
#' @description This function provides the components for running the economic indicators module, be that as a sub-module of a bigger app or on a standalone basis.
#' @keywords module
#' @examples
#' \dontrun{
#' app_indicators()
#' }
#' 
NULL

#' @rdname ui_indicators
ui_indicators <- function(id, standalone = FALSE){
  if(standalone){
    shiny::tagList(
      shiny::sidebarPanel(
        shiny::radioButtons(shiny::NS(id, "button_output"), "", choices = c("Plot", "Table"), selected = "Table")
      ),
      shiny::mainPanel(
        shiny::uiOutput(shiny::NS(id, "output_indicators"))
      )
    )
  } else {
    shiny::tagList(
      shiny::radioButtons(shiny::NS(id, "button_output"), "", choices = c("Plot", "Table"), selected = "Table")
    )
  }
}

#' @rdname server_indicators
server_indicators <- function(id, data_import){
  shiny::moduleServer(id, function(input, output, session){
    
    stopifnot(!shiny::is.reactive(data_import))
    
    output_rendered <- shiny::reactive({
      switch (input$button_output,
              "Table" = shiny::renderTable({
                data_import %>%
                  tibble::as_tibble() %>% 
                  dplyr::group_by(.data$series) %>% 
                  dplyr::slice_max(order_by = .data$date, n = 1) %>% 
                  dplyr::ungroup() %>% 
                  dplyr::mutate(
                    date = as.character.Date(.data$date),
                    latest = .data$level * 100
                    ) %>% 
                  dplyr::select(-.data$level)
              }),
              "Plot" = shiny::renderPlot({
                data_import %>% 
                  feasts::autoplot(.vars = .data$level) +
                  ggplot2::theme_minimal() + 
                  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
                  ggplot2::theme(plot.title.position = "plot") +
                  ggplot2::labs(
                    title = "Comparing changes in economic activity and implied long-term prices \n",
                    x = NULL,
                    y = NULL
                  )
              })
      )
    })
    
    output$output_indicators <- shiny::renderUI(
      output_rendered()
      )
    
  })
}

#' @rdname app_indicators
app_indicators <- function(){
  
  data_economy <- get_data_indicators()
  
  ui <- shiny::fluidPage(
    shiny::titlePanel("Testing Modules with Open Economic Indicators"),
    ui_indicators(id = "indicators", standalone = TRUE)
    )
  
  server <- function(input, output, session) {
    server_indicators(id = "indicators", data_import = data_economy)
  }
  
  shiny::shinyApp(ui, server)
  
}
