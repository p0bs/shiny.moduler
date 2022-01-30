# shiny.moduler

<!-- badges: start -->
[![R-CMD-check](https://github.com/p0bs/shiny.moduler/workflows/R-CMD-check/badge.svg)](https://github.com/p0bs/shiny.moduler/actions)
<!-- badges: end -->

`shiny.moduler` provides a simple Shiny app that controls underlying Shiny modules. It is deliberately unpolished -- for example, there are no unit tests or error checks in the app.

Why create this functionality? Well, I found that most documentation for Shiny stopped just prior to the point of building a main module to control sub-modules, so I shared my code in the hope that this test package might help others.

## Installation

You can install the latest version of `shiny.moduler` as follows:

``` r
devtools::install_github("p0bs/shiny.moduler")
```

## Example

To run the app that controls and contains the sub-modules, use:

``` r
library(shiny.moduler)
app_main()
```

To run the sub-modules on a standalone basis, use:

``` r
library(shiny.moduler)
app_sectors(standalone = TRUE)
app_indicators(standalone = TRUE)
```
