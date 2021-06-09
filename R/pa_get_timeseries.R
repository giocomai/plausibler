#' Get time series
#'
#' @param period Period to include in the analysis. See the relevant part of the official documentation for valid values
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' pa_get_timeseries(period = "6mo")
#' pa_get_timeseries(period = "30d")
#' pa_get_timeseries(period = "custom&date=2021-06-01,2021-06-07")
pa_get_timeseries <- function(period) {
  pa_get(
    endpoint = "/api/v1/stats/timeseries",
    parameters = list(period = period)
  )
}
