output "droplets_ips" {
  value = [ digitalocean_droplet.nomad.*.ipv4_address ]
}

output "mpay-ui" {
  value = [ formatlist("%s%s%s", "http://" , digitalocean_droplet.nomad.*.ipv4_address , ":7070") ]
}

output "nomad-ui" {
  value = [ formatlist("%s%s%s", "http://" , digitalocean_droplet.nomad.*.ipv4_address , ":4646") ]
}

output "consul-ui" {
  value = [ formatlist("%s%s%s", "http://" , digitalocean_droplet.nomad.*.ipv4_address , ":8500") ]
}

output "fabio-ui" {
  value = [ formatlist("%s%s%s", "http://" , digitalocean_droplet.nomad.*.ipv4_address , ":9998") ]
}

output "prometheus-ui" {
  value = [ formatlist("%s%s%s", "http://" , digitalocean_droplet.nomad.*.ipv4_address , ":9090") ]
}

output "grafana-ui" {
  value = [ formatlist("%s%s%s", "http://" , digitalocean_droplet.nomad.*.ipv4_address , ":3000") ]
}

output "promtail-ui" {
  value = [ formatlist("%s%s%s", "http://" , digitalocean_droplet.nomad.*.ipv4_address , ":9080") ]
}