<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/p0bs/shiny.moduler/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/p0bs/shiny.moduler/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

<br/>


`shiny.moduler` provides a simple Shiny app that controls underlying Shiny modules. As I'm seeking to show the Shiny functionality, the rest of the package is deliberately unpolished, with hardly any unit tests or error checks.

Why create this package? Well, I found that most of the code examples for Shiny stopped just before the point of building a main module to control sub-modules. As such, I thought I would go a bit further, in the hope that it might prove useful to others.

To see the resulting Shiny app, [run it here](https://robin.shinyapps.io/useshiny/).

<br/>

## Installation

You can install the latest version of `shiny.moduler` as follows:

``` r
devtools::install_github("p0bs/shiny.moduler")
```

<br/>

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
