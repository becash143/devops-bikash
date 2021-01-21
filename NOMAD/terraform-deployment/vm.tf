resource "digitalocean_droplet" "nomad" {
  image = "ubuntu-20-04-x64"
  name = "nomad-vm"
  region = "nyc1"
  size = "g-4vcpu-16gb"
  private_networking = true
  ssh_keys = [
      data.digitalocean_ssh_key.nomad.id
      ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    timeout = "2m"
  }
    
  provisioner "file" {
    source      = "../nomad.d"
    destination = "/tmp"
  }

  provisioner "file" {
    source      = "../logging-monitring"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "chmod +x /tmp/nomad.d/mpay.sh",
      "/tmp/nomad.d/mpay.sh",
      "sleep 30",
      "chmod +x /tmp/logging-monitring/monitoring.sh",
      "cd /tmp/logging-monitring",
      "./monitoring.sh",
      "sleep 15",
      "chmod +x /tmp/logging-monitring/grafana-dashboard/configure-grafana.sh",
      "cd /tmp/logging-monitring/grafana-dashboard",
      "./configure-grafana.sh"
    ]
  }
}