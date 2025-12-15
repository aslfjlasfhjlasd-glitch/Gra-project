# MD5密码加密 - 快速启动指南 🚀

## 📋 执行步骤（按顺序）

### 步骤1️⃣：备份数据库（重要！）
```bash
# 在命令行执行
mysqldump -u root -p universityta > backup_before_md5.sql
```

### 步骤2️⃣：执行SQL更新脚本
```bash
# 方法1：使用命令行
mysql -u root -p universityta < update_passwords_to_md5.sql

# 方法2：使用Navicat或其他数据库工具
# 打开 update_passwords_to_md5.sql 文件
# 选中所有内容并执行
```

### 步骤3️⃣：重新编译后端项目
```bash
cd backend
mvn clean package
# 或者在IDEA中点击 Maven -> Lifecycle -> clean -> package
```

### 步骤4️⃣：重启后端服务
```bash
# 停止当前运行的服务（如果有）
# 然后重新启动
java -jar target/volunteer-0.0.1-SNAPSHOT.jar

# 或者在IDEA中重新运行 VolunteerApplication
```

### 步骤5️⃣：测试登录功能
1. 打开前端页面
2. 使用任意账号登录（密码：123456）
3. 应该能够成功登录

---

## ✅ 验证清单

- [ ] 数据库已备份
- [ ] SQL脚本执行成功
- [ ] 后端项目重新编译
- [ ] 后端服务已重启
- [ ] 学生登录测试通过
- [ ] 管理员登录测试通过
- [ ] 负责人登录测试通过
- [ ] 密码修改功能测试通过

---

## 🔍 快速验证

### 验证数据库密码已加密
```sql
-- 查看学生表密码（应该是32位MD5值）
SELECT xs_xh, xs_xm, xs_mm FROM xs_xxb LIMIT 3;

-- 正确示例：
-- xs_mm = 'e10adc3949ba59abbe56e057f20f883e'
```

### 验证登录功能
1. 账号：任意学号（如：2021001）
2. 密码：123456（明文）
3. 角色：学生
4. 点击登录 → 应该成功

---

## 🎯 核心改动文件

### 新增文件
✅ `backend/src/main/java/com/university/volunteer/utils/MD5Util.java`

### 修改文件
✅ `backend/src/main/java/com/university/volunteer/service/AuthService.java`
✅ `backend/src/main/java/com/university/volunteer/service/StudentService.java`

### 辅助文件
📄 `MD5加密实施总结.md` - 详细说明文档
📄 `update_passwords_to_md5.sql` - 数据库更新脚本
📄 `MD5加密-快速启动指南.md` - 本文件

---

## 🎓 答辩演示要点

### 演示1：展示MD5加密效果
```java
// 运行 MD5Util 的 main 方法
System.out.println(MD5Util.encrypt("123456"));
// 输出：e10adc3949ba59abbe56e057f20f883e
```

### 演示2：对比数据库
**修改前：**
```
密码字段：123456（明文，不安全）
```

**修改后：**
```
密码字段：e10adc3949ba59abbe56e057f20f883e（密文，安全）
```

### 演示3：登录流程说明
1. 用户输入明文密码：`123456`
2. 系统自动加密：`MD5Util.encrypt("123456")`
3. 得到密文：`e10adc3949ba59abbe56e057f20f883e`
4. 与数据库密文比对
5. 匹配成功则登录

---

## ⚠️ 常见问题

### Q1: 执行SQL后无法登录？
**A:** 检查数据库密码是否已更新为MD5值，执行以下SQL验证：
```sql
SELECT xs_mm FROM xs_xxb LIMIT 1;
-- 应该显示：e10adc3949ba59abbe56e057f20f883e
```

### Q2: 后端报错找不到MD5Util类？
**A:** 确保已重新编译项目：
```bash
cd backend
mvn clean compile
```

### Q3: 新创建的账号无法登录？
**A:** 检查StudentService.java中的createStudent方法是否已添加MD5加密：
```java
student.setXsMm(MD5Util.encrypt(password));
```

### Q4: 如何回滚到明文密码？
**A:** 执行以下SQL（不推荐）：
```sql
UPDATE xs_xxb SET xs_mm = '123456' WHERE xs_mm = 'e10adc3949ba59abbe56e057f20f883e';
```

---

## 📞 技术支持

如遇问题，请检查：
1. ✅ 数据库密码是否已更新
2. ✅ 后端服务是否已重启
3. ✅ MD5Util类是否正确创建
4. ✅ import语句是否正确添加

---

## 🎉 完成标志

当以下所有项都完成时，MD5加密功能即部署成功：

- [x] MD5工具类创建完成
- [x] 登录逻辑修改完成
- [x] 密码存储逻辑修改完成
- [ ] 数据库密码已更新（需手动执行）
- [ ] 后端服务已重启（需手动执行）
- [ ] 登录功能测试通过（需手动测试）

---

**祝部署顺利！如有问题请参考《MD5加密实施总结.md》获取详细信息。** 🎓✨