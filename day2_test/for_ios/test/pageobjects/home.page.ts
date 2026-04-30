import { $ } from '@wdio/globals'

class HomePage {

    private elements = {
        welcomeText: "accessibility id:home_welcome_text2",
        loginButton: "accessibility id:home_login_button",
    };

    public async pageLodedSuccess() {
        // Check if the welcome text is displayed
        const el1 = await $(this.elements.welcomeText);
        await expect(el1).toBeExisting();
        await expect(el1).toHaveText("Welcome to the App");
    }

    public async openLoginPage() {
        // Click on the login button
        const el3 = await $(this.elements.loginButton);
        await el3.click();
    }
}

export default new HomePage();
