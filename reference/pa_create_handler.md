# Creates a curl handler object with API keys (used internally)

Creates a curl handler object with API keys (used internally)

## Usage

``` r
pa_create_handler()
```

## Value

A curl handler object

## Examples

``` r
pa_set(
  base_url = "https://plausible.io/",
  site_id = "example.com",
  key = "actual_key_here"
)

pa_create_handler()
#> <curl handle> (empty)
```
