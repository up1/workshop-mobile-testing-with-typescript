import Page from './page';
import ManageLocator from '../utils/locators';
import { expect } from '@wdio/globals';

class MiniAppFirstPage extends Page {
    public async tapLogoutButton() {
        const logoutButton = await ManageLocator.getElement("webview_logout_button");
        await logoutButton.click();
    }

    public async verifyMiniAppWebViewPageOnLoaded() {
        const welcomeMessage = ManageLocator.getElement("hello_message");
        await expect(welcomeMessage).toBeDisplayed(); 
    }

    public async sendMessageFromMiniApp(message: string) {
        const inputField = await ManageLocator.getElement("hello_message");
        await inputField.setValue(message);

        // Click the send button
        const sendButton = await ManageLocator.getElement("sent_button");
        await sendButton.click();
    }

    public async verifySnackbarMessageFromMiniApp(message: string) {
        // Verify the snackbar message
        const snackbar = await ManageLocator.getElement("webview_received_message");
        await expect(snackbar).toBeDisplayed();
        // Check text of the snackbar
        const snackbarText = await ManageLocator.getElementText("webview_received_message");
        expect(snackbarText).toBe(message);
    }

}

export default new MiniAppFirstPage();
