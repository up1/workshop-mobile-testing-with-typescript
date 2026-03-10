import { Given, When, Then } from '@wdio/cucumber-framework';
import { expect, $ } from '@wdio/globals'

import LoginPage from '../pageobjects/login.page';
import HomePage from '../pageobjects/home.page';
import ManageLocator from '../utils/locators';

const pages: Record<string, typeof LoginPage> = {
    login: LoginPage
}

Given(/^I am on the (\w+) page$/, async (page: string) => {
    console.log(`Opening ${page} page...`);
    driver = await HomePage.openNativeApp();
    await HomePage.verifyPageOnLoaded();
    await HomePage.clickLoginButton();
});

When(/^I login with (\w+) and (.+)$/, async (username, password) => {
    console.log(`Logging in with username: ${username} and password: ${password}`);
    await LoginPage.verifyPageOnLoaded();
    await LoginPage.login(username, password)
});

Then(/^I should see a flash message saying (.*)$/, async (message) => {
    // await expect(SecurePage.flashAlert).toBeExisting();
    // await expect(SecurePage.flashAlert).toHaveText(expect.stringContaining(message));
    const profileText = await ManageLocator.getElement("profile_name_text");
    await expect(profileText).toBeExisting();
    // await expect(profileText).toHaveText(expect.stringContaining(message));
});

