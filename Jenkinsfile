node {
  stage ('Build') {
    git url: 'git@github.com:becash143/devops-bikash.git'
    withMaven {
      sh "mvn clean verify"
    } // withMaven will discover the generated Maven artifacts, JUnit Surefire & FailSafe reports and FindBugs reports
  }
}
