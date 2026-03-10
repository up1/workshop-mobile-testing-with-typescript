import { $ } from '@wdio/globals'
import Page from './page';
import ManageLocator from '../utils/locators';


class ProfilePage extends Page {

    public async verifyPageOnLoaded(fullname: string, email: string) {
        const title_text = await ManageLocator.getElement("profile_app_bar_title");
        await expect(title_text).toBeExisting();
        const titleTextValue = await ManageLocator.getElementText("profile_app_bar_title");
        await expect(titleTextValue).toContain("Profile");

        // Profile name text should be displayed and the text is correct
        const profileNameText = await ManageLocator.getElement("profile_name_text");
        await expect(profileNameText).toBeExisting();
        const profileNameTextValue = await ManageLocator.getElementText("profile_name_text");
        await expect(profileNameTextValue).toContain(fullname);

        // Profile email text should be displayed and the text is correct
        const profileEmailText = await ManageLocator.getElement("profile_email_text");
        await expect(profileEmailText).toBeExisting();
        const profileEmailTextValue = await ManageLocator.getElementText("profile_email_text");
        await expect(profileEmailTextValue).toContain(email);

        // Logout button should be displayed and the text is correct
        const logoutButton = await ManageLocator.getElement("profile_logout_button");
        await expect(logoutButton).toBeExisting();
        const logoutButtonText = await ManageLocator.getElementText("profile_logout_button");
        await expect(logoutButtonText).toContain("Logout");
    }   

    public async logout() {
        const logoutButton = await ManageLocator.getElement("profile_logout_button");
        await logoutButton.click();
    }
    
}

export default new ProfilePage();
