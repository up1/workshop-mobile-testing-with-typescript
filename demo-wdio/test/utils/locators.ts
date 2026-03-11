import { config } from "../../wdio.conf";

/**
 * Manage locator for iOS and Android
 * Dynamic switching between iOS and Android locators can be implemented here based on the platform being tested
 */
export default class ManageLocator {
    // Get element based on locator type and platform
    public static getElement(locator: string) {
        if (config.capabilities[0].platformName === "iOS") {
            return driver.$(`accessibility id:${locator}`);
        } else {
            return driver.$(`-android uiautomator:new UiSelector().resourceId("${locator}")`);
        }
    }

    // Get Element list based on locator type and platform
    public static getElementList(locator: string) {
        if (config.capabilities[0].platformName === "iOS") {
            return driver.$$(`accessibility id:${locator}`);
        } else {
            return driver.$$(`-android uiautomator:new UiSelector().resourceId("${locator}")`);
        }
    }

    // Get text of element based on locator type and platform
    public static async getElementText(locator: string) {
        const element = await this.getElement(locator);
        if (config.capabilities[0].platformName === "iOS") {
            return element.getText();
        } else {
            return element.getAttribute("content-desc");
        }
    }

}