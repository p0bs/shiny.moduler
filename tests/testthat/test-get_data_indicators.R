data_test_indicators <- shiny.moduler:::get_data_indicators()

test_that("Expected column names", {
  expect_equal(
    colnames(data_test_indicators), 
    c("date", "series", "level")
    )
})
