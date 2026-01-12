# Get aggregated stats for a given website

Get aggregated stats for a given website

## Usage

``` r
pa_get_aggregate(
  period = "30d",
  metrics = "visitors,pageviews,bounce_rate,visit_duration"
)
```

## Arguments

- period:

  Period to include in the analysis, defaults to "30d". See examples as
  well as the the official documentation for valid values:
  <https://plausible.io/docs/stats-api#time-dimensions>

- metrics:

  Defaults to all available metrics. See documentation for more details:
  https://plausible.io/docs/stats-api#get-apiv1statsaggregate

## Value

A data frame.

## Examples

``` r
if (FALSE) { # \dontrun{
  pa_get_aggregate(period = "6mo")
} # }
```
