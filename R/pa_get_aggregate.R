#' Get aggregated stats for a given website
#'
#' @param period Period to include in the analysis, defaults to "30d". See
#'   examples as well as the the official documentation for valid values:
#'   \url{https://plausible.io/docs/stats-api#time-dimensions}
#' @param metrics Defaults to all available metrics. See documentation for more
#'   details: https://plausible.io/docs/stats-api#get-apiv1statsaggregate
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#'   pa_get_aggregate(period = "6mo")
#' }
pa_get_aggregate <- function(
  period = "30d",
  metrics = "visitors,pageviews,bounce_rate,visit_duration"
) {
  if (length(metrics) > 1) {
    metrics <- paste0(metrics, collapse = ",")
  }

  pa_get(
    endpoint = "/api/v1/stats/aggregate",
    parameters = list(
      period = period,
      metrics = metrics
    )
  ) |>
    tidyr::unnest(cols = dplyr::everything())
}


#' Get aggregated stats for a given page
#'
#' @param period Period to include in the analysis, defaults to "30d". See
#'   examples as well as the the
#'   \href{https://plausible.io/docs/stats-api#time-periods}{official
#'   documentation for valid time periods values}.
#' @param limit Limit the number of results. Defaults to 100.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#'   pa_get_page_aggregate(period = "6mo", page = "/")
#' }
pa_get_page_aggregate <- function(page, period = "30d", limit = 100) {
  pa_get(
    endpoint = "/api/v1/stats/aggregate",
    parameters = list(
      period = period,
      filters = paste0("event:page==", page),
      limit = limit
    )
  ) |>
    tidyr::unnest(cols = visitors) |>
    dplyr::transmute(page = page, visitors = visitors)
}
