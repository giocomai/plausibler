% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pa_get_p_by_date.R
\name{pa_get_properties_by_date}
\alias{pa_get_properties_by_date}
\title{Get combined breakdown by two properties and date}
\usage{
pa_get_properties_by_date(
  property1 = "visit:source",
  property2 = "event:page",
  start_date = Sys.Date() - 8,
  end_date = Sys.Date() - 1,
  property1_to_exclude = character(),
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

\item{property1_to_exclude}{Character vector. Useful to remove irrelevant
iterations. For example, "Direct / None" should mostly be excluded when
using \code{visit:source} or \code{visit:referrer}.}

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
A data frame with four columns: date, property1, property2, and
visitors.
}
\description{
This facilitates an operation that is not natively supported by the API.
}
\details{
For example, this allows to retrieve \code{visit:source} for each \code{event:page} for
each date. As this is not supported by the API, it achieves this result via
repeated calls to the API: first it retrieves all visitors for \code{property1}
(e.g. for all \code{visit:source}) for a given date, then it iterates through each
of them, and, relying on filters, queries one by one for each item resulting
from this query (e.g. each \code{visit:source} found on a given date).

See https://github.com/plausible/analytics/discussions/1254
}
\examples{
\dontrun{
pa_get_properties_by_date()
pa_get_properties_by_date(property1 = "visit:referrer")
}
}
