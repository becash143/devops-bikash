pipeline {
    agent any

    tools {
        maven 'maven'
    }
    stages {
        stage("gitlab clone") {
            steps{
                git 'git@github.com:becash143/devops-bikash.git'
            }
        }
    stage ("compile") {
        steps{
            sh 'mvn compile'
        }
    }
    stage ("artifact"){
    steps{
        archiveArtifacts artifacts: 'assignment/*.jar', followSymlinks: false
    }        
    }
    }
}
