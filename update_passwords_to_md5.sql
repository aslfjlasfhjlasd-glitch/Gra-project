-- ============================================
-- MD5密码加密 - 数据库密码更新脚本
-- 执行日期：2025-12-15
-- 说明：将所有账号的明文密码更新为MD5加密值
-- ============================================

-- 注意：执行前请备份数据库！
-- 备份命令：mysqldump -u root -p universityta > backup_before_md5.sql

USE universityta;

-- ============================================
-- 1. 更新学生表密码
-- ============================================
-- 将所有密码为 '123456' 的学生密码更新为MD5加密值
UPDATE xs_xxb 
SET xs_mm = 'e10adc3949ba59abbe56e057f20f883e' 
WHERE xs_mm = '123456';

-- 查看更新结果
SELECT COUNT(*) AS '学生表-已更新数量' FROM xs_xxb WHERE xs_mm = 'e10adc3949ba59abbe56e057f20f883e';

-- ============================================
-- 2. 更新管理员表密码
-- ============================================
-- 将所有密码为 '123456' 的管理员密码更新为MD5加密值
UPDATE gly_xxb 
SET gly_mm = 'e10adc3949ba59abbe56e057f20f883e' 
WHERE gly_mm = '123456';

-- 查看更新结果
SELECT COUNT(*) AS '管理员表-已更新数量' FROM gly_xxb WHERE gly_mm = 'e10adc3949ba59abbe56e057f20f883e';

-- ============================================
-- 3. 更新部门负责人表密码
-- ============================================
-- 将所有密码为 '123456' 的部门负责人密码更新为MD5加密值
UPDATE xjbmfzr_xxb 
SET xjbmfzr_mm = 'e10adc3949ba59abbe56e057f20f883e' 
WHERE xjbmfzr_mm = '123456';

-- 查看更新结果
SELECT COUNT(*) AS '部门负责人表-已更新数量' FROM xjbmfzr_xxb WHERE xjbmfzr_mm = 'e10adc3949ba59abbe56e057f20f883e';

-- ============================================
-- 4. 更新学院表密码
-- ============================================
-- 将所有密码为 '123456' 的学院密码更新为MD5加密值
UPDATE xy_xxb 
SET xy_mm = 'e10adc3949ba59abbe56e057f20f883e' 
WHERE xy_mm = '123456';

-- 查看更新结果
SELECT COUNT(*) AS '学院表-已更新数量' FROM xy_xxb WHERE xy_mm = 'e10adc3949ba59abbe56e057f20f883e';

-- ============================================
-- 5. 验证更新结果
-- ============================================
-- 查看所有表的密码字段，确认已加密
SELECT '学生表' AS 表名, xs_xh AS 账号, xs_xm AS 姓名, xs_mm AS 密码 FROM xs_xxb LIMIT 5;
SELECT '管理员表' AS 表名, gly_zh AS 账号, gly_xm AS 姓名, gly_mm AS 密码 FROM gly_xxb LIMIT 5;
SELECT '部门负责人表' AS 表名, xjbmfzr_zh AS 账号, xjbmfzr_xm AS 姓名, xjbmfzr_mm AS 密码 FROM xjbmfzr_xxb LIMIT 5;
SELECT '学院表' AS 表名, xy_dm AS 代码, xy_mc AS 名称, xy_mm AS 密码 FROM xy_xxb LIMIT 5;

-- ============================================
-- 6. 常用密码的MD5值参考
-- ============================================
-- 如果有其他密码需要更新，可以参考以下MD5值：
-- 
-- 明文密码 -> MD5加密值
-- 123456   -> e10adc3949ba59abbe56e057f20f883e
-- admin    -> 21232f297a57a5a743894a0e4a801fc3
-- password -> 5f4dcc3b5aa765d61d8327deb882cf99
-- 111111   -> 96e79218965eb72c92a549dd5a330112
-- 000000   -> 670b14728ad9902aecba32e22fa4f6bd
-- 
-- 如需更新其他密码，请使用以下格式：
-- UPDATE 表名 SET 密码字段 = 'MD5值' WHERE 密码字段 = '明文密码';

-- ============================================
-- 执行完成提示
-- ============================================
SELECT '✅ 密码更新完成！请重启后端服务并测试登录功能。' AS 提示;

-- ============================================
-- 回滚脚本（如果需要恢复）
-- ============================================
-- 如果需要回滚到明文密码，执行以下语句：
-- UPDATE xs_xxb SET xs_mm = '123456' WHERE xs_mm = 'e10adc3949ba59abbe56e057f20f883e';
-- UPDATE gly_xxb SET gly_mm = '123456' WHERE gly_mm = 'e10adc3949ba59abbe56e057f20f883e';
-- UPDATE xjbmfzr_xxb SET xjbmfzr_mm = '123456' WHERE xjbmfzr_mm = 'e10adc3949ba59abbe56e057f20f883e';
-- UPDATE xy_xxb SET xy_mm = '123456' WHERE xy_mm = 'e10adc3949ba59abbe56e057f20f883e';