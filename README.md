
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
Replace $SITE\_ID with your domain in this example, or check out the
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

## Future development

  - more wrapper functions
  - maybe, local caching with sqlite
  - suggestions? Open an issue
