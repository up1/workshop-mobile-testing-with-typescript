import ManageLocator from '../utils/locators';
import Page from './page';

class HomePage extends Page {
    private readonly LOCATORS = {
        welcomeText: 'home_welcome_text2',
        descriptionText: 'home_description_text2',
        loginButton: 'home_login_button',
        miniAppsButton: 'home_miniapps_button',
        productsButton: 'home_products_button',
    };

    public async verifyPageOnLoaded() {
        await this.verifyElementExists(
            this.LOCATORS.welcomeText,
            'Welcome to the App',
        );
        await this.verifyElementExists(
            this.LOCATORS.descriptionText,
            'Please login to continue',
        );
        await this.verifyElementExists(
            this.LOCATORS.loginButton,
            'Login',
        );
        await this.verifyElementExists(
            this.LOCATORS.miniAppsButton,
            'Go to MiniApps',
        );
    }

    public async clickLoginButton() {
        const element = await ManageLocator.getElement(
            this.LOCATORS.loginButton,
        );
        await element.click();
    }

    public async clickMiniAppsButton() {
        const element = await ManageLocator.getElement(
            this.LOCATORS.miniAppsButton,
        );
        await element.click();
    }

    public async clickProductButton() {
        const element = await ManageLocator.getElement(
            this.LOCATORS.productsButton,
        );
        await element.click();
    }

    public async openNativeApp() {
        return super.openNativeApp();
    }

    private async verifyElementExists(
        locator: string,
        expectedText: string,
    ): Promise<void> {
        const element = await ManageLocator.getElement(locator);
        await expect(element).toBeExisting();
        const text = await ManageLocator.getElementText(locator);
        await expect(text).toContain(expectedText);
    }
}

export default new HomePage();