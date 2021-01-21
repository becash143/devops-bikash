# Full configuration options can be found at https://www.nomadproject.io/docs/configuration

log_level = "DEBUG"
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

datacenter = "dc1"

server {
  enabled = true
  bootstrap_expect = 1
}

client {
  enabled = true
  servers = ["127.0.0.1:4646"]
}

plugin "raw_exec" {
  config {
    enabled = true
    no_cgroups = true
  }
}

#expose nomad metrics for promethus
telemetry {
  collection_interval = "5s",
  publish_allocation_metrics = true,
  publish_node_metrics = true,
  prometheus_metrics = true
}
