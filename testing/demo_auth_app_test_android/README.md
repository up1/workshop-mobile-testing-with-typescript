# Workshop
* Biometric authentication app test with WebDriverIO and Appium
* Switch context to webview and perform search in Google Chrome

## Install app in target device
```
$flutter run
$flutter run -d <device_id> 
```

## Run test
* Check JAVA_HOME and ANDROID_HOME environment variables are set correctly

Manage fingerprints in Android Emulator
```
$adb -e emu finger touch 1
$adb -e emu finger remove. # Remove before run test
```

Install
```
$npm install

// All
$npm run wdio

// By file
$npm run wdio -- --spec switch.context.test.e2e.ts
```

## Generate report with Allure
```
$npm run report
```
