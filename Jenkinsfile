def appname = "Runner" // DON'T CHANGE THIS. This refers to the flutter 'Runner' target.
def xcarchive = "${appname}.xcarchive"

pipeline {
    agent { label 'macos' } // Change this to whatever your flutter jenkins nodes are labeled. ('master', 'macos', 'windows')
    // environment {
        // Nothing.
    // }
    stages {
        stage('Place Secrets Files') {
            steps {
                // Environment Secret Variables
                withCredentials([
                file(credentialsId: 'PocketChat_Android_Secret_Environment_File', variable: 'PocketChat_Android_Secret_Environment_File'),

                // Release Notes
                file(credentialsId: 'PocketChat_Android_Development_Release_Notes_File', variable: 'PocketChat_Android_Development_Release_Notes_File'),
                file(credentialsId: 'PocketChat_Android_UAT_Release_Notes_File', variable: 'PocketChat_Android_UAT_Release_Notes_File'),
                file(credentialsId: 'PocketChat_Android_Production_Release_Notes_File', variable: 'PocketChat_Android_Production_Release_Notes_File'),

                // Testers
                file(credentialsId: 'PocketChat_Android_Development_Testers_File', variable: 'PocketChat_Android_Development_Testers_File'),
                file(credentialsId: 'PocketChat_Android_UAT_Testers_File', variable: 'PocketChat_Android_UAT_Testers_File'),
                file(credentialsId: 'PocketChat_Android_Production_Testers_File', variable: 'PocketChat_Android_Production_Testers_File'),
                file(credentialsId: 'PocketChat_Google_Play_Console_GCP_Service_Account_JSON_File', variable: 'PocketChat_Google_Play_Console_GCP_Service_Account_JSON_File')
                ]) {
                    // Environment Secret Variables
                    sh "cp \$PocketChat_Android_Secret_Environment_File android/fastlane/.env.default"

                    // Release Notes
                    sh "cp \$PocketChat_Android_Development_Release_Notes_File android/fastlane/release_notes/release_notes_development.txt"
                    sh "cp \$PocketChat_Android_UAT_Release_Notes_File android/fastlane/release_notes/release_notes_uat.txt"
                    sh "cp \$PocketChat_Android_Production_Release_Notes_File android/fastlane/release_notes/release_notes_production.txt"

                    // Testers
                    sh "cp \$PocketChat_Android_Development_Testers_File android/fastlane/testers/testers_development.txt"
                    sh "cp \$PocketChat_Android_UAT_Testers_File android/fastlane/testers/testers_uat.txt"
                    sh "cp \$PocketChat_Android_Production_Testers_File android/fastlane/testers/testers_production.txt"

                    // Google Service Account Credential File
                    sh "cp \$PocketChat_Google_Play_Console_GCP_Service_Account_JSON_File android/fastlane/service_account/pocketchat-b3e0f-5339c659d2b2.json"
                }
            }
        }
        stage('Build and Distribute Flutter Android APK') {
            steps {
                dir("android") {
                    // Firebase App Distribution
                    sh "bundle exec fastlane distribute_production_release_to_dev"
                    sh "bundle exec fastlane distribute_production_release_to_uat"
                    sh "bundle exec fastlane distribute_production_release_to_prod"

                    // Microsoft AppCenter (MAC)
                    sh "bundle exec fastlane deploy_to_app_center_development"
                    sh "bundle exec fastlane deploy_to_app_center_uat"
                    sh "bundle exec fastlane deploy_to_app_center_production"
                }
            }
        }
    }
}
