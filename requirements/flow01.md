# Flow of mobile application development

## 1. Workflow of page in UI
* Flow 1 :: Home page -> Login page with username and password -> Profile page -> Logout
* Flow 2 :: Home page -> Face scan check -> Profile page -> Logout

## 2. Flow 1 details and interact with API
* Home page -> Login page with username and password
    * User clicks on login button on home page, which navigates to login page.
* Login page with username and password -> Profile page
    * User enters username and password, clicks on login button.
    * App sends login request to API with username and password.
    * API validates credentials, if valid, returns user data and authentication token.
    * App receives response, stores authentication token securely, and navigates to profile page.
* Profile page -> Logout
    * User clicks on logout button on profile page.
    * App clears stored authentication token and user data, then navigates back to home page.

## 3. Flow 2 details and interact with API
* Home page -> Face scan check
    * User clicks on face scan button on home page, which initiates face scan process.
* Face scan check -> Profile page
    * App accesses device camera to capture user's face.
    * App sends captured face data to API for verification.
    * API processes face data, if verification is successful, returns user data and authentication token.
    * App receives response, stores authentication token securely, and navigates to profile page.
* Profile page -> Logout
    * User clicks on logout button on profile page.
    * App clears stored authentication token and user data, then navigates back to home page.

## API Specifications
* Login API
    * Endpoint: POST /api/login
    * Request Body: { "username": "user123", "password": "pass123" }
    * Response: { "token": "auth_token", "user": { "id": 1, "name": "John Doe", "email": "john.doe@example.com" } } 
* Face Scan API
    * Endpoint: POST /api/face-scan
    * Request Body: { "faceData": "base64_encoded_face_data" }
    * Response: { "token": "auth_token", "user": { "id": 1, "name": "John Doe", "email": "john.doe@example.com" } } 
* Logout API (optional, if server-side session management is used)
    * Endpoint: POST /api/logout
    * Request Headers: { "Authorization: "Bearer auth_token" }
    * Response: { "message": "Logout successful" }
