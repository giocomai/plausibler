#' Retrieve metrics by hour
#'
#' Results are cached locally. Caching is filters-aware: data are returned from
#' cache, only if exactly the same filters are included (or none are present).
#'
#' Be mindful that due to daylight saving time results may not be unique, e.g.
#' there may be two rows with data about "2026-10-25 02:00:00", as that hour
#' effectively happened twice.
#'
#' @inheritParams pa2_get_metrics_by_day
#'
#' @returns A data frame with three columns when `long` is set to `TRUE`
#'   (`date`, `date_hour`, `metric`, `value`), or as wide as needed when `long` is set to
#'   `FALSE`, depending on the number of requested metrics.
#' @export
#'
#' @examples
#' \dontrun{
#'   pa2_get_metrics_by_hour(metrics = c("visits", "visitors", "pageviews"))
#' }
pa2_get_metrics_by_hour <- function(
  metrics = c("visits"),
  start_date = Sys.Date() - 8,
  end_date = Sys.Date() - 1,
  long = FALSE,
  filters = NULL,
  order_by = NULL,
  include = NULL,
  pagination = NULL,
  site_id = NULL,
  cache = TRUE,
  cache_connection = NULL,
  only_cached = FALSE,
  wait = 0.1
) {
  pa_settings <- pa_set(site_id = site_id)

  all_dates_v <- seq.Date(
    from = start_date,
    to = end_date,
    by = "day"
  ) |>
    as.character()

  metrics_date_combo_df <- tidyr::expand_grid(
    date = all_dates_v,
    metric = metrics
  )

  current_filters_hash <- rlang::hash(filters)

  if (cache) {
    if (!is.null(cache_connection)) {
      db <- cache_connection
    } else {
      if (!requireNamespace("duckdb", quietly = TRUE)) {
        cli::cli_abort(
          c(
            x = "Package {.pkg duckdb} needs to be installed when {.var cache} is set to `TRUE`.",
            i = "Please install {.pkg duckdb} or set {.var cache} to `FALSE`."
          )
        )
      }

      fs::dir_create(pa_settings$site_id)

      db <- DBI::dbConnect(
        drv = duckdb::duckdb(),
        fs::path_ext_set(
          path = fs::path(
            pa_settings$site_id,
            "metrics_by_hour"
          ),
          ext = "duckdb"
        )
      )

      on.exit(DBI::dbDisconnect(db), add = TRUE)

      current_table <- "metrics_by_hour"

      if (!DBI::dbExistsTable(conn = db, name = current_table)) {
        return_df <- tibble::tibble(
          date = character(),
          date_hour = character(),
          metric = character(),
          value = numeric(),
          filters_hash = character()
        )

        DBI::dbWriteTable(
          conn = db,
          name = current_table,
          value = return_df
        )
      }

      previous_data_df <- DBI::dbReadTable(
        conn = db,
        name = current_table
      ) |>
        dplyr::filter(
          .data[["date"]] %in% all_dates_v,
          .data[["metric"]] %in% metrics,
          .data[["filters_hash"]] == current_filters_hash
        ) |>
        dplyr::collect() |>
        tibble::as_tibble()
    }

    if (only_cached) {
      long_df <- previous_data_df

      if (long) {
        return(long_df)
      } else {
        long_df |>
          tidyr::pivot_wider(
            id_cols = c("date", "date_hour"),
            names_from = "metric",
            values_from = "value"
          )
      }
    }

    to_process_combo_df <- metrics_date_combo_df |>
      dplyr::anti_join(previous_data_df, by = c("date", "metric"))
  } else {
    to_process_combo_df <- metrics_date_combo_df
  }

  to_process_combo_l_df <- to_process_combo_df |>
    dplyr::group_by(date) |>
    dplyr::summarise(metric = list(.data[["metric"]]))

  newly_retrieved_df <- purrr::map2(
    .progress = "Retrieving non-cached days",
    .x = to_process_combo_l_df[["date"]],
    .y = to_process_combo_l_df[["metric"]],
    .f = \(current_date, current_metrics) {
      daily_visits_df <- pa2_get(
        date_range = c(current_date, current_date),
        metrics = current_metrics,
        dimensions = c("time:hour"),
        include = include,
        filters = filters,
        order_by = order_by,
        pagination = pagination,
        site_id = pa_settings$site_id
      ) |>
        pa2_df()

      if (nrow(daily_visits_df) == 0) {
        daily_visits_long_df <- tibble::tibble(
          date = current_date,
          metric = current_metrics,
          value = 0,
          filters_hash = current_filters_hash
        )
      } else {
        daily_visits_long_df <- daily_visits_df |>
          dplyr::rename(date_hour = "time:hour") |>
          tidyr::pivot_longer(
            cols = !"date_hour",
            names_to = "metric",
            values_to = "value",
            values_transform = list(
              metric = as.character,
              value = as.numeric
            )
          ) |>
          dplyr::mutate(
            filters_hash = current_filters_hash,
            date = stringr::str_extract(
              string = date_hour,
              pattern = "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}"
            )
          ) |>
          dplyr::relocate("date")
      }

      if (cache) {
        DBI::dbAppendTable(
          conn = db,
          name = current_table,
          value = daily_visits_long_df
        )
      }

      Sys.sleep(time = wait)

      daily_visits_long_df
    }
  ) |>
    purrr::list_rbind()

  long_df <- dplyr::bind_rows(previous_data_df, newly_retrieved_df) |>
    dplyr::arrange(
      .data[["date_hour"]],
      factor(.data[["metric"]], levels = metrics)
    ) |>
    dplyr::select(!"filters_hash") |>
    dplyr::mutate(date = as.Date(date))

  if (long) {
    return(long_df)
  } else {
    long_df |>
      # temp_id needed to keep duplicate rows with daylight saving time switch
      dplyr::mutate(
        temp_id = stringr::str_c(dplyr::row_number(), "_", date_hour)
      ) |>
      tidyr::pivot_wider(
        id_cols = c("temp_id", "date", "date_hour"),
        names_from = "metric",
        values_from = "value"
      ) |>
      dplyr::select(!"temp_id")
  }
}
