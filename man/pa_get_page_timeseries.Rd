% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pa_get_timeseries.R
\name{pa_get_page_timeseries}
\alias{pa_get_page_timeseries}
\title{Get stats for a given page by time period}
\usage{
pa_get_page_timeseries(period = "30d", page)
}
\arguments{
\item{period}{Period to include in the analysis, defaults to "30d". See examples as well as the the official documentation for valid values: https://plausible.io/docs/stats-api#time-periods}

\item{limit}{Limit the number of results. Defaults to 100.}
}
\value{
A data frame.
}
\description{
Get stats for a given page by time period
}
\examples{
\dontrun{
pa_get_page_timeseries(period = "6mo", page = "/")
}
}
