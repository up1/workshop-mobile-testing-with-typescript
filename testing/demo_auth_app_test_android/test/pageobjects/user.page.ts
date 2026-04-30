import Page from "./page.js";

class UserPage extends Page {
  public async isSuccess() {
    // Check value of element
    const el3 = await driver.$('-android uiautomator:new UiSelector().description("Welcome!")');
    // wait for element to be clickable in android app
    await el3.waitForDisplayed({ timeout: 5000 });
    
    const value = await el3.getAttribute("content-desc");
    await expect(value).toContain("Welcome!");
    
    await driver.pause(3000); // Simulate waiting time for the scan process
  }

}

export default new UserPage();
