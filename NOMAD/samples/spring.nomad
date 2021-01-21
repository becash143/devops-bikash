job "spring" {
    datacenters = ["ps"]
    region     = "qatar"

    group "spring" {
        count = 2

        network {
            mode = "bridge"
            port "http" {
                to = 7070
                // static = 7070
            }
        }
        
        task "server" {
            driver = "java"

            artifact {
                source = "http://nyc3.digitaloceanspaces.com/psmarsel/spring.jar"
            }

            // env {
            //   JAVA_HOME                       = "/usr/lib/jvm/java-8-openjdk-amd64"
            //   SERVER_PORT                     = "7070"
            //   SPRING_PROFILES_ACTIVE          =h2
            // }

            config {
                jar_path = "local/spring.jar"
                // args = ["-Dserver.port=7070 -Dspring.profiles.active=h2"]
                jvm_options = ["-Xmx512m", "-Xms256m","-Dserver.port=7070","-Dspring.profiles.active=h2"]
            }

            resources {
                cpu = 100
                memory = 512
                // network {
                //     mode = "bridge"
                //     port "http" {
                //         to = 7070
                //         static = 7070
                //     }
                // }
            }

        //     service {
        //        tags = ["spring-app"]
        //        port = "http"

        //      check {
        //        name     = "up"
        //        type     = "tcp"
        //        path     = "/actuator/health"
        //        interval = "10s"
        //        timeout  = "20s"
        //        check_restart {
        //          limit = 3
        //          grace = "90s"
        //          ignore_warnings = false
        //        }
        //      }
        //    }
        }
    }
}