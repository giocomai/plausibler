#' Get time series
#'
#' @inheritParams pa_get_page_aggregate
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' pa_get_timeseries(period = "6mo")
#' pa_get_timeseries(period = "30d")
#' pa_get_timeseries(period = "custom&date=2021-06-01,2021-06-07")
#' }
pa_get_timeseries <- function(period = "30d") {
  pa_get(
    endpoint = "/api/v1/stats/timeseries",
    parameters = list(period = period)
  )
}


#' Get stats for a given page by time period
#'
#' @inheritParams pa_get_page_aggregate
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#'   pa_get_page_timeseries(period = "6mo", page = "/")
#' }
pa_get_page_timeseries <- function(page, period = "30d", limit = 100) {
  pa_get(
    endpoint = "/api/v1/stats/timeseries",
    parameters = list(
      period = period,
      filters = paste0("event:page==", page),
      limit = limit
    )
  ) |>
    dplyr::mutate(page = page) |>
    dplyr::relocate("page")
}
