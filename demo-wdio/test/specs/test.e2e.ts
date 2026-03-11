import HomePage from '../pageobjects/home.page';
import LoginPage from '../pageobjects/login.page';
import MiniAppListPage from '../pageobjects/miniapp.list.page';
import MiniAppFirstPage from '../pageobjects/miniapp.first.page';


describe('Flow 01 :: Working with miniApp', () => {
    it('User shoukd open first miniApp', async () => {
        await HomePage.verifyPageOnLoaded();
        await HomePage.clickMiniAppsButton();
        await LoginPage.verifyPageOnLoaded();
        await LoginPage.login("user123", "pass123");
        await MiniAppListPage.verifyPageOnLoaded();
        await MiniAppListPage.tapMiniApp("miniapp_name_1");
        await MiniAppFirstPage.verifyMiniAppWebViewPageOnLoaded();
        await MiniAppFirstPage.sendMessageFromMiniApp("Hello");
        await MiniAppFirstPage.verifySnackbarMessageFromMiniApp("Hello");
    })
})

