import HomePage from '../pageobjects/home.page.js'
import AuthPage from '../pageobjects/auth.page.js'
import UserPage from '../pageobjects/user.page.js'

describe('Authentication with face scan', () => {
    it('Successfully logs in with face scan', async () => {
        await HomePage.verifyPageLoaded();
        await HomePage.clickFaceScan();
        await AuthPage.scanFaceScanWithSuccess();
        await UserPage.isSuccess();
    })
})