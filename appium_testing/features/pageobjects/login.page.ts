import Page from './page';

/**
 * sub page containing specific selectors and methods for a specific page
 */
class LoginPage extends Page {
    
    public get btnSubmit () {
        return driver.$('accessibility id:login_submit_button');
    }

    /**
     * a method to encapsule automation code to interact with the page
     * e.g. to login using username and password
     */
    public async login (username: string, password: string) {
        // Find username and password input fields and set their values and wait for value to be set before clicking the login button
        const inputUsername = await driver.$("-android uiautomator:new UiSelector().resourceId(\"login_username_field2\")");
        await inputUsername.click();
        await inputUsername.setValue(username);
        
        const inputPassword = await driver.$("-android uiautomator:new UiSelector().resourceId(\"login_password_field2\")");
        await inputPassword.click();
        await inputPassword.setValue(password);
        
        await this.btnSubmit.click();
    }

    /**
     * overwrite specific options to adapt it to page object
     */
    public async openNativeApp () {
        return await super.openNativeApp();
    }
}

export default new LoginPage();
