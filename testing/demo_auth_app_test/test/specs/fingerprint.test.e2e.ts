import HomePage from '../pageobjects/home.page.js'
import AuthPage from '../pageobjects/auth.page.js'
import UserPage from '../pageobjects/user.page.js'

describe('Authentication with fingerprint', () => {
    it('Successfully logs in with fingerprint', async () => {
        await HomePage.verifyPageLoaded();
        await HomePage.clickFingerprint();
        await AuthPage.scanFingerprintWithSuccess();
        await UserPage.isSuccess();
    })
})