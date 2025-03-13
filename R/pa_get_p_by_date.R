#' Get combined breakdown by two properties and date
#'
#' This facilitates an operation that is not natively supported by the API.
#'
#' For example, this allows to retrieve `visit:source` for each `event:page` for
#' each date. As this is not supported by the API, it achieves this result via
#' repeated calls to the API: first it retrieves all visitors for `property1`
#' (e.g. for all `visit:source`) for a given date, then it iterates through each
#' of them, and, relying on filters, queries one by one for each item resulting
#' from this query (e.g. each `visit:source` found on a given date).
#'
#' See https://github.com/plausible/analytics/discussions/1254
#'
#' @param start_date Earliest day to include in the output. Defaults to 8 days
#'   ago in order to include the last full week of data. Date is expected in the
#'   format "YYYY-MM-DD", either as character or Date.
#' @param end_date Most recent day to include in the output. Defaults to
#'   yesterday in order to include the last full week of data. Date is expected
#'   in the format "YYYY-MM-DD", either as character or Date.
#' @param limit Defaults to 1000, to reduce the need for pagination, which is
#'   currently not supported.
#' @param cache Defaults to TRUE. If TRUE, caches data in a local sqlite
#'   database, stored under a folder named as the website in the current working
#'   directory. The sqlite database is named after the chosen properties, hence
#'   there shouldn't be problems in caching data for different websites or
#'   different combinations of properties.
#' @param only_cached Defaults to FALSE. If TRUE, only data cached locally will
#'   be retrieved.
#' @param wait Numeric, defaults to 0.1. As this function is likely to make a
#'   high number of requests to the API, a small pause is added between each
#'   request to reduce load on the servers.  description
#' @param property1_to_exclude Character vector. Useful to remove irrelevant
#'   iterations. For example, "Direct / None" should mostly be excluded when
#'   using `visit:source` or `visit:referrer`.
#'
#' @return A data frame with four columns: date, property1, property2, and
#'   visitors.
#' @export
#'
#' @examples
#' \dontrun{
#' pa_get_properties_by_date()
#' pa_get_properties_by_date(property1 = "visit:referrer")
#' }
pa_get_properties_by_date <- function(property1 = "visit:source",
                                      property2 = "event:page",
                                      start_date = Sys.Date() - 8,
                                      end_date = Sys.Date() - 1,
                                      property1_to_exclude = character(),
                                      limit = 1000,
                                      cache = TRUE,
                                      only_cached = FALSE,
                                      wait = 0.1) {
  pa_settings <- pa_set()

  all_dates_v <- seq.Date(
    from = start_date,
    to = end_date,
    by = "day"
  ) %>%
    as.character()

  if (cache == TRUE) {
    if (requireNamespace("RSQLite", quietly = TRUE) == FALSE) {
      stop("Package `RSQLite` needs to be installed when `cache` is set to TRUE. Please install `RSQLite` or set cache to FALSE.")
    }
    fs::dir_create(pa_settings$site_id)

    db <- DBI::dbConnect(
      drv = RSQLite::SQLite(),
      fs::path(
        pa_settings$site_id,
        paste0(
          property1,
          "_",
          property2,
          ".sqlite"
        ) %>%
          fs::path_sanitize()
      )
    )

    current_table <- "by_date"

    if (DBI::dbExistsTable(conn = db, name = current_table) == FALSE) {
      return_df <- tibble::tibble(
        a = NA_character_,
        b = NA_character_,
        c = NA_character_,
        d = NA_real_
      ) %>%
        tidyr::drop_na()

      colnames(return_df) <- c(
        "date",
        sub(pattern = ".+:", replacement = "", x = property1),
        sub(pattern = ".+:", replacement = "", x = property2),
        "visitors"
      )

      DBI::dbWriteTable(
        conn = db,
        name = current_table,
        value = return_df
      )
    }

    previous_data_db <- DBI::dbReadTable(
      conn = db,
      name = current_table
    )

    if (only_cached == TRUE) {
      return(
        previous_data_db %>%
          dplyr::filter(date %in% all_dates_v) %>%
          dplyr::collect() |> 
          tibble::as_tibble()
      )
    }

    previous_dates_v <- previous_data_db %>%
      dplyr::distinct(date) %>%
      dplyr::pull(date)
  } else {
    previous_dates_v <- character()
  }

  dates_to_process_v <- all_dates_v[!(all_dates_v %in% previous_dates_v)]

  all_new_df <- purrr::map(
    .progress = TRUE,
    .x = dates_to_process_v,
    .f = function(current_date) {
      current_period_string <- paste0(
        "custom&date=",
        current_date,
        ",",
        current_date
      )

      current_breakdown <- pa_get_breakdown(
        period = current_period_string,
        property = property1,
        limit = limit
      )
      
      if (is.null(current_breakdown)) {
        return(NULL)
      }
      
      current_p1_df <- current_breakdown %>%
        dplyr::mutate(visitors = as.numeric(visitors))

      current_p1_df <- current_p1_df[!(current_p1_df[[1]] %in% property1_to_exclude), ]

      items_to_process_v <- unique(current_p1_df[[1]])

      current_date_items_df <- purrr::map(
        .progress = FALSE,
        .x = items_to_process_v,
        .f = function(current_item) {
          names(current_item) <- property1

          pg_bd_df <- pa_get_breakdown(
            period = current_period_string,
            property = property2,
            filters = current_item,
            limit = limit
          )

          if (nrow(pg_bd_df) == 0) {
            return_df <- tibble::tibble(
              a = NA_character_,
              b = NA_integer_
            ) %>%
              tidyr::drop_na()

            colnames(return_df) <- c(
              sub(pattern = ".+:", replacement = "", x = property2),
              "visitors"
            )

            return(return_df)
          }

          pg_bd_df[["date"]] <- current_date
          pg_bd_df[[sub(pattern = ".+:", replacement = "", x = property1)]] <- current_item

          current_p2_df <- pg_bd_df %>%
            dplyr::select(3, 4, 1, 2)

          Sys.sleep(time = wait)

          current_p2_df
        }
      ) %>%
        purrr::list_rbind()

      if (cache == TRUE) {
        DBI::dbAppendTable(
          conn = db,
          name = current_table,
          value = current_date_items_df
        )
      }

      current_date_items_df
    }
  ) %>%
    purrr::list_rbind()

  if (cache == TRUE) {
    output_df <- DBI::dbReadTable(
      conn = db,
      name = current_table
    ) %>%
      dplyr::collect() %>%
      tibble::as_tibble()
  } else {
    output_df <- all_new_df
  }

  output_df %>%
    dplyr::mutate(date = as.Date(date)) %>%
    dplyr::filter(date >= start_date, date <= end_date)
}
