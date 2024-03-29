#' @name ui_sectors
#' @title Components relating to the sector performance module
#' @description This function provides the components for running the sector performance module, be that as a sub-module of a bigger app or on a standalone basis.
#' @param id The identifier used in shiny to namespace a module, thereby linking the ui and server components
#' @param data_import The data imported on sector performance
#' @param standalone Whether to view the module on a standalone basis (TRUE) or not (FALSE, the default)
#' @keywords module
#' @examples
#' \dontrun{
#' ui_sectors(id = "sectors", data_import = data_imported, standalone = TRUE)
#' }
NULL

#' @name server_sectors
#' @title Components relating to the sector performance module
#' @description This function provides the components for running the sector performance module, be that as a sub-module of a bigger app or on a standalone basis.
#' @param id The identifier used in shiny to namespace a module, thereby linking the ui and server components
#' @param data_import The data imported on sector performance
#' @keywords module
#' @examples
#' \dontrun{
#' server_sectors(id = "sectors", data_import = data_imported)
#' }
#' 
#' @importFrom rlang .data
#' 
NULL

#' @name app_sectors
#' @title Components relating to the sector performance module
#' @description This function provides the components for running the sector performance module, be that as a sub-module of a bigger app or on a standalone basis.
#' @keywords module
#' @examples
#' \dontrun{
#' app_sectors()
#' }
NULL

#' @rdname ui_sectors
ui_sectors <- function(id, data_import, standalone = FALSE){
  if(standalone){
    shiny::tagList(
      shiny::sidebarPanel(
        shiny::selectInput(shiny::NS(id, "year_start"), "Starting Year", choices = unique(lubridate::year(data_import$Date)), selected = min(lubridate::year(data_import$Date), na.rm = TRUE)),
        shiny::selectInput(shiny::NS(id, "year_end"), "Final Year", choices = unique(lubridate::year(data_import$Date)), selected = max(lubridate::year(data_import$Date), na.rm = TRUE)),
        shiny::radioButtons(shiny::NS(id, "button_output"), "", choices = c("Plot", "Table"), selected = "Table")
      ),
      shiny::mainPanel(
        shiny::uiOutput(shiny::NS(id, "output_sectors"))
      )
    )
  } else {
    shiny::tagList(
      shiny::selectInput(shiny::NS(id, "year_start"), "Starting Year", choices = unique(lubridate::year(data_import$Date)), selected = min(lubridate::year(data_import$Date), na.rm = TRUE)),
      shiny::selectInput(shiny::NS(id, "year_end"), "Final Year", choices = unique(lubridate::year(data_import$Date)), selected = max(lubridate::year(data_import$Date), na.rm = TRUE)),
      shiny::radioButtons(shiny::NS(id, "button_output"), "", choices = c("Plot", "Table"), selected = "Table")
    )
  }
}

#' @rdname server_sectors
server_sectors <- function(id, data_import){
  shiny::moduleServer(id, function(input, output, session){
    
    stopifnot(!shiny::is.reactive(data_import))
    
    summary_sectors <- shiny::reactive({
      data_import %>% 
        dplyr::filter(
          .data$Date >= lubridate::make_date(year = input$year_start),
          .data$Date <= lubridate::make_date(year = input$year_end, month = 12L, day = 31L)
        ) %>% 
        dplyr::group_by(.data$Sector) %>% 
        dplyr::summarise(
          mean = mean(.data$Return, na.rm = TRUE), 
          stdev = stats::sd(.data$Return, na.rm = TRUE)
        )
    })
    
    output_rendered <- shiny::reactive({
      switch (input$button_output,
              "Table" = shiny::renderTable({
                summary_sectors() %>%
                  dplyr::mutate(
                    mean = .data$mean * 100,
                    stdev = .data$stdev * 100
                  ) %>% 
                  dplyr::arrange(dplyr::desc(.data$mean), dplyr::desc(.data$stdev))
              }),
              "Plot" = shiny::renderPlot({
                summary_sectors() %>%
                  ggplot2::ggplot(
                    ggplot2::aes(
                      x = .data$stdev,
                      y = .data$mean,
                      colour = .data$Sector
                    )
                  ) + 
                  ggplot2::geom_point() + 
                  ggplot2::scale_x_continuous(labels = scales::percent_format(accuracy = 0.01)) +
                  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 0.01)) +
                  ggplot2::theme_minimal() + 
                  ggplot2::theme(plot.title.position = "plot") +
                  ggplot2::labs(
                    title = "Comparing the typical return and risk of sectors",
                    subtitle = "\nTypical daily return",
                    x = "\n Variability of daily returns",
                    y = NULL, 
                    colour = NULL
                  )
              })
      )
    })
    
    output$output_sectors <- shiny::renderUI(
      output_rendered()
      )
    
  })
}

#' @rdname app_sectors
app_sectors <- function(){
  
  data_import <- shiny.moduler::sectors_data
  
  ui <- shiny::fluidPage(
    shiny::titlePanel("Testing Modules with Open Financial Data"),
    ui_sectors(id = "sectors", data_import = data_import, standalone = TRUE)
    )
  
  server <- function(input, output, session) {
    server_sectors(id = "sectors", data_import = data_import)
  }
  
  shiny::shinyApp(ui, server)
  
}
