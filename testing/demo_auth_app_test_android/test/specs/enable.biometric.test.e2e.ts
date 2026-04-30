import AndroidSettings from "../utils/AndroidSettings.js";

it('Enable biometric login', async () => {
    await AndroidSettings.enableBiometricLogin();
});