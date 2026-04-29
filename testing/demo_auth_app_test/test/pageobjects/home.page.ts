import { Key } from 'webdriverio';
import Page from "./page.js";

class HomePage extends Page {

  public async verifyPageLoaded() {
    // Get context to app   and switch to it
    const contexts = await driver.getContexts();
    // print contexts to debug
    console.table(contexts);
    const appContext = contexts.find((context) => context.toString().includes("NATIVE_APP"));
    if (appContext) {
      await driver.switchContext(appContext);
    }

    const el1 = await driver.$("accessibility id:Sign in with biometrics");
    await el1.waitForDisplayed({ timeout: 5000 });
  }

  public async clickFingerprint() {
    const element = await driver.$(
      "accessibility id:fingerprint_button"
    );
    // wait for element to be clickable in ios app
    await element.waitForDisplayed({ timeout: 5000 });
    await element.click();
  }

  public async clickFaceScan() {
    const element = await driver.$(
      "accessibility id:facescan_button"
    );
    // wait for element to be clickable in ios app
    await element.waitForDisplayed({ timeout: 5000 });
    await element.click();
  }

  public async clickOpenBrowser() {
    const element = await driver.$(
      "accessibility id:open_browser_button"
    );
    // wait for element to be clickable in ios app
    await element.waitForDisplayed({ timeout: 5000 });
    await element.click();

    // Wait open web browser and switch context from native to web
    await driver.pause(3000);
    // 1. Get all available contexts
    const contexts = await driver.getContexts();

    // 2. Identify the Safari context (usually starts with WEBVIEW)
    const webviewContext = contexts.find(c => c.toString().includes('WEBVIEW'));

    // 3. Switch to it
    if (webviewContext) {
      console.log(`Switching to context: ${webviewContext}`);
      await driver.switchContext({
        url: /.*\.google\.com.*/i, // Match any URL containing .google.com
      });
    }


    // In safari Fill in element with name=q with hello and press enter
    console.log("Switch to web context and perform search in Safari");
    const searchInput = await driver.$('textarea[name="q"]');
    await searchInput.waitForDisplayed({ timeout: 5000 });
    await searchInput.click();
    await driver.pause(3000);

    // Fill in data from keyboard with "hello" and press enter in webview context
    await driver.keys(['h']);
    await driver.keys(['e']);
    await driver.keys(['l']);
    await driver.keys(['l']);
    await driver.keys(['o']);
    await driver.keys([Key.Enter]);
    await driver.pause(3000);

    // Switch back to app context
    const appContext = contexts.find((context) => context.toString().includes("NATIVE_APP"));
    if (appContext) {
      await driver.switchContext(appContext);
    }
    await driver.pause(3000);

    // BAck to app
    await driver.execute('mobile: activateApp', { bundleId: 'com.example.demoAuthApp' })

    // Go to fingerprint page again
    await this.clickFingerprint();
  }

}

export default new HomePage();
