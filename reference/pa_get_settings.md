# Retrieves session settings

It allows to override specific settings, without changing environment
variables.

## Usage

``` r
pa_get_settings(base_url = NULL, site_id = NULL, key = NULL)
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

A list (invisibly).

## Examples

``` r
pa_set(
  base_url = "https://plausible.io/",
  site_id = "example.com",
  key = "actual_key_here"
)

pa_get_settings()

## It allows to override specific settings, without changing environment variables

pa_get_settings(site_id = "notexample.com")
```
