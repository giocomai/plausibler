#' Get time series
#'
#' @param period Period to include in the analysis, defaults to "30d". See examples as well as the the official documentation for valid values: https://plausible.io/docs/stats-api#time-periods
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
#' @param period Period to include in the analysis, defaults to "30d". See examples as well as the the official documentation for valid values: https://plausible.io/docs/stats-api#time-periods
#' @param limit Limit the number of results. Defaults to 100.
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' pa_get_page_timeseries(period = "6mo", page = "/")
#' }
pa_get_page_timeseries <- function(period = "30d",
                                   page) {
  pa_get(
    endpoint = "/api/v1/stats/timeseries",
    parameters = list(
      period = period,
      filters = stringr::str_c("event:page==", page)
    )
  ) %>%
    dplyr::transmute(page = page, date, visitors)
}
