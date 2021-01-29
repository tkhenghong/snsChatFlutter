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
                file(credentialsId: 'PocketChat_Google_Play_Console_GCP_Service_Account_JSON_File', variable: 'PocketChat_Google_Play_Console_GCP_Service_Account_JSON_File'),

                // Android Keystore
                file(credentialsId: 'PocketChat_Android_Keystore_Development', variable: 'PocketChat_Android_Keystore_Development'),
                file(credentialsId: 'PocketChat_Android_Keystore_UAT', variable: 'PocketChat_Android_Keystore_UAT'),
                file(credentialsId: 'PocketChat_Android_Keystore_Production', variable: 'PocketChat_Android_Keystore_Production'),

                // Android Keystore Properties Files
                file(credentialsId: 'PocketChat_Android_Keystore_Development_Properties', variable: 'PocketChat_Android_Keystore_Development_Properties'),
                file(credentialsId: 'PocketChat_Android_Keystore_UAT_Properties', variable: 'PocketChat_Android_Keystore_UAT_Properties'),
                file(credentialsId: 'PocketChat_Android_Keystore_Production_Properties', variable: 'PocketChat_Android_Keystore_Production_Properties')
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

                    // Android Keystore
                    sh "cp \$PocketChat_Android_Keystore_Development android/keystores/development/pocketchat_development.keystore"
                    sh "cp \$PocketChat_Android_Keystore_UAT android/keystores/uat/pocketchat_uat.keystore"
                    sh "cp \$PocketChat_Android_Keystore_Production android/keystores/production/pocketchat_production.keystore"

                    // Android Keystore Properties Files
                    sh "cp \$PocketChat_Android_Keystore_Development_Properties android/key.properties"
                    sh "cp \$PocketChat_Android_Keystore_UAT_Properties android/key.profile.properties"
                    sh "cp \$PocketChat_Android_Keystore_Production_Properties android/key.production.properties"
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
