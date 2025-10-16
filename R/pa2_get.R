#' Gets data from Plausible Analytics API (v2)
#'
#' For details, consult the \href{official
#' documentation}{https://plausible.io/docs/stats-api}.
#'
#' @param filters Optional, defaults to NULL. If given, it must be given in the
#'   form "visit:browser==Firefox;visit:country==FR", or as a named vector (see
#'   examples). Use ";" to separate multiple filtering criteria. For details,
#'   see the \href{API documentation on
#'   filtering}{https://plausible.io/docs/stats-api#filters-} for reference.
#'
#' @return A named list, with three elements: `results`, `meta`, and `query`.
#' @export
#'
#' @examples
#' \dontrun{
#' pa2_get(
#'     date_range = "30d",
#'     metrics = "visits",
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

  request_list <- list(
    site_id = pa_settings[["site_id"]],
    metrics = list(metrics),
    date_range = date_range,
    filters = filters,
    dimensions = list(dimensions),
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
      type = "application/json"
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
