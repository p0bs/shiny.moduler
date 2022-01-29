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
  download.file(link_17 ,temp)
  data_import <- readr::read_csv(temp, skip = 9, na = c(-99.99, -999, "NA", "N/A", "n/a", "na")) %>% 
    dplyr::mutate(
      dplyr::across(.cols = tidyselect:::where(is.numeric), .fns = ~ .x/100),
      Date = lubridate::ymd(as.integer(`...1`)), 
      .before = 1
    ) %>% 
    dplyr::select(-`...1`) %>% 
    tidyr::gather(key = "Sector", value = "Return", -Date)
  
  return(data_import)
  
}
