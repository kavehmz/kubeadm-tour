
provider "vultr" {
  api_key    = "${file("vultr.token")}"
  rate_limit = 700
}

