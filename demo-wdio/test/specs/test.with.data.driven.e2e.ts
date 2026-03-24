import HomePage from '../pageobjects/home.page';
import LoginPage from '../pageobjects/login.page';
import MiniAppListPage from '../pageobjects/miniapp.list.page';
import MiniAppFirstPage from '../pageobjects/miniapp.first.page';

// The data set (input and expected output)
const testData = [
    { username: "user123", password: "pass123", miniAppName: "miniapp_name_1", message: "Hello" },
    { username: "user456", password: "pass456", miniAppName: "miniapp_name_2", message: "Hi there" },
    { username: "user789", password: "pass789", miniAppName: "miniapp_name_3", message: "Good morning" }
];


describe('Flow 01 :: Working with miniApp', () => {
    // Loop through each data set and run the test
    testData.forEach(({ username, password, miniAppName, message }) => {
        it(`User should open ${miniAppName} and send message: ${message}`, async () => {
            await HomePage.verifyPageOnLoaded();
            await HomePage.clickMiniAppsButton();
            await LoginPage.verifyPageOnLoaded();
            await LoginPage.login(username, password);
            await MiniAppListPage.verifyPageOnLoaded();
            await MiniAppListPage.tapMiniApp(miniAppName);
            await MiniAppFirstPage.verifyMiniAppWebViewPageOnLoaded();
            await MiniAppFirstPage.sendMessageFromMiniApp(message);
            await MiniAppFirstPage.verifySnackbarMessageFromMiniApp(message);
        });
    });
})

