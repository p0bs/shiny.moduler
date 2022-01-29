#' @title Components relating to the economic indicators module
#' @description This function provides the components for running the economic indicators module, be that as a sub-module of a bigger app or on a standalone basis.
#' @param id The identifier used in shiny to namespace a module, thereby linking the ui and server components
#' @param data_import The data imported on economic indicators
#' @param standalone Whether to view the module on a standalone basis (TRUE) or not (FALSE, the default)
#' @keywords module
#' @examples
#' \dontrun{
#' app_indicators(standalone = TRUE)
#' }
ui_indicators <- function(id, standalone = FALSE){
  if(standalone){
    shiny::tagList(
      shiny::sidebarPanel(
        shiny::radioButtons(shiny::NS(id, "button_output"), "Choose Output", choices = c("Plot", "Table"), selected = "Table")
        ),
      shiny::mainPanel(
        shiny::uiOutput(shiny::NS(id, "output_indicators"))
        )
      )
  } else {
    shiny::tagList(
      shiny::sidebarPanel(
        shiny::radioButtons(shiny::NS(id, "button_output"), "Choose Output", choices = c("Plot", "Table"), selected = "Table")
        )
      )
    }
}

#' @inheritParams ui_indicators
server_indicators <- function(id, data_import){
  shiny::moduleServer(id, function(input, output, session){
    
    stopifnot(!shiny::is.reactive(data_import))
    
    output_rendered <- shiny::reactive({
      switch (input$button_output,
              "Table" = shiny::renderTable({
                data_import %>%
                  tibble::as_tibble() %>% 
                  dplyr::group_by(series) %>% 
                  dplyr::slice_max(order_by = date, n = 1) %>% 
                  dplyr::ungroup()
              }),
              "Plot" = shiny::renderPlot({
                data_import %>% 
                  feasts::autoplot(.vars = level) +
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

#' @inheritParams ui_indicators
app_indicators <- function(){
  
  data_economy <- tidyquant::tq_get(
    x = c(
      "T10YIE",  # 10 Yr Breakeven
      "OB000334Q" # Real Y-O-Y GDP
    ),
    get = "economic.data",
    from = "1990-01-01"
  ) %>% 
    dplyr::mutate(
      series = dplyr::if_else(
        symbol == "T10YIE", 
        "10 Yr Breakeven", 
        "Real Y-O-Y GDP"
      ),
      level = price / 100
    ) %>% 
    dplyr::select(-symbol, -price) %>% 
    tsibble::as_tsibble(key = series, index = date) %>%
    dplyr::filter(date > '2002-01-01')
  
  ui <- shiny::fluidPage(
    shiny::titlePanel("Testing Modules with Open Economic Indicators"),
    ui_indicators(id = "indicators", standalone = TRUE)
    )
  
  server <- function(input, output, session) {
    server_indicators(id = "indicators", data_import = data_economy)
  }
  
  shiny::shinyApp(ui, server)
  
}
