#' Gets data from Plausible Analytics API
#'
#' For details, consult the official documentation: https://plausible.io/docs/stats-api
#'
#' @param endpoint Endpoint as described in the official documentation, e.g. "/api/v1/stats/timeseries".
#' @param parameters A named list with parameters (see example). If you want to run more complex queries you can leave this NULL, and include the whole call (Plausible instance URL, endpoint, and query) to the parameter `full_url`.
#' @param full_url Defaults to NULL. If given, takes precedence over other parameters as well as settings. See examples, as well as examples in the official documentation.
#'
#' @return A data frame (a tibble) with results.
#' @export
#'
#' @examples
#' pa_get(
#'   endpoint = "/api/v1/stats/timeseries",
#'   parameters = list(period = "6mo")
#' )
#'
#' # Same as above, but with full_url:
#' # N.B. You still need to set the key with pa_set(). Replace $SITE_ID with your domain
#' pa_get(full_url = "https://plausible.io/api/v1/stats/timeseries?site_id=$SITE_ID&period=6mo")
pa_get <- function(endpoint,
                   parameters = NULL,
                   full_url = NULL) {
  pa_settings <- pa_set()

  if (is.null(full_url) == TRUE) {
    base_url_request <- paste0(
      pa_settings$base_url,
      endpoint,
      "?site_id=",
      pa_settings$site_id
    )

    if (is.null(parameters)) {
      url_request <- base_url_request
    } else {
      params_c <- purrr::map2_chr(
        .x = parameters,
        .y = names(parameters),
        .f = function(x, y) {
          paste0(y, "=", x)
        }
      )

      url_request <- paste0(
        base_url_request,
        "&",
        paste(params_c, collapse = "&")
      )
    }
  } else {
    url_request <- full_url
  }

  req <- curl::curl_fetch_memory(url_request,
    handle = pa_create_handler()
  )

  content <- rawToChar(req$content)

  content_json <- jsonlite::fromJSON(content)

  if (length(content_json) == 1 & names(content_json) == "error") {
    stop(content_json[[1]])
  }

  results_df <- content_json[["results"]] %>%
    tibble::as_tibble()

  if ("date" %in% colnames(results_df)) {
    results_df$date <- as.Date(results_df$date)
  }
  results_df
}
