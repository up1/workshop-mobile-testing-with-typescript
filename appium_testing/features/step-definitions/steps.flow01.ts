import { Given, When, Then } from '@wdio/cucumber-framework';

import LoginPage from '../pageobjects/login.page';
import HomePage from '../pageobjects/home.page';
import ProfilePage from '../pageobjects/profile.page';

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

Then(/^I should see a profile page with (.*) and (.*)$/, async (fullname, email) => {
    await ProfilePage.verifyPageOnLoaded(fullname, email);
    await ProfilePage.logout();
});