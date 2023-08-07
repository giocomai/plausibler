#' Get a breakdown of stats by a given property
#'
#' @param period Period to include in the analysis, defaults to "30d". See
#'   examples as well as the the official documentation for valid values:
#'   https://plausible.io/docs/stats-api#time-periods
#' @param property Property to break down the stats by. For a full list of
#'   available properties, see the official documentation:
#'   https://plausible.io/docs/stats-api#properties
#' @param metrics Default to "visitors". Can be set, for example, to
#'   `c("visitors", "pageviews", "bounce_rate", "visit_duration")`. For a full
#'   list of available metrics and their description, see the official
#'   documentation:  https://plausible.io/docs/stats-api#metrics
#' @param limit Limit the number of results. Maximum value is 1000. Defaults to
#'   100. If you want to get more than 1000 results, you can make multiple
#'   requests and paginate the results by specifying the page parameter (e.g.
#'   make the same request with page=1, then page=2, etc)
#' @param filters Optional, defaults to NULL. If given, it must be given in the
#'   form "visit:browser==Firefox;visit:country==FR", or as a named vector (see
#'   examples). Use ";" to separate multiple filtering criteria. For details,
#'   see the \href{API documentation on
#'   filtering}{https://plausible.io/docs/stats-api#filtering} for reference.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' pa_get_breakdown(period = "30d", property = "event:page")
#'
#' ## With filters, e.g. to see all referrers to the given url:
#'
#' pa_get_breakdown(
#'   period = "30d",
#'   property = "visit:referrer",
#'   filters = list(`event:page` = "/berlin/")
#' )
#' }
pa_get_breakdown <- function(period = "30d",
                             property = "event:page",
                             metrics = "visitors",
                             limit = 100,
                             filters = NULL) {
  pa_get(
    endpoint = "/api/v1/stats/breakdown",
    parameters = list(
      period = period,
      property = property,
      metrics = metrics,
      limit = limit
    ),
    filters = filters
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
