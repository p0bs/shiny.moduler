data_test_sectors <- shiny.moduler:::get_data_sectors()

test_that("Expected column names", {
  expect_equal(
    colnames(data_test_sectors), 
    c("Date", "Sector", "Return"))
})
