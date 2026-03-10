import Page from './page';
import ManageLocator from '../utils/locators';
import { expect } from '@wdio/globals';

class MiniAppListPage extends Page {

    public async verifyPageOnLoaded() {
        const title_text = await ManageLocator.getElement("miniapps_app_bar_title");
        await expect(title_text).toBeExisting();
        const titleTextValue = await ManageLocator.getElementText("miniapps_app_bar_title");
        await expect(titleTextValue).toContain("MiniApps");

        // Verify miniApp list is displayed
        const miniAppList = await ManageLocator.getElementList("miniapp_list");
        await expect(miniAppList.length).toBeGreaterThan(0);

        // Verify there are 2 miniApps in the list
        const miniAppItems = await ManageLocator.getElementList("miniapp_list");
        await expect(miniAppItems.length).toEqual(2);
    }   

    public async logout() {
        const logoutButton = await ManageLocator.getElement("miniapps_logout_button");
        await logoutButton.click();
    }
    
}

export default new MiniAppListPage();
