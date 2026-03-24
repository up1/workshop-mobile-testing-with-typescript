import Page from './page';
import ManageLocator from '../utils/locators';
import { expect } from '@wdio/globals';

class MiniAppListPage extends Page {
    private readonly LOCATORS = {
        appBarTitle: 'miniapps_app_bar_title',
        miniAppList: 'miniapp_list',
        logoutButton: 'miniapps_logout_button',
    };

    public async verifyPageOnLoaded() {
        const title_text = await ManageLocator.getElement(this.LOCATORS.appBarTitle);
        await expect(title_text).toBeExisting();
        const titleTextValue = await ManageLocator.getElementText(this.LOCATORS.appBarTitle);
        await expect(titleTextValue).toContain("MiniApps");

        // Wait 400ms for the miniApp list to load
        // Bad practice to use fixed wait, but we can use it here for simplicity. In real test, we should use dynamic wait instead.
        await driver.pause(400);

        // Best practice: Verify miniApp list is displayed and has 2 miniApps in the list using dynamic wait
        await driver.waitUntil(async () => {
            const miniAppList = await ManageLocator.getElementList(this.LOCATORS.miniAppList);
            return await miniAppList.length > 0;
        }, {
            timeout: 1000,
            timeoutMsg: 'Expected miniApp list to be displayed after 1s'
        });

        // Verify there are 2 miniApps in the list
        const miniAppItems = await ManageLocator.getElementList(this.LOCATORS.miniAppList);
        await expect(miniAppItems.length).toEqual(2);
    }   

    public async logout() {
        const logoutButton = await ManageLocator.getElement(this.LOCATORS.logoutButton);
        await logoutButton.click();
    }

    public async tapMiniApp(locator: string) {
        const miniApp = await ManageLocator.getElement(locator);
        await miniApp.click();
    }
    
}

export default new MiniAppListPage();