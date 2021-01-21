job "mpay1" {
  datacenters = ["dc1"]
  type = "service"

  group "mpay" {
    count = 2

    task "webapp1" {

        driver = "raw_exec"

//        artifact {
  //          source = "http://nyc3.digitaloceanspaces.com/psmarsel/mpay-khal.jar"
    //    }

        env {
            db_driver="oracle.jdbc.OracleDriver"
            db_type="ORACLE10"
            JAVA_OPTS="${NOMAD_PORT_http}"
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
            args = ["-Xmx2048m", "-Xms1024m","-Dhttp.port=${NOMAD_PORT_http}","-jar","/root/NOMAD-POC-new/nomad/nomad.d/mpay-khal.jar"]
        }

        service {
          port = "http"
          tags = [
          "mpay",
          "urlprefix-/",
        ]
           check {
                name     = "health_check"
                type     = "http"
               port     = "http"
                path     = "/"
                interval = "10s"
                timeout  = "5s"
              }
}

        resources {
           cpu    = 100 # MHz
           memory = 1024 # MB
           network {
             mbits = 50
             port "http" { static = 7070 }
           }
        }
      }
    }
}
