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
## iOS
### ios build_project
```
fastlane ios build_project
```
Clean the project, Get dependencies, and Test
### ios build_app_badge_icon_for_development
```
fastlane ios build_app_badge_icon_for_development
```
Build App Badge Icon for Development
### ios build_app_badge_icon_for_integration
```
fastlane ios build_app_badge_icon_for_integration
```
Build App Badge Icon for Integration(UAT)
### ios build_app_badge_icon_for_production
```
fastlane ios build_app_badge_icon_for_production
```
Build App Badge Icon for Production
### ios build_development_release_ipa
```
fastlane ios build_development_release_ipa
```
Build Flutter Development Release IPA
### ios build_integration_release_ipa
```
fastlane ios build_integration_release_ipa
```
Build Flutter Integration Release IPA
### ios build_production_release_ipa
```
fastlane ios build_production_release_ipa
```
Build Flutter Production Release IPA
### ios distribute_production_release_to_dev
```
fastlane ios distribute_production_release_to_dev
```
Distribute Production Release Android app to Development Team/Tester Through Firebase App Distribution
### ios distribute_production_release_to_uat
```
fastlane ios distribute_production_release_to_uat
```
Distribute Production Release Android app to UAT Team/Testers Through Firebase App Distribution
### ios distribute_production_release_to_prod
```
fastlane ios distribute_production_release_to_prod
```
Distribute Production Release Android app Production Team/Testers Through Firebase App Distribution
### ios deploy_to_app_center_development
```
fastlane ios deploy_to_app_center_development
```
Submit a new Development(Alpha) Release Build to Microsoft AppCenter
### ios deploy_to_app_center_uat
```
fastlane ios deploy_to_app_center_uat
```
Submit a new UAT(Beta) Release Build to Microsoft AppCenter
### ios deploy_to_app_center_production
```
fastlane ios deploy_to_app_center_production
```
Submit a new Production(Production) Release Build to Microsoft AppCenter

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
