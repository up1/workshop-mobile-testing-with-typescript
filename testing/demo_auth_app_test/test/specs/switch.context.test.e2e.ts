import HomePage from '../pageobjects/home.page.js'

describe('Switch Context', () => {
    it('Try to switch context from native to web', async () => {
        await HomePage.verifyPageLoaded();
        await HomePage.clickOpenBrowser();
        await HomePage.clickFingerprint();
    })
})