# Gets data from Plausible Analytics API (v2)

For details, consult the
[https://plausible.io/docs/stats-api](https://giocomai.github.io/plausibler/reference/official%0Adocumentation).

## Usage

``` r
pa2_get(
  date_range = "30d",
  metrics = "visits",
  dimensions = NULL,
  filters = NULL,
  order_by = NULL,
  include = NULL,
  pagination = NULL,
  site_id = NULL
)
```

## Arguments

- date_range:

  A character vector of length 1, or a list of two dates or times. Valid
  values include: "day", "7d", "28d", "30d", "91d", "month", "6mo",
  "12mo", "year", "all". Custom date ranges can be given as a list of
  two dates e.g. `list("2024-01-01", "2024-07-01")`. See examples, and
  the [official
  documentation](https://plausible.io/docs/stats-api#date_range) for
  details.

- filters:

  Optional, defaults to NULL. If given, it must be a list of three
  (operator, dimension, clauses) or four (operator, dimension, clauses,
  modifiers) elements. See examples. For details, see the [API
  documentation on
  filtering](https://plausible.io/docs/stats-api#filters-).

## Value

A named list, with three elements: `results`, `meta`, and `query`.

## Examples

``` r
if (FALSE) { # \dontrun{
pa2_get(
  date_range = "30d",
  metrics = "visits"
)

pa2_get(
  date_range = "7d",
  metrics = c("visits", "visitors"),
  dimensions = c("time:day", "event:page"),
  include = list(total_rows = TRUE)
)



## Customise number of results and explore pagination
pa2_get(
  date_range = "7d",
  metrics = c("visits", "visitors"),
  dimensions = c("time:day", "event:page"),
  include = list(total_rows = TRUE),
  pagination = list(limit = 10,
                    offset = 0) # increase offset to get following pages
)
## Date range between dates
pa2_get(
  date_range = list(Sys.Date() - 8, Sys.Date() - 1),
  metrics = c("visits", "visitors"),
  dimensions = c("time:day", "event:page")
)


## Notice that filters require nested lists, even if they are simple

pa2_get(
  date_range = list(Sys.Date() - 2, Sys.Date() - 1),
  metrics = c("visits", "visitors"),
  dimensions = c("time:day", "event:page"),
  include = list(total_rows = TRUE),
  filters = list(
    list(
      "is_not",
      "visit:country_name",
      list(
        "China"
      )
    )
  )
)
} # }
```
