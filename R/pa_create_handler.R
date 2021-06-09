#' Creates a curl handler object with API keys (used internally)
#'
#' @return A curl handler object
#'
#' @export
#' @examples
#' pa_set(
#'   base_url = "https://plausible.io/",
#'   site_id = "example.com",
#'   key = "actual_key_here"
#' )
#'
#' pa_create_handler()
pa_create_handler <- function() {
  h <- curl::new_handle()
  curl::handle_setheaders(h,
    "Authorization" = paste(
      "Bearer",
      pa_set()$key
    )
  )
  h
}
