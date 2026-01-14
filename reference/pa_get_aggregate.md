# Get aggregated stats for a given website

Get aggregated stats for a given website

## Usage

``` r
pa_get_aggregate(period = "30d", metrics = "visits")
```

## Arguments

- period:

  Period to include in the analysis, defaults to "30d". See examples as
  well as the the official documentation for valid values:
  <https://plausible.io/docs/stats-api#time-dimensions>

- metrics:

  Defaults to "visits". See [official documentation on metrics of API
  version 1](https://plausible.io/docs/stats-api-v1#metrics) for more
  details.

## Value

A data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
  pa_get_aggregate(period = "6mo")
} # }
```
