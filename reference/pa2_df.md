# Transform API response from list to data frame

Transform API response from list to data frame

## Usage

``` r
pa2_df(response_l, long = FALSE)
```

## Arguments

- response_l:

  A list based on a Plausible API v2 response, typically retrieved with
  [`pa2_get()`](https://giocomai.github.io/plausibler/reference/pa2_get.md).

- long:

  Logical, defaults to FALSE. If FALSE, the default, the value for each
  metric is returned in its own column. If TRUE, the data frame is
  returned in the long format.

## Value

A data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
pa2_get(
  date_range = "7d",
  metrics = c("visits", "pageviews"),
  dimensions = c("time:day"),
  pagination = list(limit = 10)
) |>
  pa2_df(long = TRUE)


pa2_get(
  date_range = "7d",
  metrics = c("visits", "pageviews"),
  dimensions = c("time:day"),
  pagination = list(limit = 10)
) |>
  pa2_df(long = FALSE)
} # }
```
