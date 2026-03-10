import Page from './page';
import ManageLocator from '../utils/locators';

class LoginPage extends Page {

    public async verifyPageOnLoaded() {
        const title_text = await ManageLocator.getElement("login_title_text2");
        await expect(title_text).toBeExisting();
        const titleTextValue = await ManageLocator.getElementText("login_title_text2");
        await expect(titleTextValue).toContain("Sign In");

        // Login button should be displayed and the text is correct
        const btnSubmit = await ManageLocator.getElement("login_submit_button2");
        await expect(btnSubmit).toBeExisting();
        const btnSubmitText = await ManageLocator.getElementText("login_submit_button2");
        await expect(btnSubmitText).toContain("Login");
    }

    public async login (username: string, password: string) {
        const inputUsername = await ManageLocator.getElement("login_username_field2");
        await inputUsername.click();
        await inputUsername.setValue(username);
        
        const inputPassword = await ManageLocator.getElement("login_password_field2");
        await inputPassword.click();
        await inputPassword.setValue(password);
        
        const btnSubmit = await ManageLocator.getElement("login_submit_button2");
        await btnSubmit.click();
    }
}

export default new LoginPage();
