#' @title Imports data relating to key US economic indicators over time
#' @description This function enables you to import data relating to key US economic indicators over time.
#' @keywords data
#' @examples
#' \dontrun{
#' get_data_indicators()
#' }
get_data_indicators <- function(){
  
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

  return(data_economy)
  
}
