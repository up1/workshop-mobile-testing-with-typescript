# Flow of mobile application development

## 1. Workflow of page in UI
* Flow 1 :: Home page -> Login page with username and password -> Profile page -> Logout
* Flow 2 :: Home page -> Login page with username and password -> List of miniApps -> Open miniApp with webview -> Logout
* Flow 3 :: Home page -> Face scan check -> Profile page -> Logout

## 2. Flow 1 details and interact with API
* Home page -> Login page with username and password
    * User enters username and password, clicks on login button.
    * App sends login request to API with username and password.
    * API validates credentials, if valid, returns user data and authentication token.
    * App receives response, stores authentication token securely, and navigates to profile page.
* Profile page -> Logout
    * User clicks on logout button on profile page.
    * App clears stored authentication token and user data, then navigates back to home page.

## 3. Flow 2 details and interact with API
* Home page -> Login page with username and password
    * Same as Flow 1.
* Login page with username and password -> List of miniApps
    * After successful login, app navigates to list of miniApps page.
* List of miniApps -> Open miniApp with webview
    * User selects a miniApp from the list, app opens the selected miniApp in a webview.
    * MiniApp content is loaded from the web, and user can interact with it as needed.
* Open miniApp with webview -> Logout
    * User clicks on logout button within the miniApp or in the app's main navigation.
    * App clears stored authentication token and user data, then navigates back to home page.

## 4. Flow 3 details and interact with API
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

## 5. Flow 4 Show list of products and show product details
* Home page -> List of products
    * User clicks on products button on home page, which navigates to products list page.
    * App sends request to API to fetch list of products.
    * API returns a list of products with basic details (id,title,price,thumbnail).
      * https://dummyjson.com/products?limit=10&select=id,title,price,thumbnail
    * App displays the list of products to the user.
* List of products -> Show product details
    * User selects a product from the list, app navigates to product details page.
    * App sends request to API to fetch detailed information about the selected product using its id.
      * https://dummyjson.com/products/{id}?select=id,title,price,thumbnail
    * API returns detailed information about the product (id,title,price,thumbnail).
    * App displays the product details

## API Specifications
* Login API
    * Endpoint: POST /api/login
    * Request Body: { "username": "user123", "password": "pass123" }
    * Response: { "token": "auth_token", "user": { "id": 1, "name": "John Doe", "email": "john.doe@example.com" } } 
* MiniApp API (for fetching list of miniApps)
    * Endpoint: GET /api/miniapps
    * Request Headers: { "Authorization: "Bearer auth_token" }
    * Response: { "miniApps": [ { "id": 1, "name": "MiniApp 1", "url": "https://miniapp1.example.com" }, { "id": 2, "name": "MiniApp 2", "url": "https://miniapp2.example.com" } ] }
* Logout API (optional, if server-side session management is used)
    * Endpoint: POST /api/logout
    * Request Headers: { "Authorization: "Bearer auth_token" }
    * Response: { "message": "Logout successful" }
* Face Scan API
    * Endpoint: POST /api/face-scan
    * Request Body: { "faceData": "base64_encoded_face_data" }
    * Response: { "token": "auth_token", "user": { "id": 1, "name": "John Doe", "email": "john.doe@example.com" } } 