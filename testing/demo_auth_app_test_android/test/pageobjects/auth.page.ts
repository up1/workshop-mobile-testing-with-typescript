import AndroidSettings from "../utils/AndroidSettings.js";
import Page from "./page.js";

class AuthPage extends Page {
  public async scanFingerprintWithSuccess() {

    // Enable biometric login in Android settings first to make sure the app can show the fingerprint scan screen
    // await this.enableBiometric();

    const el2 = await driver.$('-android uiautomator:new UiSelector().description("Scan")');
    await el2.waitForDisplayed({ timeout: 5000 });
    await el2.click();

    // Simulate successful fingerprint scan
    if (driver.isAndroid) {
      console.log("Simulating successful fingerprint scan on Android");
      await this.androidBiometryAlert.waitForDisplayed({ timeout: 5000 });
      // loop until the alert is gone, which means the fingerprint scan is successful and the app has moved on from the biometric prompt
      while (await this.androidBiometryAlert.isDisplayed()) {
        await driver.fingerPrint(1); // Simulate successful fingerprint scan on Android
         await driver.fingerPrint(1); // Simulate successful fingerprint scan on Android
        await driver.pause(5000); // Wait for a second before checking again
        console.log("Waiting for biometric alert to disappear...");
      }
      console.log("Fingerprint scan successful, alert is gone");
    } else {
      console.warn("Biometric simulation is only implemented for Android in this example.");
      await driver.fingerPrint(1); // Simulate successful fingerprint scan on Android
    }
  }

  private get androidBiometryAlert() {
        const regex = 'Authentication required';
        return $(`android=new UiSelector().textMatches("${regex}")`);
    }

  async enableBiometric() {
    await AndroidSettings.enableBiometricLogin();
  }

}

export default new AuthPage();
