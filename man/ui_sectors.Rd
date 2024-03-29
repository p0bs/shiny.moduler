% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sectors.R
\name{ui_sectors}
\alias{ui_sectors}
\title{Components relating to the sector performance module}
\usage{
ui_sectors(id, data_import, standalone = FALSE)
}
\arguments{
\item{id}{The identifier used in shiny to namespace a module, thereby linking the ui and server components}

\item{data_import}{The data imported on sector performance}

\item{standalone}{Whether to view the module on a standalone basis (TRUE) or not (FALSE, the default)}
}
\description{
This function provides the components for running the sector performance module, be that as a sub-module of a bigger app or on a standalone basis.
}
\examples{
\dontrun{
ui_sectors(id = "sectors", data_import = data_imported, standalone = TRUE)
}
}
\keyword{module}
