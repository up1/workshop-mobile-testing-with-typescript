import Page from './page';
import ManageLocator from '../utils/locators';

class LoginPage extends Page {
    private readonly LOCATORS = {
        titleText: 'login_title_text2',
        submitButton: 'login_submit_button2',
        usernameField: 'login_username_field2',
        passwordField: 'login_password_field2',
    };

    public async verifyPageOnLoaded() {
        const titleText = await ManageLocator.getElement(
            this.LOCATORS.titleText
        );
        await expect(titleText).toBeExisting();

        const titleTextValue = await ManageLocator.getElementText(
            this.LOCATORS.titleText
        );
        await expect(titleTextValue).toContain('Sign In');

        const submitButton = await ManageLocator.getElement(
            this.LOCATORS.submitButton
        );
        await expect(submitButton).toBeExisting();

        const submitButtonText = await ManageLocator.getElementText(
            this.LOCATORS.submitButton
        );
        await expect(submitButtonText).toContain('Login');
    }

    public async login(username: string, password: string) {
        console.log(
            `Performing login with username: ${username} and password: ${password}`
        );

        const usernameInput = await ManageLocator.getElement(
            this.LOCATORS.usernameField
        );
        await usernameInput.click();
        await usernameInput.setValue(username);

        const passwordInput = await ManageLocator.getElement(
            this.LOCATORS.passwordField
        );
        await passwordInput.click();
        await passwordInput.setValue(password);

        const submitButton = await ManageLocator.getElement(
            this.LOCATORS.submitButton
        );
        await submitButton.click();
    }
}

export default new LoginPage();