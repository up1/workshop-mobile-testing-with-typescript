import { Given, Then } from '@wdio/cucumber-framework';

import HomePage from '../pageobjects/home.page';
import MiniAppListPage from '../pageobjects/miniapp.list.page';


Given(/^I am on the login page to use miniApp$/, async () => {
    console.log(`Opening login page to use miniApp...`);
    driver = await HomePage.openNativeApp();
    await HomePage.verifyPageOnLoaded();
    await HomePage.clickMiniAppsButton();
});

Then(/^I should see a miniApp list page$/, async () => {
    await MiniAppListPage.verifyPageOnLoaded();
    await MiniAppListPage.logout();
});