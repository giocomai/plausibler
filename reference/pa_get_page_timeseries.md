# Get stats for a given page by time period

Get stats for a given page by time period

## Usage

``` r
pa_get_page_timeseries(page, period = "30d", limit = 100)
```

## Arguments

- period:

  Period to include in the analysis, defaults to "30d". See examples as
  well as the the [official documentation for valid time periods
  values](https://plausible.io/docs/stats-api#time-periods).

- limit:

  Limit the number of results. Defaults to 100.

## Value

A data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
  pa_get_page_timeseries(period = "6mo", page = "/")
} # }
```
