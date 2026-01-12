#' Transform API response from list to data frame
#'
#' @param response_l A list based on a Plausible API v2 response, typically
#'   retrieved with [pa2_get()].
#' @param long Logical, defaults to FALSE. If FALSE, the default, the value for
#'   each metric is returned in its own column. If TRUE, the data frame is
#'   returned in the long format.
#'
#' @returns A data frame.
#' @export
#'
#' @examples
#' \dontrun{
#' pa2_get(
#'   date_range = "7d",
#'   metrics = c("visits", "pageviews"),
#'   dimensions = c("time:day"),
#'   pagination = list(limit = 10)
#' ) |>
#'   pa2_df(long = TRUE)
#'
#'
#' pa2_get(
#'   date_range = "7d",
#'   metrics = c("visits", "pageviews"),
#'   dimensions = c("time:day"),
#'   pagination = list(limit = 10)
#' ) |>
#'   pa2_df(long = FALSE)
#' }
pa2_df <- function(response_l, long = FALSE) {
  results_l <- response_l |>
    purrr::pluck("results")

  dimensions_names <- response_l |>
    purrr::pluck("query", "dimensions") |>
    purrr::flatten_chr()

  metrics_names <- response_l |>
    purrr::pluck("query", "metrics") |>
    purrr::flatten_chr()

  result_df <- purrr::map(
    .progress = TRUE,
    .x = results_l,
    .f = \(current_result_l) {
      dimensions_values <- current_result_l |>
        purrr::pluck("dimensions") |>
        purrr::flatten_chr()

      if (length(dimensions_values) == 0) {
        dimensions_df <- NULL
      } else {
        dimensions_df <- tibble::tibble(
          dimensions = dimensions_names,
          values = dimensions_values
        ) |>
          tidyr::pivot_wider(names_from = "dimensions", values_from = "values")
      }

      metrics_values <- current_result_l |>
        purrr::pluck("metrics") |>
        purrr::flatten_dbl()

      metrics_df <- tibble::tibble(
        metrics = metrics_names,
        values = metrics_values
      ) |>
        tidyr::pivot_wider(names_from = metrics, values_from = values)

      dplyr::bind_cols(
        dimensions_df,
        metrics_df
      )
    }
  ) |>
    purrr::list_rbind()

  if (long) {
    tidyr::pivot_longer(
      data = result_df,
      cols = dplyr::all_of(metrics_names),
      names_to = "metric",
      values_to = "value"
    )
  } else {
    result_df
  }
}
