# Deployment instructions
The following steps will help you to deploy the flutter application for both, iOS and Android app stores.
## Preparation
Make sure that your environment variables are correct and pointing to the production endpoints
## Change the version number before you deploy a new version
Go to pubspec.yaml and change the version there

## **iOS Deployment**
### Create a new build for ios
    flutter pub get
    flutter build ipa
### Analyse and deploy the new build

1. Go to Xcode and open the file at:
> <**flutter_project**>/build/ios/archive/Runner.xcarchive
2. Click on Analyse and follow steps until successfull If any issues
   show up, correct them and build again.
3. Click on Distribuite and follow steps on screen.

## **Android Deployment**

### Create upload signature
PlayStore requires that you have an *upload signature* before you can upload your app bundle, which you can create with the following:

1. Make sure that you have JDK installed and in your path
2. Run the following command to generate and save the upload keystore to your home directory:
```sh
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias mycartransport -storetype JKS
```
### Build App bundle
1. Build the App bundle with the following:
```sh
flutter build appbundle
```
2. Usually the app bundle saves at
> <**flutter_project**>/build/app/outputs/bundle/release/app-release.aab

### Upload the app bundle to Google Play

1. Login to the console at https://play.google.com/console/
2. Select the right project MCA inspections which will take you to the dashboard
3. Select the Release Testing/Production menu from the left.
4. Click on the button Create new release Upload the App Bunddle produced before and follow the steps to finish the new release