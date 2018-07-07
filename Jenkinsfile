pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        sh '''stack build
stack exec hakyll build'''
      }
    }
    stage('deploy') {
      steps {
        sh '''WEB_DIR=/var/lib/containers/barrucadu/srv/http/memo
rm -r $WEB_DIR/*
cp -a _site/* $WEB_DIR'''
      }
    }
  }
}
