I will build the **University Volunteer Activity Smart Management Platform** with a Spring Boot backend and Vue.js frontend, focusing first on the **Login Page** as requested.

### **Project Structure**
I will create two main directories in `Graduation Project test-1`:
- `backend`: Spring Boot + MyBatis (Java 17)
- `frontend`: Vue.js + Tailwind CSS + shadcn-vue

### **Step 1: Backend Initialization (Spring Boot)**
1.  Create a standard Spring Boot project structure.
2.  Configure `pom.xml` with dependencies:
    -   `spring-boot-starter-web`
    -   `mybatis-spring-boot-starter`
    -   `mysql-connector-j`
3.  Configure `application.properties` with your MySQL credentials (`root` / `240910132201Cyh`).

### **Step 2: Frontend Initialization (Vue.js)**
1.  Initialize a Vue 3 project using Vite.
2.  Install and configure **Tailwind CSS**.
3.  Initialize **shadcn-vue** to bring in the requested UI components.
4.  I will use the `context7` tool to reference any specific library documentation if needed.
5.  I will use the `shadcn-ui` MCP tool to identify the component structures (Button, Input, Checkbox) to ensure standard naming and design.

### **Step 3: Login Page Implementation**
I will create `src/views/Login.vue` with the following design (simulating the "Figma" design requirement via code):
-   **Theme**: Clean, academic aesthetic (Blue/White/Gray).
-   **Layout**:
    -   **Title**: "高校志愿活动智能管理平台" (University Volunteer Activity Smart Management Platform).
    -   **Form**:
        -   Username Input.
        -   Password Input.
        -   "Remember Me" Checkbox.
    -   **Buttons** (Grid Layout):
        -   Row 1: [Student] [College/Dept Head] (Equal width).
        -   Row 2: [Administrator] (Full width).

### **Step 4: Testing & Verification**
1.  Start the Vue development server.
2.  **Call Chrome DevTools MCP**: I will launch a browser instance to load the page and verify the layout and elements match your requirements.

I am ready to execute this plan.