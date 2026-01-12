# Get most visited pages for a given period

Get most visited pages for a given period

## Usage

``` r
pa_get_top_pages(period = "30d", limit = 100)
```

## Arguments

- period:

  Period to include in the analysis, defaults to "30d". See examples as
  well as the the official documentation for valid values:
  https://plausible.io/docs/stats-api#time-periods

- limit:

  Limit the number of results. Defaults to 100.

## Value

A data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
pa_get_top_pages(period = "6mo")
} # }
```
