import { browser } from "@wdio/globals";
import { remote } from "webdriverio";

const caps = {
    platformName: "Android",
    "appium:automationName": "UiAutomator2",
    "appium:appPackage": "com.example.ui",
    "appium:deviceName": "emulator-5554",
    "appium:ensureWebviewsHavePages": true,
    "appium:nativeWebScreenshot": true,
    "appium:newCommandTimeout": 3600,
    "appium:connectHardwareKeyboard": true,
};

/**
 * main page object containing all methods, selectors and functionality
 * that is shared across all page objects
 */
export default class Page {

    /**
     * Opens a sub page of the page
     * @param path path of the sub page (e.g. /path/to/page.html)
     */
    public open(path: string) {
        return browser.url(`https://the-internet.herokuapp.com/${path}`);
    }

    public async openNativeApp() {
        const driver = await remote({
            protocol: "http",
            hostname: "127.0.0.1",
            port: 4723,
            path: "/",
            capabilities: caps
        });
        return driver;
    }
}
