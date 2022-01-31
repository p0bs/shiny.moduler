<!-- badges: start -->
[![R-CMD-check](https://github.com/p0bs/shiny.moduler/workflows/R-CMD-check/badge.svg)](https://github.com/p0bs/shiny.moduler/actions)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

<br/>


`shiny.moduler` provides a simple Shiny app that controls underlying Shiny modules. As I'm seeking to show the Shiny functionality, the rest of the package is deliberately unpolished, with hardly any unit tests or error checks.

Why create this package? Well, I found that most of the code examples for Shiny stopped just before the point of building a main module to control sub-modules. As such, I thought I would go a bit further, in the hope that it might prove useful to others.

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
