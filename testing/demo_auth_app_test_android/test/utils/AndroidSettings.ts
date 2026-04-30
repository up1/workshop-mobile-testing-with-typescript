class AndroidSettings {
    /**
     * Execute ADB commands on the device
     */
    private async executeAdbCommand(adbCommand: string) {
        await driver.execute('mobile: shell', {
            command: adbCommand,
        });
    }

    /**
     * Find an Android element based on text that matches a regular expression which is case insensitive
     */
    async findAndroidElementByMatchingText(string: string) {
        const selector = `android=new UiSelector().textMatches("(?i)${string}")`;

        return $(selector);
    }

    /**
     * Wait on an element
     */
    async waitForMatchingElement(string: string) {
        await (await this.findAndroidElementByMatchingText(string)).waitForDisplayed({ timeout: 10 * 1000 });
    }
    /**
     * Wait and click on an element
     */
    async waitAndTap(string: string) {
        await this.waitForMatchingElement(string);
        await (await this.findAndroidElementByMatchingText(string)).click();
    }

    /**
     * Close the settings Screen lock notifications
     */
    async closeSettingsScreenLockNotifications() {
        try {
            if (await (await this.findAndroidElementByMatchingText('Set screen lock')).isDisplayed()) {
                await $('android=new UiSelector().descriptionContains("Dismiss")').click();
                await $('android=new UiSelector().textMatches("(?i)Dismiss")').click();
            }
        } catch (ign) { /* do nothing */ }
    }

    /**
     * This is the core methods to enable FingerPrint for Android. It will walk through all steps to enable
     * FingerPrint on Android 9 (2018) till the latest one all automatically for you.
     */
    async enableBiometricLogin() {
        // Open the settings screen and set screen lock to pin
        const DEFAULT_PIN = '1234';
        await this.executeAdbCommand(
            `am start -a android.settings.SECURITY_SETTINGS && locksettings set-pin ${DEFAULT_PIN}`,
        );
        // As of Android 14 there is a new flow to enable finger print
            // There might be two Device unlock options, the first is the notification, the second is the actual setting
            // First wait for the right screen to be shown
            await this.waitForMatchingElement('Device unlock.*');
            // Android 14 might have notifications that might block searching the right element, so we need to close them
            await this.closeSettingsScreenLockNotifications();
            await this.waitAndTap('Device unlock');
            await this.waitAndTap('Pixel Imprint'); // The name might be different based on the device manufacturer, you can check it by running `adb shell dumpsys fingerprint` and look for the "Sensor Properties" section to find the correct name to use in the selector
            // await this.waitAndTap('.*Fingerprint.*Unlock.*'); // Android 14
            // await this.waitAndTap('.*Fingerprint.*');
        
        // await this.fingerPrintWizard(DEFAULT_PIN);

    }
}

export default new AndroidSettings();