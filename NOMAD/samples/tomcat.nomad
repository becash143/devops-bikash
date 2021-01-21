job "tomcat" {
  datacenters = ["dc1"]
  type = "service"

  group "tomcat" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "hello" {
      driver = "raw_exec"
      # Grab the code from the public repo
      artifact {
        source      = "https://s3.amazonaws.com/public-demo-assets/nomad/simple_raw_docker/helloworld.war"
        destination = "/u01/tomcat/webapps"
      }

      resources {
        network {
          mbits = 10
          port "http" {
              static = 8080
          }
        }
      }

      env {
        JAVA_HOME     = "/usr/lib/jvm/java-8-openjdk-amd64"
        CATALINA_HOME = "/u01/tomcat"
      }

      config {
        command = "/u01/tomcat/bin/catalina.sh"
        args    = ["run"]
      }

      service {
        tags = ["urlprefix-/helloworld"]
        port = "http"

        check {
          name     = "index_check"
          type     = "http"
          path     = "/helloworld/index.html"
          interval = "10s"
          timeout  = "2s"
        }
      }
    } # end task
  } # end group
} # end job
