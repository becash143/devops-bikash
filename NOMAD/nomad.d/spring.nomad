job "spring" {
  datacenters = ["dc1"]
  type = "service"

  # Note that during the deploymet the service health check depends on the update policy 
  #In terms of putting the app in health/unhealth statet and sucess/fail state
  #if the the health check service exeed the the time on  healthy_deadline nomad will
  #consider the application as unhealth, but it will keep restarting the app until it exeed 
  # progress_deadline then it will mark the job as failed and will stop restarting the app
  update {
    max_parallel      = 1

    # The "canary" parameter specifies that changes to the job that would result
    # in destructive updates should create the specified number of canaries
    # without stopping any previous allocations. Once the operator determines the
    # canaries are healthy, they can be promoted which unblocks a rolling update
    # of the remaining allocations at a rate of "max_parallel".
    #
    # Further, setting "canary" equal to the count of the task group allows
    # blue/green deployments. When the job is updated, a full set of the new
    # version is deployed and upon promotion the old version is stopped.
    canary            = 1

    #health_check Specifies the mechanism in which allocations health is determined. 
    #"checks" - Specifies that the allocation should be considered healthy 
    #when all of its tasks are running and their associated checks are healthy, 
    #and unhealthy if any of the tasks fail or not all checks become healthy.
    health_check      = "checks"
    min_healthy_time  = "10s"
    
    # The "healthy_deadline" parameter specifies the deadline in which the
    # allocation must be marked as healthy after which the allocation is
    # automatically transitioned to unhealthy.Transitioning to unhealthy will
    # fail the deployment and potentially roll back the job if "auto_revert" is
    # set to true.
    healthy_deadline  = "7m"
    auto_revert = false

    # The "progress_deadline" parameter specifies the deadline in which an
    # allocation must be marked as healthy. The deadline begins when the first
    # allocation for the deployment is created and is reset whenever an allocation
    # as part of the deployment transitions to a healthy state. If no allocation
    # transitions to the healthy state before the progress deadline, the
    # deployment is marked as failed.
    progress_deadline = "10m"
  }

  group "spring" {
    count = 2

    restart {
      attempts = 2
      interval = "15m"
      delay = "15s"
      mode = "fail"
    }

    task "webapp" {

        driver = "raw_exec"

        artifact {
            source = "http://nyc3.digitaloceanspaces.com/psmarsel/khal-spring.jar"
        }

        env {
            SPRING_DATASOURCE_URL="jdbc:oracle:thin:@localhost:1521/EE.oracle.docker"
            SPRING_DATASOURCE_USERNAME="mpay"
            SPRING_DATASOURCE_PASSWORD="mpay"
            SERVER_PORT="${NOMAD_PORT_http}"
            SPRING_DATASOURCE_DRIVER-CLASS-NAME="oracle.jdbc.OracleDriver"
            SPRING_ACTIVEMQ_BROKERURL="tcp://localhost:61616"
            SPRING_ACTIVEMQ_BROKERURL_LOCAL="tcp://localhost:61616"
        }

        config {
            command = "java"
            args = ["-Xmx2048m", "-Xms1024m","-Djava.security.egd=file:/dev/urandom","-jar","local/khal-spring.jar"]
        }

        service {
          tags = ["webapp","urlprefix-/"]
          port = "http"
          // check {
          //      name     = "health_check_http"
          //      type     = "http"
          //      port     = "http"
          //      path     = "/actuator/health"
          //      interval = "60s"
          //      timeout  = "5s"
          //      check_restart {
          //        limit = 5
          //        grace = "60s"
          //        ignore_warnings = false
          //      }
          //    }
          check {
            name     = "health_check_tcp"
            type     = "tcp"
            port     = "http"
            interval = "40s"
            timeout  = "5s"
            check_restart {
                 limit = 5
                 grace = "40s"
                 ignore_warnings = false
               }
          }
        }

        resources {
           cpu    = 100 # MHz
           memory = 1024 # MB
           network {
             mbits = 50
             port "http" {
               
             }
           }
        }
      }
    }
}