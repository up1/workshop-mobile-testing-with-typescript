# Workshop
* Biometric authentication app test with WebDriverIO and Appium
* Switch context to webview and perform search in Safari

## Install app in target device
```
$flutter run
$flutter run -d <device_id> 
```

## Run test
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
