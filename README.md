
<!-- README.md is generated from README.Rmd. Please edit that file -->

# plausibler

<!-- badges: start -->
<!-- badges: end -->

`plausibler` is a wrapper for the R programming language to the
[Plausible Analytics](https://plausible.io/) API. It facilitates making
queries, and getting tidy data frames in return.

See the [Plausible Analytics API
documentation](https://plausible.io/docs/stats-api) for more details on
the API, the endpoints, etc.

## Installation

You can install `plausibler` from GitHub with:

``` r
remotes::install_github("giocomai/plausibler")
```

To facilitate interactive use and auto-complete, each function starts
with “pa\_” (for “Plausible Analytics”) followed by a verb describing
what the function does.

## Example

At the beginning of each session, you will need to set the base url of
your Plausible Analytics instance (if not self-hosted,
<https://plausible.io/>), your `site_id` (the domain of your website),
and your API key.

``` r
pa_set(base_url = "https://plausible.io/",
       site_id = "example.com",
       key= "actual_key_here")
```

You have then three main options to get data from the API.

If you know exactly your query, you can just go with it. You can
e.g. see your monthly stats for the last six months with:

``` r
pa_get(full_url = "https://plausible.io/api/v1/stats/timeseries?site_id=$SITE_ID&period=6mo")
```

Keep in mind that you will still need to set the key with `pa_set()`.
Replace \$SITE_ID with your domain in this example, or check out the
[official API documentation](https://plausible.io/docs/stats-api) for
many more examples.

If you prefer to stick to a syntax closer to what you would typically
use in R, you can achieve the same as above with the following:

``` r
pa_get(endpoint = "/api/v1/stats/timeseries",
       parameters = list(period = "6mo"))
```

Finally, you can use wrapper functions, so you don’t need to remember
the endpoint. Here are some example for time series data:

``` r
pa_get_timeseries(period = "6mo")
pa_get_timeseries(period = "30d")
pa_get_timeseries(period = "custom&date=2021-06-01,2021-06-07")
```

Here are some example for breakdown of stats:

``` r
pa_get_breakdown(period = "30d", property = "event:page")

# which is exactly the same as:
pa_get_top_pages()
```

It is also possible to get aggregate stats:

``` r
pa_get_aggregate()
```

## Breakdown by multiple properties

As breakdown by multiple properties has not been natively implemented in
the API, `plausibler` offers a convenience function that tries to
achieve the same result by repeated queries, iterating through each
occurrence of a property on a given date.

The following should get the number of visitors from each source to each
page on each date of the last week.

``` r
pa_get_properties_by_date(property1 = "visit:source",
                          property2 = "event:page")
```

Depending on the number of “sources” recorded, this is likely to be
slow. In order to speed up the process and reduce load on the API, by
default this function caches data in a SQLite database created within
the current working directory. Only data for full days should be cached
(i.e. it’s safer not to include the current date, even if this is not
enforced).

## Future development

- more wrapper functions
- maybe, more extensive local caching with sqlite
- suggestions? Open an issue
