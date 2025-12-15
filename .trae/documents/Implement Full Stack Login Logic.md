I have gathered the necessary requirements and technical details. I will now proceed to implement the complete login logic for all three roles (Student, College/Dept Head, Administrator) using Spring Boot and Vue.js.

### **Implementation Plan**

#### **Phase 1: Backend Implementation (Spring Boot)**
1.  **Configuration**:
    *   Enable `map-underscore-to-camel-case` in `application.properties` to automatically map DB columns (e.g., `XS_XH`) to Java fields (e.g., `xsXh` or `studentId`).
    *   Configure global CORS support to allow requests from the frontend (`http://localhost:5173`, `http://localhost:5174`).

2.  **Data Layer (MyBatis Mappers & Entities)**:
    *   Create **Entity Classes** in `com.university.volunteer.entity`:
        *   `Student` (maps to `t_xs`)
        *   `DepartmentHead` (maps to `t_xjbmfzr`)
        *   `Academy` (maps to `t_xy`)
        *   `Admin` (maps to `t_gly`)
    *   Create **Mapper Interfaces** in `com.university.volunteer.mapper`:
        *   `StudentMapper`: Find by `XS_XH`.
        *   `DepartmentHeadMapper`: Find by `XJBMFZR_ZH`.
        *   `AcademyMapper`: Find by `XY_ZH`.
        *   `AdminMapper`: Find by `GLY_ZH`.

3.  **Service Layer (Business Logic)**:
    *   Create `AuthService` in `com.university.volunteer.service`.
    *   Implement `login(LoginRequest)` method with the specific logic:
        *   **Student**: Exact match on ID and Password.
        *   **Head**: Check `DepartmentHead` table first; if not found, check `Academy` table. (OR Logic).
        *   **Admin**: Exact match on Username and Password.
    *   Handle exceptions: `UserNotFoundException`, `InvalidPasswordException`.

4.  **Controller Layer (API)**:
    *   Create `AuthController` in `com.university.volunteer.controller`.
    *   Endpoint: `POST /api/auth/login`.
    *   Return standard `Result<T>` object (Success/Fail status, Message, Data).

#### **Phase 2: Frontend Implementation (Vue.js)**
1.  **API Client**:
    *   Install `axios` for HTTP requests.
    *   Create `src/api/auth.js` to encapsulate login API calls.

2.  **Login Page Logic**:
    *   Update `src/views/Login.vue`:
        *   Bind form inputs to state.
        *   Implement `handleLogin` function to call the backend API.
        *   Show success/error messages using `window.alert` or a simple UI banner (since toast component isn't installed yet, I'll use a clean in-page error message).

#### **Phase 3: Testing & Verification**
1.  Start Backend Application.
2.  Start Frontend Application.
3.  Test Login Scenarios:
    *   **Student**: Valid/Invalid credentials.
    *   **Head**: Valid Dept Head, Valid Academy Head, Invalid credentials.
    *   **Admin**: Valid/Invalid credentials.

I am ready to execute this plan.