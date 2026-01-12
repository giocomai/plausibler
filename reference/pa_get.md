# Gets data from Plausible Analytics API

For details, consult the official documentation:
https://plausible.io/docs/stats-api

## Usage

``` r
pa_get(endpoint, parameters = NULL, filters = NULL, full_url = NULL)
```

## Arguments

- endpoint:

  Endpoint as described in the official documentation, e.g.
  "/api/v1/stats/timeseries".

- parameters:

  A named list with parameters (see example). If you want to run more
  complex queries you can leave this NULL, and include the whole call
  (Plausible instance URL, endpoint, and query) to the parameter
  `full_url`.

- filters:

  Optional, defaults to NULL. If given, it must be given in the form
  "visit:browser==Firefox;visit:country==FR", or as a named vector (see
  examples). Use ";" to separate multiple filtering criteria. For
  details, see the
  [https://plausible.io/docs/stats-api#filtering](https://giocomai.github.io/plausibler/reference/API%20documentation%20on%0Afiltering)
  for reference.

- full_url:

  Defaults to NULL. If given, takes precedence over other parameters as
  well as settings. See examples, as well as examples in the official
  documentation.

## Value

A data frame (a tibble) with results.

## Examples

``` r
if (FALSE) { # \dontrun{
pa_get(
  endpoint = "/api/v1/stats/timeseries",
  parameters = list(period = "6mo")
)

# Same as above, but with full_url:
# N.B. You still need to set the key with pa_set(). Replace $SITE_ID with your domain
pa_get(full_url = "https://plausible.io/api/v1/stats/timeseries?site_id=$SITE_ID&period=6mo")
} # }
```
