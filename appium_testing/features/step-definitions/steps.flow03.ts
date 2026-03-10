import { Then, When } from '@wdio/cucumber-framework';

import MiniAppListPage from '../pageobjects/miniapp.list.page';
import MiniAppFirstPage from '../pageobjects/miniapp.first';

When(/^I tap on the first miniApp$/, async () => {
    await MiniAppListPage.tapMiniApp("miniapp_name_1");
});

Then(/^I should see the miniApp webview page$/, async () => {
    // await MiniAppFirstPage.verifyMiniAppWebViewPageOnLoaded();
});

When(/^I send a (.*) from miniApp to Flutter$/, async (message: string) => {
    // await MiniAppFirstPage.sendMessageFromMiniApp(message);
});

Then(/^I should see a snackbar with the message from the miniApp$/, async () => {
    // await MiniAppFirstPage.verifySnackbarMessageFromMiniApp();
});
