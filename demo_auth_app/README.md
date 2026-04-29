# Demo app

##  Authentication with fingerprint and face scan
```
To use real biometrics on the iOS Simulator: 
   in the simulator menu choose Features → Face ID → Enrolled, then trigger Matching Face / Non-matching Face. 

On Android emulator: 
   Settings → Security → Fingerprint to enroll, 
   then `adb -e emu finger touch 1`
```

## Mock authentication for testing
In `main.dart`, change the `authService` to `MockAuthService()`. This will allow you to test the app without using real biometrics.


## Testing and run app
```
$ flutter test
$ flutter run
```

## App information
* Android
  * package id=`com.example.demo_auth_app`
* iOS
  * PRODUCT_BUNDLE_IDENTIFIER=`com.example.demoAuthApp`


## Appium capabilities for iOS
* https://appium.io/docs/en/2.0/guides/caps/
* https://appium.github.io/appium-xcuitest-driver/11.0/reference/capabilities/
```
{
  "platformName": "iOS",
  "appium:deviceName": "iPhone 17 Pro",
  "appium:platformVersion": "26.2",
  "appium:automationName": "XCUITest",
  "appium:bundleId": "com.example.demoAuthApp",
  "appium:connectionRetryTimeout": 60000,
  "appium:noReset": true,
  "appium:autoWebview": true,
  "appium:includeSafariInWebviews": true
}
```

## Appium capabilities for Android
```
{
  "platformName": "Android",
  "appium:deviceName": "Pixel 7",
  "appium:automationName": "UiAutomator2",
  "appium:appPackage": "com.example.demo_auth_app",
  "appium:connectionRetryTimeout": 60000,
  "appium:noReset": true
}
```

## Start Appium server
```
$ appium
```

## Start Appium Inspector
* Inspect element and record test script with Appium Inspector
* Write test script with JavaScript and WebDriverIO

## Create project with [WebDriverIO](https://webdriver.io/docs/gettingstarted)

Create project with WebDriverIO CLI, choose `appium` and `mocha` as test framework. Then, update `wdio.conf.js` with the capabilities above.
* E2E Testing - of Web or Mobile Applications
* On my local machine
* Mobile - native, hybrid and mobile web apps, on Android or iOS
* [Mocha](https://mochajs.org/)
* TypeScript
* Use [page objects](https://martinfowler.com/bliki/PageObject.html)
* Allure report
* [wait-for-webdriverio](https://www.npmjs.com/package/wdio-wait-for)

```
$npm init wdio@latest demo_auth_app_test
$cd demo_auth_app_test
```

Run test
```
$npm run wdio
```

Config `wdio.conf.js` with the capabilities above, and set `specs` to `./test/specs/**/*.ts` to run all test files in the `test/specs` folder.
* maxInstances: 1 (to run tests sequentially, especially when using real devices or emulators/simulators)

## Switch context to Safari in the app and perform search
* https://webdriver.io/docs/api/mobile/switchContext/