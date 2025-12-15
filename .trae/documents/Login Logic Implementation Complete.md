I have successfully implemented the complete login logic as requested.

### **Implementation Summary**

#### **1. Backend Implementation (Spring Boot)**
-   **Entities**: Created `Student`, `DepartmentHead`, `Academy`, and `Admin` classes mapping to your database tables.
-   **Mappers**: Created MyBatis mapper interfaces with **parameterized SQL queries** to prevent injection.
    -   `StudentMapper`: Queries `t_xs` by `XS_XH`.
    -   `DepartmentHeadMapper`: Queries `t_xjbmfzr` by `XJBMFZR_ZH`.
    -   `AcademyMapper`: Queries `t_xy` by `XY_ZH`.
    -   `AdminMapper`: Queries `t_gly` by `GLY_ZH`.
-   **Service Layer (`AuthService`)**:
    -   **Student Login**: Validates ID and Password against `t_xs`.
    -   **Head Login**: Implemented **OR logic**. First checks `t_xjbmfzr` (Department Head), then `t_xy` (Academy Head).
    -   **Admin Login**: Validates Username and Password against `t_gly`.
    -   **Error Handling**: Returns specific error messages for "Account does not exist" or "Incorrect password".
-   **Controller (`AuthController`)**: Exposes `POST /api/auth/login` endpoint.
-   **Configuration**:
    -   Configured `application.properties` for MySQL connection and camelCase mapping.
    -   Added **CORS Configuration** to allow requests from your Vue frontend (`http://localhost:5173`, `http://localhost:5174`).

#### **2. Frontend Implementation (Vue.js)**
-   **API Client**: Created `src/api/auth.js` using `axios` to handle communication with the backend.
-   **Login Logic**: Updated `src/views/Login.vue` to:
    -   Capture user input.
    -   Call the login API with the selected role.
    -   Display **Success** or **Error** alerts based on the backend response.
    -   Includes a placeholder `// TODO: Redirect to dashboard` for future navigation.

#### **3. Verification**
I have tested the login API with your database data:
-   **Student Login**: Success with `2024104`.
-   **Head Login**: Success with `800001` (Dept Head).
-   **Admin Login**: Success with `GUOZHIXIE`.
-   **Error Cases**: Correctly returns error messages for invalid credentials.

The system is now ready for the next phase (dashboard implementation).