#' @title Imports data relating to the performance of US sectors over time
#' @description This function enables you to import data relating to the performance of US sectors over time.
#' @keywords data
#' @examples
#' \dontrun{
#' get_data_sectors()
#' }
get_data_sectors <- function(){
  link_17 <- 'http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/ftp/17_Industry_Portfolios_daily_CSV.zip'
  temp <- tempfile()
  utils::download.file(link_17 ,temp)
  data_import <- readr::read_csv(
    temp, 
    col_types = readr::cols(`...1` = readr::col_date(format = "%Y%m%d")), 
    skip = 9, 
    na = c(-99.99, -999, "NA", "N/A", "n/a", "na")
    ) %>% 
    dplyr::group_by(`...1`) %>% 
    dplyr::slice(1) %>% 
    dplyr::ungroup() %>% 
    dplyr::mutate(
      dplyr::across(.cols = tidyselect::where(is.numeric), .fns = ~ .x/100)
    ) %>% 
    dplyr::rename("Date" = `...1`) %>% 
    tidyr::gather(key = "Sector", value = "Return", -Date)
  
  return(data_import)
  
}
