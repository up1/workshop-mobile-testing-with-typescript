import Page from "./page.js";

class AuthPage extends Page {
  public async scanFingerprintWithSuccess() {
    const el2 = await driver.$("accessibility id:Scan");
    await el2.waitForDisplayed({ timeout: 5000 });
    await el2.click();

    // Simulate successful fingerprint scan
    // Wait for the scan process to complete (adjust timeout as needed)
    await driver.pause(5000); // Simulate waiting time for the scan process
    driver.touchId(true);
  }

  public async scanFaceScanWithSuccess() {
    const el2 = await driver.$("accessibility id:Scan");
    await el2.waitForDisplayed({ timeout: 5000 });
    await el2.click();

    // Simulate successful face scan
    // Wait for the scan process to complete (adjust timeout as needed)
    await driver.pause(5000); // Simulate waiting time for the scan process
    if (driver.isIOS) {
      await driver.touchId(true);
    } 
  }

}

export default new AuthPage();
