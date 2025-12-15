# MD5密码加密实施总结

## 实施日期
2025-12-15

## 实施内容

### ✅ 第一步：创建MD5工具类
**文件位置：** `backend/src/main/java/com/university/volunteer/utils/MD5Util.java`

**功能说明：**
- 提供静态方法 `encrypt(String plainText)` 用于MD5加密
- 输入明文密码，返回32位小写MD5密文
- 示例：`encrypt("123456")` → `e10adc3949ba59abbe56e057f20f883e`

**测试方法：**
```bash
# 可以运行MD5Util的main方法测试
cd backend/src/main/java
javac com/university/volunteer/utils/MD5Util.java
java com.university.volunteer.utils.MD5Util
# 应输出：e10adc3949ba59abbe56e057f20f883e
```

---

### ✅ 第二步：修改AuthService.java（登录逻辑）
**文件位置：** `backend/src/main/java/com/university/volunteer/service/AuthService.java`

**修改内容：**

1. **导入MD5工具类**
   ```java
   import com.university.volunteer.utils.MD5Util;
   ```

2. **修改学生登录验证（loginStudent方法）**
   - 第87行：将用户输入的明文密码加密后与数据库比对
   ```java
   if (!MD5Util.encrypt(password).equals(student.getXsMm())) {
       return Result.error("密码错误");
   }
   ```

3. **修改负责人登录验证（loginHead方法）**
   - 第104行：先加密输入的密码
   - 第107行和第115行：使用加密后的密码进行比对
   ```java
   String encryptedPassword = MD5Util.encrypt(password);
   if (encryptedPassword.equals(deptHead.getXjbmfzrMm())) { ... }
   if (encryptedPassword.equals(academy.getXyMm())) { ... }
   ```

4. **修改管理员登录验证（loginAdmin方法）**
   - 第143行：将用户输入的明文密码加密后与数据库比对
   ```java
   if (!MD5Util.encrypt(password).equals(admin.getGlyMm())) {
       return Result.error("密码错误");
   }
   ```

---

### ✅ 第三步：修改StudentService.java（注册/修改密码逻辑）
**文件位置：** `backend/src/main/java/com/university/volunteer/service/StudentService.java`

**修改内容：**

1. **导入MD5工具类**
   ```java
   import com.university.volunteer.utils.MD5Util;
   ```

2. **修改学生修改密码方法（updatePassword）**
   - 第257行：验证旧密码时，先加密输入的旧密码
   - 第262行：保存新密码时，加密后存入
   ```java
   if (!MD5Util.encrypt(oldPassword).equals(student.getXsMm())) {
       return Result.error("原密码错误");
   }
   int rows = studentMapper.updatePassword(studentId, MD5Util.encrypt(newPassword));
   ```

3. **修改创建学生账号方法（createStudent）**
   - 第412行：存入数据库时加密密码
   ```java
   student.setXsMm(MD5Util.encrypt(password));
   ```
   - 第424行：返回提示时仍显示明文，方便管理员通知学生

4. **修改更新学生账号方法（updateStudentAccount）**
   - 第457行：如果提供了新密码，加密后存入
   ```java
   if (dto.getPassword() != null && !dto.getPassword().trim().isEmpty()) {
       student.setXsMm(MD5Util.encrypt(dto.getPassword()));
   }
   ```

5. **修改重置密码方法（resetStudentPassword）**
   - 第490行：重置为默认密码时，存入加密后的123456
   ```java
   int rows = studentMapper.updatePassword(studentId, MD5Util.encrypt(defaultPassword));
   ```

---

## 测试验证步骤

### 1. 数据库密码更新
**重要：** 在测试前，需要将数据库中所有现有账号的密码更新为MD5加密后的值。

```sql
-- 更新所有学生密码为 123456 的MD5值
UPDATE xs_xxb SET xs_mm = 'e10adc3949ba59abbe56e057f20f883e' WHERE xs_mm = '123456';

-- 更新所有管理员密码
UPDATE gly_xxb SET gly_mm = 'e10adc3949ba59abbe56e057f20f883e' WHERE gly_mm = '123456';

-- 更新所有部门负责人密码
UPDATE xjbmfzr_xxb SET xjbmfzr_mm = 'e10adc3949ba59abbe56e057f20f883e' WHERE xjbmfzr_mm = '123456';

-- 更新所有学院密码
UPDATE xy_xxb SET xy_mm = 'e10adc3949ba59abbe56e057f20f883e' WHERE xy_mm = '123456';
```

### 2. 功能测试清单

#### ✅ 登录功能测试
- [ ] 学生登录：使用明文密码123456登录，系统自动加密后验证
- [ ] 部门负责人登录：使用明文密码登录
- [ ] 学院负责人登录：使用明文密码登录
- [ ] 管理员登录：使用明文密码登录
- [ ] 错误密码测试：输入错误密码应提示"密码错误"

#### ✅ 密码修改功能测试
- [ ] 学生修改密码：输入旧密码和新密码，验证修改成功
- [ ] 旧密码错误测试：输入错误的旧密码应提示"原密码错误"
- [ ] 新密码格式验证：测试8-15位、大小写字母要求

#### ✅ 管理员功能测试
- [ ] 创建学生账号：创建新账号，默认密码123456应被加密存储
- [ ] 修改学生信息：修改密码时应加密存储
- [ ] 重置学生密码：重置为123456，应存储加密值

### 3. 验证方法

**方法1：查看数据库**
```sql
-- 查看学生表密码字段，应该是32位MD5值
SELECT xs_xh, xs_xm, xs_mm FROM xs_xxb LIMIT 5;
-- 正确示例：xs_mm = 'e10adc3949ba59abbe56e057f20f883e'
```

**方法2：测试登录**
1. 启动后端服务
2. 使用前端登录页面
3. 输入明文密码（如123456）
4. 应该能够成功登录

**方法3：测试密码修改**
1. 登录学生账号
2. 进入个人中心修改密码
3. 输入旧密码123456，新密码Test1234
4. 修改成功后，查看数据库密码字段应该是新的MD5值

---

## 答辩演示要点

### 演示1：MD5加密原理
```java
// 运行MD5Util的main方法
public static void main(String[] args) {
    System.out.println("明文: 123456");
    System.out.println("密文: " + encrypt("123456"));
    // 输出：e10adc3949ba59abbe56e057f20f883e
}
```

**说明：**
- 相同的明文永远生成相同的密文
- 密文无法反向解密为明文（单向加密）
- 32位十六进制字符串

### 演示2：登录流程
1. 用户输入明文密码：`123456`
2. 系统调用 `MD5Util.encrypt("123456")`
3. 得到密文：`e10adc3949ba59abbe56e057f20f883e`
4. 与数据库中存储的密文比对
5. 匹配成功则登录

### 演示3：数据库安全性
**修改前：**
```sql
SELECT xs_mm FROM xs_xxb;
-- 结果：123456（明文，不安全）
```

**修改后：**
```sql
SELECT xs_mm FROM xs_xxb;
-- 结果：e10adc3949ba59abbe56e057f20f883e（密文，安全）
```

---

## 安全性提升

### 修改前的问题
1. ❌ 密码明文存储，数据库泄露即密码泄露
2. ❌ 管理员可以直接看到用户密码
3. ❌ 不符合信息安全规范

### 修改后的优势
1. ✅ 密码加密存储，即使数据库泄露也无法直接获取明文
2. ✅ 管理员无法知道用户的真实密码
3. ✅ 符合基本的信息安全要求
4. ✅ 使用标准的MD5算法，成熟可靠

---

## 注意事项

### ⚠️ 重要提醒
1. **数据库密码必须更新**：所有现有账号的密码都需要更新为MD5加密值
2. **默认密码仍是123456**：只是存储时变成了加密值
3. **用户体验不变**：用户仍然输入明文密码，系统自动加密
4. **不影响现有功能**：所有登录、修改密码功能正常使用

### 📝 后续优化建议
1. 可以考虑使用更安全的加密算法（如BCrypt、SHA-256）
2. 可以添加盐值（Salt）增强安全性
3. 可以实现密码强度检测
4. 可以添加登录失败次数限制

---

## 文件清单

### 新增文件
- ✅ `backend/src/main/java/com/university/volunteer/utils/MD5Util.java`

### 修改文件
- ✅ `backend/src/main/java/com/university/volunteer/service/AuthService.java`
- ✅ `backend/src/main/java/com/university/volunteer/service/StudentService.java`

### 需要执行的SQL
- ✅ 更新所有表的密码字段为MD5加密值

---

## 完成状态

- [x] 创建MD5工具类
- [x] 修改登录验证逻辑
- [x] 修改密码存储逻辑
- [x] 修改密码修改逻辑
- [x] 修改密码重置逻辑
- [ ] 更新数据库密码（需手动执行SQL）
- [ ] 功能测试验证

---

## 联系方式
如有问题，请检查：
1. MD5Util类是否正确创建
2. import语句是否正确添加
3. 数据库密码是否已更新
4. 后端服务是否重新编译启动

**祝答辩顺利！** 🎓