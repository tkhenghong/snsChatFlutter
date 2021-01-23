fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## Android
### android build_project
```
fastlane android build_project
```
Clean the project, Get dependencies, and Test
### android build_app_badge_icon_for_development
```
fastlane android build_app_badge_icon_for_development
```
Build App Badge Icon for Development
### android build_app_badge_icon_for_integration
```
fastlane android build_app_badge_icon_for_integration
```
Build App Badge Icon for Integration(UAT)
### android build_app_badge_icon_for_production
```
fastlane android build_app_badge_icon_for_production
```
Build App Badge Icon for Production
### android build_development_release_apk
```
fastlane android build_development_release_apk
```
Build Flutter Development Release APK
### android build_integration_release_apk
```
fastlane android build_integration_release_apk
```
Build Flutter Integration Release APK
### android build_production_release_apk
```
fastlane android build_production_release_apk
```
Build Flutter Production Release APK
### android distribute_production_release_to_dev
```
fastlane android distribute_production_release_to_dev
```
Distribute Production Release Android app to Development Team/Tester Through Firebase App Distribution
### android distribute_production_release_to_uat
```
fastlane android distribute_production_release_to_uat
```
Distribute Production Release Android app to UAT Team/Testers Through Firebase App Distribution
### android distribute_production_release_to_prod
```
fastlane android distribute_production_release_to_prod
```
Distribute Production Release Android app Production Team/Testers Through Firebase App Distribution
### android deploy_to_app_center_development
```
fastlane android deploy_to_app_center_development
```
Submit a new Development(Alpha) Release Build to Microsoft AppCenter
### android deploy_to_app_center_uat
```
fastlane android deploy_to_app_center_uat
```
Submit a new UAT(Beta) Release Build to Microsoft AppCenter
### android deploy_to_app_center_production
```
fastlane android deploy_to_app_center_production
```
Submit a new Production(Production) Release Build to Microsoft AppCenter

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
