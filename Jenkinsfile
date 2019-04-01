pipeline {
  agent any
  environment {
    PLEROMA_PASSWORD = credentials('pleroma-user-memo-password')
  }
  stages {
    stage('build') {
      steps {
        sh '''stack build
stack exec hakyll build'''
      }
    }
    stage('deploy') {
      steps {
        sh '''WEB_DIR=/srv/http/barrucadu.co.uk/memo
rm -r $WEB_DIR/*
cp -a _site/* $WEB_DIR'''
      }
    }
    stage('notify') {
      steps {
        sh '''./post-pleroma-status'''
      }
    }
  }
}
