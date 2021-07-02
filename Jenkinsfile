pipeline
 {
  agent any

  tools
   {
    maven 'maven'
   }

  options
   {
    buildDiscarder(logRotator(numToKeepStr: '4'))
    skipStagesAfterUnstable()
    disableConcurrentBuilds()
   }


  triggers
   {
    // MINUTE HOUR DOM MONTH DOW
    pollSCM('H 6-18/4 * * 1-5')
   }


  stages
   {
    stage('Clean')
     {
      steps
       {
        script
         {
          if (isUnix()) 
           {
            sh 'mvn --batch-mode clean'
           }
          else
           {
            bat 'mvn --batch-mode clean'
           }
         }
       }
     }

    stage('Build')
     {
      steps
       {
        script
         {
          if (isUnix()) 
           {
            sh 'mvn --batch-mode compile'
           }
          else
           {
            bat 'mvn --batch-mode compile'
           }
         }
       }
     }

    stage('Packaging')
     {
      steps
       {
        script
         {
          if (isUnix()) 
           {
            sh 'mvn --batch-mode jar:jar'
           }
          else
           {
            bat 'mvn --batch-mode jar:jar'
           }
         }
       }
     }

    stage('install local')
     {
      steps
       {
        script
         {
          if (isUnix()) 
           {
            sh 'mvn --batch-mode jar:jar source:jar install:install'
           }
          else
           {
            bat 'mvn --batch-mode jar:jar source:jar install:install' // maven-jar-plugin falseCreation default is false, so no doubled jar construction here, but required for maven-install-plugin internal data
           }
         }
       }
     }

    stage('Documentation')
     {
      steps
       {
        script
         {
          if (isUnix()) 
           {
            sh 'mvn --batch-mode site'
           }
          else
           {
            bat 'mvn --batch-mode site'
           }
         }
       }


   }

 }
