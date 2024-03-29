job "fabio" {
  datacenters = ["dc1"]
  group "fabio" {
    count = 1
    task "fabio" {
      driver = "raw_exec"
      config {
        command = "fabio"
        args    = ["-proxy.strategy=rr"]
      }
      artifact {
        source      = "https://github.com/fabiolb/fabio/releases/download/v1.5.9/fabio-1.5.9-go1.10.2-linux_amd64"
        destination = "local/fabio"
        mode        = "file"
      }
    }
  }
}
