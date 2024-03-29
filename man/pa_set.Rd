% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pa_set.R
\name{pa_set}
\alias{pa_set}
\title{Set API key for the current session}
\usage{
pa_set(base_url = NULL, site_id = NULL, key = NULL)
}
\arguments{
\item{base_url}{The base URL of the Plausible instance. Set to
https://plausible.io/ - or to your own domain for self-hosted Plausible.}

\item{site_id}{Corresponds to the domain of your website.}

\item{key}{A character string used for authentication. Can be retrieved from
the user settings in Plausible Analytics.}
}
\value{
Invisibly returns input as list.
}
\description{
Set API key for the current session
}
\examples{

pa_set(
  base_url = "https://plausible.io/",
  site_id = "example.com",
  key = "actual_key_here"
)
}
