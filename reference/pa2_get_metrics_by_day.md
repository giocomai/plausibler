# Retrieve metrics by day

Results are cached locally. Caching is filters-aware: data are returned
from cache, only if exactly the same filters are included (or none are
present).

## Usage

``` r
pa2_get_metrics_by_day(
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
)
```

## Arguments

- metrics:

  Defaults to "visits". See [official documentation on metrics in API
  version 2](https://plausible.io/docs/stats-api#metrics) for more
  details.

- long:

  Logical, defaults to FALSE. If FALSE, the default, the value for each
  metric is returned in its own column. If TRUE, the data frame is
  returned in the long format.

- filters:

  Optional, defaults to `NULL`. If given, it must be a list of three
  (operator, dimension, clauses) or four (operator, dimension, clauses,
  modifiers) elements. See examples. For details, see the [API
  documentation on
  filtering](https://plausible.io/docs/stats-api#filters-).

- order_by:

  Optional, defaults to `NULL`. See [official documentation on order in
  API version 2](https://plausible.io/docs/stats-api#order_by-) for more
  details.

- include:

  Optional, defaults to `NULL`, if given must be a named list (see
  examples). Additional options for the query as to what data to
  include. See the [`include` section of the official
  documentation](https://plausible.io/docs/stats-api#include-) for
  details.

- pagination:

  Optional, defaults to `NULL`, if given must be a named list (see
  examples). Implicitly API default to
  `pagination = list(limit = 10000, offset = 0)`. Define number of
  results in the results, and change the offset component to paginate.
  See [the official documentation for more
  details](https://plausible.io/docs/stats-api#pagination-).

- site_id:

  Corresponds to the domain of your website.

## Value

A data frame with three columns when `long` is set to `TRUE` (`date`,
`metric`, `value`), or as wide as needed when `long` is set to `FALSE`,
depending on the number of requested metrics.

## Examples

``` r
if (FALSE) { # \dontrun{
pa2_get_metrics_by_day(metrics = c("visits", "visitors", "pageviews"))
} # }
```
