# Get combined breakdown by two properties and date

This facilitates an operation that is not natively supported by the API.

## Usage

``` r
pa_get_properties_by_date(
  property1 = "visit:source",
  property2 = "event:page",
  start_date = Sys.Date() - 8,
  end_date = Sys.Date() - 1,
  property1_to_exclude = character(),
  limit = 1000,
  cache = TRUE,
  only_cached = FALSE,
  wait = 0.1
)
```

## Arguments

- start_date:

  Earliest day to include in the output. Defaults to 8 days ago in order
  to include the last full week of data. Date is expected in the format
  "YYYY-MM-DD", either as character or Date.

- end_date:

  Most recent day to include in the output. Defaults to yesterday in
  order to include the last full week of data. Date is expected in the
  format "YYYY-MM-DD", either as character or Date.

- property1_to_exclude:

  Character vector. Useful to remove irrelevant iterations. For example,
  "Direct / None" should mostly be excluded when using `visit:source` or
  `visit:referrer`.

- limit:

  Defaults to 1000, to reduce the need for pagination, which is
  currently not supported.

- cache:

  Defaults to TRUE. If TRUE, caches data in a local sqlite database,
  stored under a folder named as the website in the current working
  directory. The sqlite database is named after the chosen properties,
  hence there shouldn't be problems in caching data for different
  websites or different combinations of properties.

- only_cached:

  Defaults to FALSE. If TRUE, only data cached locally will be
  retrieved.

- wait:

  Numeric, defaults to 0.1. As this function is likely to make a high
  number of requests to the API, a small pause is added between each
  request to reduce load on the servers. description

## Value

A data frame with four columns: date, property1, property2, and
visitors.

## Details

For example, this allows to retrieve `visit:source` for each
`event:page` for each date. As this is not supported by the API, it
achieves this result via repeated calls to the API: first it retrieves
all visitors for `property1` (e.g. for all `visit:source`) for a given
date, then it iterates through each of them, and, relying on filters,
queries one by one for each item resulting from this query (e.g. each
`visit:source` found on a given date).

See https://github.com/plausible/analytics/discussions/1254

## Examples

``` r
if (FALSE) { # \dontrun{
pa_get_properties_by_date()
pa_get_properties_by_date(property1 = "visit:referrer")
} # }
```
