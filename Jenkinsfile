def appname = "Runner" // DON'T CHANGE THIS. This refers to the flutter 'Runner' target.
def xcarchive = "${appname}.xcarchive"

pipeline {
    agent { label 'windows' } // Change this to whatever your flutter jenkins nodes are labeled. ('master', 'macos', 'windows')
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

                }
            }
        }

        // Android Keystore Properties Files
        stage('Configure KeyStore Properties in develop branch') {
            // In release mode, sign with different keystore when in different branch.
            when { branch 'develop'}
            steps {
                withCredentials([file(credentialsId: 'PocketChat_Android_Keystore_Development_Properties', variable: 'PocketChat_Android_Keystore_Development_Properties')]) {
                    echo 'Using Development Keystore to sign Android app.'
                    sh "cp \$PocketChat_Android_Keystore_Development_Properties android/key.release.properties"
                }
            }
        }

        stage('Configure KeyStore Properties in UAT branch') {
            // In release mode, sign with different keystore when in different branch.
            when { branch 'uat'}
            steps {
                withCredentials([file(credentialsId: 'PocketChat_Android_Keystore_UAT_Properties', variable: 'PocketChat_Android_Keystore_UAT_Properties')]) {
                    echo 'Using UAT Keystore to sign Android app.'
                    sh "cp \$PocketChat_Android_Keystore_UAT_Properties android/key.release.properties"
                }
            }
        }

        stage('Configure KeyStore Properties in Production branch') {
            when { branch 'production'}
            steps {
                withCredentials([file(credentialsId: 'PocketChat_Android_Keystore_UAT_Properties', variable: 'PocketChat_Android_Keystore_UAT_Properties')]) {
                    echo 'Using Production Keystore to sign Android app.'
                    sh "cp \$PocketChat_Android_Keystore_Production_Properties android/key.release.properties"
                }
            }
        }

        stage('Install Ruby Dependencies with Bundler') {
            steps {
                dir("android") {
                    sh "bundle install"
                }
            }
        }

        stage('Build and Distribute Flutter Android APK to Development Environment') {
            when { branch 'develop'}
            steps {
                dir("android") {
                    // Firebase App Distribution
                    echo 'Deploy the app to Development in Firebase App Distribution.'
                    sh "bundle exec fastlane distribute_production_release_to_dev"

                    // Microsoft AppCenter (MAC)
                    echo 'Deploy the app to Development in Microsoft AppCenter.'
                    sh "bundle exec fastlane deploy_to_app_center_development"
                }
            }
        }

        stage('Build and Distribute Flutter Android APK to UAT Environment') {
            when { branch 'uat'}
            steps {
                dir("android") {
                    // Firebase App Distribution
                    echo 'Deploy the app to UAT in Firebase App Distribution.'
                    sh "bundle exec fastlane distribute_production_release_to_uat"

                    // Microsoft AppCenter (MAC)
                    echo 'Deploy the app to UAT in Microsoft AppCenter.'
                    sh "bundle exec fastlane deploy_to_app_center_uat"
                }
            }

        }

        stage('Build and Distribute Flutter Android APK to Production Environment') {
            when { branch 'production'}
            steps {
                dir("android") {
                    // Firebase App Distribution
                    echo 'Deploy the app to Production in Firebase App Distribution.'
                    sh "bundle exec fastlane distribute_production_release_to_prod"

                    // Microsoft AppCenter (MAC)
                    echo 'Deploy the app to Production in Microsoft AppCenter.'
                    sh "bundle exec fastlane deploy_to_app_center_production"
                }
            }
        }
    }
}
