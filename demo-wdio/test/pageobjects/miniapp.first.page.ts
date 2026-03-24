import Page from './page';
import ManageLocator from '../utils/locators';
import { expect } from '@wdio/globals';

class MiniAppFirstPage extends Page {
    private readonly LOCATORS = {
        logoutButton: 'webview_logout_button',
        welcomeMessage: 'hello_message',
        inputField: 'hello_message',
        sendButton: 'sent_button',
        snackbar: 'webview_received_message',
    };

    public async tapLogoutButton() {
        const logoutButton = await ManageLocator.getElement(
            this.LOCATORS.logoutButton
        );
        await logoutButton.click();
    }

    public async verifyMiniAppWebViewPageOnLoaded() {
        const welcomeMessage = await ManageLocator.getElement(
            this.LOCATORS.welcomeMessage
        );
        await expect(welcomeMessage).toBeDisplayed();
    }

    public async sendMessageFromMiniApp(message: string) {
        const inputField = await ManageLocator.getElement(
            this.LOCATORS.inputField
        );
        await inputField.setValue(message);

        const sendButton = await ManageLocator.getElement(
            this.LOCATORS.sendButton
        );
        await sendButton.click();
    }

    public async verifySnackbarMessageFromMiniApp(message: string) {
        const snackbar = await ManageLocator.getElement(
            this.LOCATORS.snackbar
        );
        await expect(snackbar).toBeDisplayed();

        const snackbarText = await ManageLocator.getElementText(
            this.LOCATORS.snackbar
        );
        expect(snackbarText).toBe(message);
    }
}

export default new MiniAppFirstPage();