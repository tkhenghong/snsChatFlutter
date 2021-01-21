def appname = "Runner" //DON'T CHANGE THIS. This refers to the flutter 'Runner' target.
def xcarchive = "${appname}.xcarchive"

pipeline {
    agent { label 'macos' } //Change this to whatever your flutter jenkins nodes are labeled.
    environment {
    //DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer/"  //This is necessary for Fastlane to access iOS Build things.
    //PATH = "/Users/jenkins/.rbenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Users/jenkins/Documents/flutter/bin:/usr/local/Caskroom/android-sdk/4333796//tools:/usr/local/Caskroom/android-sdk/4333796
    //platform-tools:/Applications/Xcode.app/Contents/Developer"
    FIREBASE_APP_ID_DEVELOPMENT = credentials('FIREBASE_APP_ID_DEVELOPMENT')
    VERSION_NUMBER = "1.0.0"
    }
    stages {
        stage('Test build a Flutter Android APK') {
            steps {
                sh "pwd"
                //sh "flutter clean"
                //sh "flutter packages get"
                //sh "flutter test" # Commented out due to unable to rebuild DB file in the system. (Not yet solved)
                //sh "flutter pub run flutter_launcher_icons:main -f flutter_launcher_icons-production.yaml"
                //badge --shield "Development-1.0.0-orange" --no_badge --glob "/android/app/src/development/res/mipmap-*/ic_launcher.png"
                //sh "badge --shield \"Development-${VERSION_NUMBER}-orange\" --no_badge --glob \"/android/app/src/development/res/mipmap-*/ic_launcher.png\""
                //sh "flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi --flavor development --dart-define=app.flavor=development --release"
            }
        }
    }
}
