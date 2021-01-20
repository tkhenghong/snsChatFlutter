
def appname = "Runner" //DON'T CHANGE THIS. This refers to the flutter 'Runner' target.
def xcarchive = "${appname}.xcarchive"

pipeline {
    agent { label 'Jenkins_PocketChat_Flutter' } //Change this to whatever your flutter jenkins nodes are labeled.
    //environment {
    //    DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer/"  //This is necessary for Fastlane to access iOS Build things.
    //    PATH = "/Users/jenkins/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Users/jenkins/Documents/flutter/bin:/usr/local/Caskroom/android-sdk/4333796//tools:/usr/local/Caskroom/android-sdk/4333796
    //platform-tools:/Applications/Xcode.app/Contents/Developer"
    //}
    stages {
        stage('Build') {
                    steps {
                        echo "Database engine is ${DB_ENGINE}"
                        echo "FIREBASE_APP_ID_DEVELOPMENT is ${FIREBASE_APP_ID_DEVELOPMENT}"
                        sh 'printenv'
                    }
                }

    }
}