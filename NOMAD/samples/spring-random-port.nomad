job "spring" {
  datacenters = ["dc1"]
  type = "service"

  group "spring" {
    count = 3
    task "webapp" {

      // env {
      //     SERVER_PORT = "${NOMAD_PORT_http}"
      // }

        driver = "raw_exec"

        artifact {
            source = "http://nyc3.digitaloceanspaces.com/psmarsel/spring.jar"
        }
        config {
            command = "java"
            args = ["-Xmx512m", "-Xms256m","-Dserver.port=${NOMAD_PORT_http}","-Dspring.profiles.active=h2","-jar","local/spring.jar"]
        }

        service {
          tags = ["webapp"]
            port = "http"
             check {
                  name     = "health_check"
                  type     = "http"
                  port     = "http"
                  path     = "/actuator/health"
                  interval = "10s"
                  timeout  = "5s"
                }
            // check {
            //   name     = "alive"
            //   type     = "tcp"
            //   interval = "10s"
            //   timeout  = "2s"
            // }
            }
          
       resources {
            cpu    = 50 # MHz
            memory = 128 # MB
            network {
              mbits = 50
              port "http" {}
            }
        }
    }
  }
}