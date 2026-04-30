# Flow of mobile application development
* Authentication with fingerprint and face scan
* Fluter 
  * local_auth package for fingerprint and face scan authentication
    * https://pub.dev/packages/local_auth
  * Use secure storage to store authentication token securely
    * https://pub.dev/packages/flutter_secure_storage

## Flow 1
* Home page  to show Authentication with 
  * Fingerprint flow
  * Face scan flow

* Fingerprint authentication flow
  * User clicks on fingerprint authentication button on home page.
  * App accesses device's fingerprint sensor to authenticate the user.
  * If authentication is successful, app navigates to profile page.
  * If authentication fails, app shows an error message and remains on home page.

* Face scan authentication flow
  * User clicks on face scan authentication button on home page.
  * App accesses device's front camera to scan the user's face.
  * If authentication is successful, app navigates to profile page.
  * If authentication fails, app shows an error message and remains on home page.


With authentication process, try to mock result to show the flow of the application without needing actual biometric authentication during development. This can be done by creating a mock authentication service that simulates the behavior of the local_auth package.
* After scan fingerprint or face, instead of calling the actual authentication method, call the mock authentication service which will return a success or failure response based on predefined conditions (e.g., a random boolean value or a specific input).
* This allows you to test the navigation and error handling flows of your application without relying on the actual biometric hardware, making development and testing easier.