% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pa_get_breakdown.R
\name{pa_get_top_pages}
\alias{pa_get_top_pages}
\title{Get most visited pages for a given period}
\usage{
pa_get_top_pages(period = "30d", limit = 100)
}
\arguments{
\item{period}{Period to include in the analysis, defaults to "30d". See examples as well as the the official documentation for valid values: https://plausible.io/docs/stats-api#time-periods}

\item{limit}{Limit the number of results. Defaults to 100.}
}
\value{
A data frame.
}
\description{
Get most visited pages for a given period
}
\examples{
\dontrun{
pa_get_top_pages(period = "6mo")
}
}
