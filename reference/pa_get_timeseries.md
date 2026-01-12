# Get time series

Get time series

## Usage

``` r
pa_get_timeseries(period = "30d")
```

## Arguments

- period:

  Period to include in the analysis, defaults to "30d". See examples as
  well as the the official documentation for valid values:
  https://plausible.io/docs/stats-api#time-periods

## Value

A data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
pa_get_timeseries(period = "6mo")
pa_get_timeseries(period = "30d")
pa_get_timeseries(period = "custom&date=2021-06-01,2021-06-07")
} # }
```
