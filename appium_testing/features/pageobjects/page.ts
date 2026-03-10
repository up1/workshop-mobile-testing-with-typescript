import { browser } from "@wdio/globals";
import { remote } from "webdriverio";

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
            capabilities: {}
        });
        return driver;
    }
}
