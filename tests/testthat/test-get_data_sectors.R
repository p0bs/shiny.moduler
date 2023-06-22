data_test_sectors <- sectors_data

test_that("Expected column names", {
  expect_equal(
    colnames(data_test_sectors), 
    c("Date", "Sector", "Return"))
})
