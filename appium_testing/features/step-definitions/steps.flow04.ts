import { Given, Then, When } from '@wdio/cucumber-framework';

import HomePage from '../pageobjects/home.page';
import ProductPage from '../pageobjects/products.page';

Given(/^I am on the product list page$/, async () => {
    await HomePage.clickProductButton();
});

When(/^I scroll down to the last of the product list page$/, async () => {
    await ProductPage.scrollToLastProduct();
});

Then(/^I tap on the last product in the list$/, async () => {
    await ProductPage.clickLastProduct();
});

Then(/^I should see a product detail page$/, async () => {
    
});

