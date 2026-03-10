# Appium testing with [WebDriverIO](https://webdriver.io/docs/gettingstarted)

## Step 1 :: Create project
* E2E Testing - of Web or Mobile Applications
  * Mobile - native, hybrid and mobile web apps, on Android or iOS
  * Cucumber (https://cucumber.io/)
  * TypeScript
  * Page Object Model (POM) design pattern
  * Allure report
  * wait-for: utilities that provide functionalities to wait for certain conditions till a defined task is complete
```
$npm init wdio@latest ./
```

### Installing packages using npm:
- @wdio/local-runner@latest
- @wdio/cucumber-framework@latest
- @wdio/spec-reporter@latest
- @wdio/allure-reporter@latest
- wdio-wait-for
- @wdio/appium-service@latest
- @types/node
- @wdio/globals@latest
- expect-webdriverio
- appium-uiautomator2-driver

### Install TypeScript and ts-node:
```
$npm install typescript ts-node --save-dev
```

## Step 2 :: Run tests
```
$npm run wdio:ios
$npm run wdio:android
```

Run with tags:
```
$npm run wdio:ios -- --cucumberOpts.tags="@flow01"
$npm run wdio:ios -- --cucumberOpts.tags="@flow02"
$npm run wdio:ios -- --cucumberOpts.tags="@flow03"
$npm run wdio:ios -- --cucumberOpts.tags="@flow04"
```

## Step 3 :: View Allure report
* https://allurereport.org/docs/webdriverio/
```
$allure generate
$allure serve
```