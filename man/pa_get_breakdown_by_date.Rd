% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pa_get_breakdown_by_date.R
\name{pa_get_breakdown_by_date}
\alias{pa_get_breakdown_by_date}
\title{Get breakdown by date and a single property}
\usage{
pa_get_breakdown_by_date(
  property = "event:page",
  metric = "visitors",
  start_date = Sys.Date() - 8,
  end_date = Sys.Date() - 1,
  limit = 1000,
  cache = TRUE,
  wait = 0.1
)
}
\arguments{
\item{start_date}{Earliest day to include in the output. Defaults to 8 days
ago in order to include the last full week of data. Date is expected in the
format "YYYY-MM-DD", either as character or Date.}

\item{end_date}{Most recent day to include in the output. Defaults to
yesterday in order to include the last full week of data. Date is expected
in the format "YYYY-MM-DD", either as character or Date.}

\item{limit}{Defaults to 1000, to reduce the need for pagination, which is
currently not supported.}

\item{cache}{Defaults to TRUE. If TRUE, caches data in a local sqlite
database, stored under a folder named as the website in the current working
directory. The sqlite database is named after the chosen properties, hence
there shouldn't be problems in caching data for different websites or
different combinations of properties.}

\item{wait}{Numeric, defaults to 0.1. As this function is likely to make a
high number of requests to the API, a small pause is added between each
request to reduce load on the servers.  description}
}
\value{
A data frame with three columns: date, property, and metric.
}
\description{
This facilitates caching daily stats.
}
\details{
However, the same data can mostly be retrieved more efficiently using the
\code{timeseries} endpoint, setting the optional \code{interval} parameter to date (not
yet integrated in the \code{pa_get_timeseries()} function).
}
\examples{
\dontrun{
pa_get_breakdown_by_date()
pa_get_breakdown_by_date(property = "visit:source")
}
}
