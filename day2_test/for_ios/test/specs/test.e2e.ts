import { expect } from '@wdio/globals'
import HomePage from '../pageobjects/home.page'

describe('My Login application', () => {
    it('should login with valid credentials', async () => {
        await HomePage.pageLodedSuccess();
        await HomePage.openLoginPage();

        // Wait for the login screen to be displayed
        await driver.pause(3000);

        // await LoginPage.open()

        // await LoginPage.login('tomsmith', 'SuperSecretPassword!')
        // await expect(SecurePage.flashAlert).toBeExisting()
        // await expect(SecurePage.flashAlert).toHaveText(
        //     expect.stringContaining('You logged into a secure area!'))
    })
})

