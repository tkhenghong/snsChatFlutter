def appname = "Runner" // DON'T CHANGE THIS. This refers to the flutter 'Runner' target.
def xcarchive = "${appname}.xcarchive"

pipeline {
    agent { label 'macos' } //Change this to whatever your flutter jenkins nodes are labeled.
    environment {
    FIREBASE_APP_ID_DEVELOPMENT = credentials('FIREBASE_APP_ID_DEVELOPMENT')
    VERSION_NUMBER = "1.0.0"
    }
    stages {
        stage('Place Secrets Files') {
            steps {
                withCredentials([file(credentialsId: 'PocketChat_Android_Secret_Environment_File', variable: 'PocketChat_Android_Secret_Environment_File')]) {
                    sh "pwd"
                    sh "ls -lrt"
                    sh "cp \$PocketChat_Android_Secret_Environment_File android/fastlane/.env.default"
                }
            }
        }
        stage('Test build a Flutter Android APK') {
            steps {
                sh "pwd"
                sh "ls -lrt"
                dir("android/fastlane") {
                    sh "pwd"
                    sh "ls -lrt"
                }
                dir("android") {
                    sh "bundle exec fastlane build_development_release_apk"
                }
            }
        }
    }
}
