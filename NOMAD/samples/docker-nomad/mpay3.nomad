job "mpay3" {
  datacenters = ["dc1"]
  # Run this job as a "service" type. Each job type has different
  # properties. See the documentation below for more examples.
  // type = "service"
  # Specify this job to have rolling updates, two-at-a-time, with
  # 30 second intervals.
    // update {
    //   stagger = "10s"
    //   max_parallel = 1
    // }
  # A group defines a series of tasks that should be co-located
  # on the same client (host). All tasks within a group will be
  # placed on the same host.
  group "mpay3" {
    # Specify the number of these tasks we want.
  network {
       port "mpay3" {
             static = 5050
             to     = 7070
  }
 }
    count = 1
    restart {
      attempts = 2
      interval = "15m"
      delay = "15s"
      mode = "fail"
    }
    # Create an individual task (unit of work). This particular
    # task utilizes a Docker container to run application.
    task "mpay-ui" {
      driver = "docker"
      env {
        // db_username = "MPAY"
        db_schema = "mpay"
        db_engine = "oracle"
        db_user= "mpay"
        db_password= "mpay"
        db_external = "true"
        db_host = "10.136.0.2"
        db_port = "1521"
        db_instance = "EE.oracle.docker"
        db_url = "jdbc:oracle:thin:@10.136.0.2:1521/EE.oracle.docker"
        db_type = "ORACLE10"
        db_driver = "oracle.jdbc.OracleDriver"
        db_dialect = "org.hibernate.dialect.Oracle10gDialect"
        db_validation_query = "SELECT 1 FROM DUAL"
        db_check_query = "SELECT COUNT(*) FROM USER_TABLES"
        env_broker_url = "tcp://10.136.0.2:61616"
        mpc_env_broker_url= "tcp://10.136.0.2:61616"
        MINIO_URL= "https://minio.mobile-dev.progressoft.cloud/"
        MINIO_ACCESS_KEY= "minio"
        MINIO_SECRET_KEY= "P@ssw0rd"
        CATALINA_OPTS="-Xms1024m -Xmx4096m -Djava.security.egd=file:/dev/urandom"
      }
      config {
        command = "/usr/local/tomcat/bin/catalina.sh"
        args = ["run"]
        //auth {
         // username = "developer"
         // password = "FBvAgfFHV8k8eHUh"
        //}
        image = "qibmpay:test"
        ports = ["mpay3"]
      }
       resources {
         memory = 4096
        }

    }
  }
}
