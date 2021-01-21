job "mpay" {
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
    healthy_deadline  = "5m"
    auto_revert = false

    # The "progress_deadline" parameter specifies the deadline in which an
    # allocation must be marked as healthy. The deadline begins when the first
    # allocation for the deployment is created and is reset whenever an allocation
    # as part of the deployment transitions to a healthy state. If no allocation
    # transitions to the healthy state before the progress deadline, the
    # deployment is marked as failed.
    progress_deadline = "10m"
  }

  group "mpay" {
    count = 1

    restart {
      attempts = 2
      interval = "15m"
      delay = "15s"
      mode = "fail"
    }

    task "webapp" {

        driver = "raw_exec"

        artifact {
            source = "http://nyc3.digitaloceanspaces.com/psmarsel/mpay-khal.jar"
        }

        env {
            db_driver="oracle.jdbc.OracleDriver"
            db_type="ORACLE10"
            db_validation_query="SELECT 1 FROM DUAL"
            db_dialect="org.hibernate.dialect.Oracle10gDialect"
            db_check_query="select count(*) from user_tables"
            db_url="jdbc:oracle:thin:@127.0.0.1:1521/EE.oracle.docker"
            db_user="mpay"
            db_password="mpay"
            db_schema="mpay"
            env_broker_url="tcp://localhost:61616"
            env_broker_url_mpc="tcp://localhost:61616"
        }

        config {
            command = "java"
            args = ["-Xmx2048m", "-Xms1024m","-Djava.security.egd=file:/dev/urandom","-jar","local/mpay-khal.jar"]
        }

        service {
          tags = ["webapp"]
          port = "http"
          check {
               name     = "health_check_http"
               type     = "http"
               port     = "http"
               path     = "/"
               interval = "40s"
               timeout  = "5s"
               check_restart {
                 limit = 5
                 grace = "40s"
                 ignore_warnings = false
               }
             }
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
               static = 7070 
              }
           }
        }
      }
    }
}