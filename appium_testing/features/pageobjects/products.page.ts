import ManageLocator from '../utils/locators';
import Page from './page';
import { expect } from '@wdio/globals';

class ProductsPage extends Page {

    public async verifyPageOnLoaded() {

    }

    public async scrollToLastProduct() {
        const product_list = driver.$(`class name:XCUIElementTypeScrollView`);
        // await product_list.scrollIntoView(false); // Scroll to the last product in the list
        
        product_list.scrollIntoView({
            direction: 'up',
            maxScrolls: 10
        })

        // Scroll to element with text "Moisturizing Cream"
        const last_product = ManageLocator.getElement("product_title_10");
        await last_product.waitForDisplayed({ timeout: 5000 });
        expect(await last_product.isDisplayed()).toBe(true);
    }

    public async clickLastProduct() {
        const last_product = ManageLocator.getElement("product_title_10");
        await last_product.click();

        // Delay for 2 seconds to wait for the product detail page to load
        await driver.pause(2000);
    }

}

export default new ProductsPage();
