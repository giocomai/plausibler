#' Get breakdown by date and a single property
#'
#' This facilitates caching daily stats.
#'
#' However, the same data can mostly be retrieved more efficiently using the
#' `timeseries` endpoint, setting the optional `interval` parameter to date (not
#' yet integrated in the `pa_get_timeseries()` function).
#'
#' @inheritParams pa_get_properties_by_date
#'
#' @return A data frame with three columns: date, property, and metric.
#' @export
#'
#' @examples
#' \dontrun{
#' pa_get_breakdown_by_date()
#' pa_get_breakdown_by_date(property = "visit:source")
#' }
pa_get_breakdown_by_date <- function(property = "event:page",
                                     metric = "visitors",
                                     start_date = Sys.Date() - 8,
                                     end_date = Sys.Date() - 1,
                                     limit = 1000,
                                     cache = TRUE,
                                     wait = 0.1) {
  pa_settings <- pa_set()

  all_dates_v <- seq.Date(
    from = start_date,
    to = end_date,
    by = "day"
  ) |>
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
          "breakdown",
          "_",
          property,
          "_",
          metric,
          ".sqlite"
        ) |>
          fs::path_sanitize()
      )
    )

    current_table <- "by_date"

    if (DBI::dbExistsTable(conn = db, name = current_table) == FALSE) {
      return_df <- tibble::tibble(
        a = NA_character_,
        b = NA_character_,
        c = NA_real_
      ) |>
        tidyr::drop_na()

      colnames(return_df) <- c(
        "date",
        sub(pattern = ".+:", replacement = "", x = property),
        metric
      )

      DBI::dbWriteTable(
        conn = db,
        name = current_table,
        value = return_df
      )
    }

    previous_dates_v <- DBI::dbReadTable(
      conn = db,
      name = current_table
    ) |>
      dplyr::distinct(date) |>
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

      current_df <- pa_get_breakdown(
        period = current_period_string,
        property = property,
        metrics = metric,
        limit = limit
      )

      if (is.null(current_df)) {
        return(NULL)
      } else {
        current_df <- current_df |>
          dplyr::mutate(date = as.character(current_date)) |>
          dplyr::select(3, 1, 2)
      }

      current_df[[metric]] <- as.numeric(current_df[[metric]])


      Sys.sleep(time = wait)


      if (cache == TRUE) {
        DBI::dbAppendTable(
          conn = db,
          name = current_table,
          value = current_df
        )
      }

      current_df
    }
  ) |>
    purrr::list_rbind()

  if (cache == TRUE) {
    output_df <- DBI::dbReadTable(
      conn = db,
      name = current_table
    ) |>
      dplyr::collect() |>
      tibble::as_tibble()
  } else {
    output_df <- all_new_df
  }

  output_df |>
    dplyr::mutate(date = as.Date(date)) |>
    dplyr::filter(date >= start_date, date <= end_date) |>
    dplyr::arrange(date)
}
