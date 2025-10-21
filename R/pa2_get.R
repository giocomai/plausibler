#' Gets data from Plausible Analytics API (v2)
#'
#' For details, consult the \href{official
#' documentation}{https://plausible.io/docs/stats-api}.
#'
#' @param date_range A character vector of length 1, or a list of two dates or
#'   times. Valid values include: "day", "7d", "28d", "30d", "91d", "month",
#'   "6mo", "12mo", "year", "all". Custom date ranges can be given as a list of
#'   two dates e.g. `list("2024-01-01", "2024-07-01")`. See examples, and the
#'   \href{official
#' documentation}{https://plausible.io/docs/stats-api#date_range} for details.
#' @param filters Optional, defaults to NULL. If given, it must be a list of
#'   three (operator, dimension, clauses) or four (operator, dimension, clauses,
#'   modifiers) elements. See examples. For details,
#'   see the \href{API documentation on
#'   filtering}{https://plausible.io/docs/stats-api#filters-}.
#'
#' @return A named list, with three elements: `results`, `meta`, and `query`.
#' @export
#'
#' @examples
#' \dontrun{
#' pa2_get(
#'   date_range = "30d",
#'   metrics = "visits"
#' )
#'
#' pa2_get(
#'   date_range = "7d",
#'   metrics = c("visits", "visitors"),
#'   dimensions = c("time:day", "event:page"),
#'   include = list(total_rows = TRUE)
#' )
#'
#'
#'
#' ## Customise number of results and explore pagination
#' pa2_get(
#'   date_range = "7d",
#'   metrics = c("visits", "visitors"),
#'   dimensions = c("time:day", "event:page"),
#'   include = list(total_rows = TRUE),
#'   pagination = list(limit = 10,
#'                     offset = 0) # increase offset to get following pages
#' )
#' ## Date range between dates
#' pa2_get(
#'   date_range = list(Sys.Date() - 8, Sys.Date() - 1),
#'   metrics = c("visits", "visitors"),
#'   dimensions = c("time:day", "event:page")
#' )
#'
#'
#' ## Notice that filters require nested lists, even if they are simple
#'
#' pa2_get(
#'   date_range = list(Sys.Date() - 2, Sys.Date() - 1),
#'   metrics = c("visits", "visitors"),
#'   dimensions = c("time:day", "event:page"),
#'   include = list(total_rows = TRUE),
#'   filters = list(
#'     list(
#'       "is_not",
#'       "visit:country_name",
#'       list(
#'         "China"
#'       )
#'     )
#'   )
#' )
#' }
pa2_get <- function(
  date_range = "30d",
  metrics = "visits",
  dimensions = NULL,
  filters = NULL,
  order_by = NULL,
  include = NULL,
  pagination = NULL,
  site_id = NULL
) {
  pa_settings <- pa_get_settings(site_id = site_id)

  if (length(metrics) == 1) {
    metrics <- list(metrics)
  }

  if (length(dimensions) == 1) {
    dimensions <- list(dimensions)
  }

  request_list <- list(
    site_id = pa_settings[["site_id"]],
    metrics = metrics,
    date_range = date_range,
    filters = filters,
    dimensions = dimensions,
    order_by = order_by,
    include = include,
    pagination = pagination
  )

  if (is.null(filters)) {
    request_list$filters <- NULL
  }

  if (is.null(dimensions)) {
    request_list$dimensions <- NULL
  }

  if (is.null(order_by)) {
    request_list$order_by <- NULL
  }

  if (is.null(include)) {
    request_list$include <- NULL
  }

  api_request <- httr2::request(
    base_url = "https://plausible.io/api/v2/query"
  ) |>
    httr2::req_auth_bearer_token(pa_settings[["key"]]) |>
    httr2::req_body_json(
      data = request_list,
      auto_unbox = TRUE,
      null = "list",
      type = "application/json",
      pretty = FALSE
    )

  req_json <- api_request |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  if (!is.null(req_json[["error"]])) {
    cli::cli_abort(req_json[["error"]])
  }

  req_json
}
