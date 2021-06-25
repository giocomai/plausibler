#' Get a breakdown of stats by a given property
#'
#' @param period Period to include in the analysis, defaults to "30d". See examples as well as the the official documentation for valid values: https://plausible.io/docs/stats-api#time-periods
#' @param property Property to break down the stats by. For a full list of available properties, see the official documentation: https://plausible.io/docs/stats-api#properties
#' @param limit Limit the number of results. Defaults to 100.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' pa_get_breakdown(period = "30d", property = "event:page")
#' }
pa_get_breakdown <- function(period = "30d",
                             property,
                             limit = 100) {
  pa_get(
    endpoint = "/api/v1/stats/breakdown",
    parameters = list(
      period = period,
      property = property,
      limit = limit
    )
  )
}

#' Get most visited pages for a given period
#'
#' @param period Period to include in the analysis, defaults to "30d". See examples as well as the the official documentation for valid values: https://plausible.io/docs/stats-api#time-periods
#' @param limit Limit the number of results. Defaults to 100.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' pa_get_top_pages(period = "6mo")
#' }
pa_get_top_pages <- function(period = "30d",
                             limit = 100) {
  pa_get(
    endpoint = "/api/v1/stats/breakdown",
    parameters = list(
      period = period,
      property = "event:page",
      limit = limit
    )
  )
}
