# Set API key for the current session

Set API key for the current session

## Usage

``` r
pa_set(base_url = NULL, site_id = NULL, key = NULL)
```

## Arguments

- base_url:

  The base URL of the Plausible instance. Set to https://plausible.io/ -
  or to your own domain for self-hosted Plausible.

- site_id:

  Corresponds to the domain of your website.

- key:

  A character string used for authentication. Can be retrieved from the
  user settings in Plausible Analytics.

## Value

Invisibly returns input as list.

## Examples

``` r
pa_set(
  base_url = "https://plausible.io/",
  site_id = "example.com",
  key = "actual_key_here"
)
```
