#' Retrieve metrics by day and page
#'
#' Results are cached locally. Caching is filters-aware: data are returned from
#' cache, only if exactly the same filters are included (or none are present).
#'
#' @inheritParams pa2_get
#' @inheritParams pa2_df
#' @inheritParams pa_get_properties_by_date
#' @param cache_connection An active database connection, defaults to `NULL`
#'   (internally, defaults to a `duckdb` database stored in a folder with the
#'   same name as the `site_id`).
#'
#' @returns A data frame with four columns when `long` is set to `TRUE`
#'   (`date`, `metric`, `value`), or as wide as needed when `long` is set to
#'   `FALSE`, depending on the number of requested metrics.
#' @export
#'
#' @examples
#' \dontrun{
#'   pa2_get_metrics_by_day(metrics = c("visits", "visitors", "pageviews"))
#' }
pa2_get_metrics_by_day_and_page <- function(
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
            "metrics_by_day_and_page"
          ),
          ext = "duckdb"
        )
      )

      on.exit(DBI::dbDisconnect(db), add = TRUE)

      current_table <- "metrics_by_day_and_page"

      if (!DBI::dbExistsTable(conn = db, name = current_table)) {
        return_df <- tibble::tibble(
          date = character(),
          page = character(),
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
            id_cols = "date",
            names_from = "metric",
            values_from = "value"
          )
      }
    }

    to_process_combo_df <- metrics_date_combo_df |>
      dplyr::anti_join(
        previous_data_df |>
          dplyr::distinct(.data[["date"]], .data[["metric"]]),
        by = c("date", "metric")
      )
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
        dimensions = c("time:day", "event:page"),
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
          page = "",
          value = 0,
          filters_hash = current_filters_hash
        )
      } else {
        daily_visits_long_df <- daily_visits_df |>
          dplyr::rename(date = "time:day", page = "event:page") |>
          tidyr::pivot_longer(
            cols = !c("date", "page"),
            names_to = "metric",
            values_to = "value",
            values_transform = list(
              metric = as.character,
              value = as.numeric
            )
          ) |>
          dplyr::mutate(filters_hash = current_filters_hash)
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
      .data[["date"]],
      factor(.data[["metric"]], levels = metrics)
    ) |>
    dplyr::select(!"filters_hash") |>
    dplyr::mutate(date = as.Date(date))

  if (long) {
    return(long_df)
  } else {
    long_df |>
      tidyr::pivot_wider(
        id_cols = c("date", "page"),
        names_from = "metric",
        values_from = "value"
      )
  }
}
