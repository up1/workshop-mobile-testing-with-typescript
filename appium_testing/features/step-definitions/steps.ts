import { Given, When, Then } from '@wdio/cucumber-framework';
import { expect, $ } from '@wdio/globals'

import LoginPage from '../pageobjects/login.page';
import SecurePage from '../pageobjects/secure.page';

const pages: Record<string, typeof LoginPage> = {
    login: LoginPage
}

Given(/^I am on the (\w+) page$/, async (page: string) => {
    console.log(`Opening ${page} page...`);
    driver = await pages[page].openNativeApp();

    // Check welcome message is displayed and the text is correct
    const welcome_text = await driver.$("accessibility id:home_welcome_text2");
    await expect(welcome_text).toBeExisting();
    const welcomeTextValue = await welcome_text.getText();
    await expect(welcomeTextValue).toContain("Welcome to the App");

    // Check login button is displayed and the text is correct
    const login_button = await driver.$("accessibility id:home_login_button");
    await expect(login_button).toBeExisting();
    const loginButtonText = await login_button.getValue();
    await expect(loginButtonText).toContain("Login");
    
    // Click login button to navigate to login page
    await login_button.click();

});

When(/^I login with (\w+) and (.+)$/, async (username, password) => {
    console.log(`Logging in with username: ${username} and password: ${password}`);
    await LoginPage.login(username, password)
});

Then(/^I should see a flash message saying (.*)$/, async (message) => {
    // await expect(SecurePage.flashAlert).toBeExisting();
    // await expect(SecurePage.flashAlert).toHaveText(expect.stringContaining(message));
    const profileText = await driver.$("accessibility id:profile_name_text");
    await expect(profileText).toBeExisting();
    // await expect(profileText).toHaveText(expect.stringContaining(message));
});

