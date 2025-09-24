#' Set API key for the current session
#'
#' @param base_url The base URL of the Plausible instance. Set to
#'   https://plausible.io/ - or to your own domain for self-hosted Plausible.
#' @param site_id Corresponds to the domain of your website.
#' @param key A character string used for authentication. Can be retrieved from
#'   the user settings in Plausible Analytics.
#'
#' @return Invisibly returns input as list.
#' @export
#'
#' @examples
#'
#' pa_set(
#'   base_url = "https://plausible.io/",
#'   site_id = "example.com",
#'   key = "actual_key_here"
#' )
pa_set <- function(base_url = NULL, site_id = NULL, key = NULL) {
  if (is.null(base_url)) {
    base_url <- Sys.getenv("plausible_base_url")
    if (base_url == "") {
      cli::cli_abort(
        c(
          x = "Base URL of the Plausible instance must be given.",
          i = "If using the default hosted Plausible instances, set this to {.var https://plausible.io/}"
        )
      )
    }
  } else {
    Sys.setenv(plausible_base_url = base_url)
  }

  if (is.null(site_id)) {
    site_id <- Sys.getenv("plausible_site_id")
    if (site_id == "") {
      cli::cli_abort(
        c(
          x = "{.arg site_id} must be given",
          i = "It usually corresponds to the domain of your website."
        )
      )
    }
  } else {
    Sys.setenv(plausible_site_id = site_id)
  }

  if (is.null(key)) {
    key <- Sys.getenv("plausible_analytics_key")
    if (key == "") {
      cli::cli_abort(c(x = "API key must be given"))
    }
  } else {
    Sys.setenv(plausible_analytics_key = key)
  }

  invisible(list(
    base_url = base_url,
    site_id = site_id,
    key = key
  ))
}

#' Retrieves session settings
#'
#' It allows to override specific settings, without changing environment
#' variables.
#'
#' @inheritParams pa_set
#'
#' @returns A list (invisibly).
#' @export
#'
#' @examples
#' pa_set(
#'   base_url = "https://plausible.io/",
#'   site_id = "example.com",
#'   key = "actual_key_here"
#' )
#'
#' pa_get_settings()
#'
#' ## It allows to override specific settings, without changing environment variables
#'
#' pa_get_settings(site_id = "notexample.com")
pa_get_settings <- function(base_url = NULL, site_id = NULL, key = NULL) {
  if (is.null(base_url)) {
    base_url <- Sys.getenv("plausible_base_url")
    if (base_url == "") {
      cli::cli_abort(
        c(
          x = "Base URL of the Plausible instance must be given.",
          i = "If using the default hosted Plausible instances, set this to {.var https://plausible.io/}"
        )
      )
    }
  }

  if (is.null(site_id)) {
    site_id <- Sys.getenv("plausible_site_id")
    if (site_id == "") {
      cli::cli_abort(
        c(
          x = "{.arg site_id} must be given",
          i = "It usually corresponds to the domain of your website."
        )
      )
    }
  }

  if (is.null(key)) {
    key <- Sys.getenv("plausible_analytics_key")
    if (key == "") {
      cli::cli_abort(c(x = "API key must be given"))
    }
  }

  invisible(list(
    base_url = base_url,
    site_id = site_id,
    key = key
  ))
}
