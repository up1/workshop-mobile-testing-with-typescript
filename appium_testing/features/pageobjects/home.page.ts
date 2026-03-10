import ManageLocator from '../utils/locators';
import Page from './page';

class HomePage extends Page {

    public async verifyPageOnLoaded() {
        // Check welcome message is displayed and the text is correct
        const welcome_text = await ManageLocator.getElement("home_welcome_text2");
        await expect(welcome_text).toBeExisting();
        const welcomeTextValue = await ManageLocator.getElementText("home_welcome_text2");
        await expect(welcomeTextValue).toContain("Welcome to the App");

        // Check description message is displayed and the text is correct
        const description_text = await ManageLocator.getElement("home_description_text2");
        await expect(description_text).toBeExisting();
        const descriptionTextValue = await ManageLocator.getElementText("home_description_text2");
        await expect(descriptionTextValue).toContain("Please login to continue");

        // Check login button is displayed and the text is correct
        const login_button = await ManageLocator.getElement("home_login_button");
        await expect(login_button).toBeExisting();
        const loginButtonText = await ManageLocator.getElementText("home_login_button");
        await expect(loginButtonText).toContain("Login");

        // Check miniapps button is displayed and the text is correct
        const miniapps_button = await ManageLocator.getElement("home_miniapps_button");
        await expect(miniapps_button).toBeExisting();
        const miniappsButtonText = await ManageLocator.getElementText("home_miniapps_button");
        await expect(miniappsButtonText).toContain("Go to MiniApps");
    }

    public async clickLoginButton() {
        const login_button = await ManageLocator.getElement("home_login_button");
        await login_button.click(); 
    }

    public async clickMiniAppsButton() {
        const miniapps_button = await ManageLocator.getElement("home_miniapps_button");
        await miniapps_button.click(); 
    }

    public async clickProductButton() {
        const product_button = await ManageLocator.getElement("home_products_button");
        await product_button.click(); 
    }

    /**
     * overwrite specific options to adapt it to page object
     */
    public async openNativeApp() {
        return await super.openNativeApp();
    }
}

export default new HomePage();
