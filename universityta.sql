/*
 Navicat Premium Data Transfer

 Source Server         : MySQL_cyh
 Source Server Type    : MySQL
 Source Server Version : 90500 (9.5.0)
 Source Host           : localhost:3306
 Source Schema         : universityta

 Target Server Type    : MySQL
 Target Server Version : 90500 (9.5.0)
 File Encoding         : 65001

 Date: 15/12/2025 18:10:21
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键名 (唯一标识)',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置键值 (可以是文本、数字或JSON)',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置中文名称 (用于前端显示)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述说明',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统全局配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, 'dashboard_title', '高校志愿活动智能大数据平台', '大屏主标题', '大屏顶部显示的系统名称', '2025-12-13 13:08:11');
INSERT INTO `sys_config` VALUES (2, 'dashboard_notice', '欢迎各位领导莅临指导，本学期志愿活动火热进行中！', '大屏滚动公告', '大屏顶部的跑马灯文字', '2025-12-13 13:08:11');
INSERT INTO `sys_config` VALUES (3, 'goal_total_hours', '5000', '学期目标工时', '用于展示仪表盘进度的分母值', '2025-12-13 13:08:11');
INSERT INTO `sys_config` VALUES (4, 'show_academy_rank', 'true', '显示学院排名', '控制是否显示学院活跃度排行 (true/false)', '2025-12-13 13:08:11');
INSERT INTO `sys_config` VALUES (5, 'show_gender_ratio', 'true', '显示男女比例图', '控制是否显示学生性别分布饼图 (true/false)', '2025-12-13 13:08:11');

-- ----------------------------
-- Table structure for t_bj
-- ----------------------------
DROP TABLE IF EXISTS `t_bj`;
CREATE TABLE `t_bj`  (
  `BJ_BH` int NOT NULL COMMENT '班级编号',
  `BJ_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '班级名称',
  `ZY_BH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '(所属)专业编号',
  `SSNJ` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属年级',
  `SSXY` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院',
  PRIMARY KEY (`BJ_BH`) USING BTREE,
  INDEX `FK_BJ_ZY`(`ZY_BH` ASC) USING BTREE,
  CONSTRAINT `FK_BJ_ZY` FOREIGN KEY (`ZY_BH`) REFERENCES `t_zy` (`ZY_BH`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学校班级表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_bj
-- ----------------------------
INSERT INTO `t_bj` VALUES (1, '24级英语1班', '01', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (2, '25级英语2班', '01', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (3, '24级商务英语1班', '02', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (4, '25级商务英语2班', '02', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (5, '24级翻译1班', '03', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (6, '25级翻译2班', '03', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (7, '24级西班牙语1班', '04', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (8, '25级西班牙语2班', '04', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (9, '24级法语1班', '05', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (10, '25级法语2班', '05', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (11, '24级意大利语1班', '06', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (12, '25级意大利语2班', '06', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (13, '24级葡萄牙语1班', '07', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (14, '25级葡萄牙语2班', '07', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (15, '24级俄语德语1班', '08', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (16, '25级俄语德语2班', '08', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (17, '24级捷克语1班', '09', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (18, '25级捷克语2班', '09', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (19, '24级波兰语1班', '10', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (20, '25级波兰语2班', '10', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (21, '24级汉语言1班', '11', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (22, '25级汉语言2班', '11', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (23, '24级国际经济与贸易1班', '12', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (24, '25级国际经济与贸易2班', '12', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (25, '24级国际商务1班', '13', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (26, '25级国际商务2班', '13', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (27, '24级金融工程1班', '14', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (28, '25级金融工程2班', '14', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (29, '24级电子商务1班', '15', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (30, '25级电子商务2班', '15', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (31, '24级跨境电子商务1班', '16', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (32, '25级跨境电子商务2班', '16', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (33, '24级计算机科学与技术1班', '17', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (34, '25级计算机科学与技术2班', '17', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (35, '24级小学教育1班', '18', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (36, '25级小学教育2班', '18', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (37, '24级学前教育1班', '19', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (38, '25级学前教育2班', '19', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (39, '24级科学教育1班', '20', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (40, '25级科学教育2班', '20', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (41, '24级数学与应用数学1班', '21', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (42, '25级数学与应用数学2班', '21', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (43, '24级旅游管理1班', '22', '24级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (44, '25级旅游管理2班', '22', '25级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (45, '24级会展经济与管理1班', '23', '24级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (46, '25级会展经济与管理2班', '23', '25级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (47, '24级音乐学1班', '24', '24级', '艺术学院');
INSERT INTO `t_bj` VALUES (48, '25级音乐学2班', '24', '25级', '艺术学院');
INSERT INTO `t_bj` VALUES (49, '24级美术学1班', '25', '24级', '艺术学院');
INSERT INTO `t_bj` VALUES (50, '25级美术学2班', '25', '25级', '艺术学院');
INSERT INTO `t_bj` VALUES (51, '24级艺术与科技1班', '26', '24级', '艺术学院');
INSERT INTO `t_bj` VALUES (52, '25级艺术与科技2班', '26', '25级', '艺术学院');

-- ----------------------------
-- Table structure for t_bqzd
-- ----------------------------
DROP TABLE IF EXISTS `t_bqzd`;
CREATE TABLE `t_bqzd`  (
  `BQ_ID` int NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `BQ_MC` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '标签名称',
  `BQ_LX` int NOT NULL COMMENT '标签类型：1-兴趣/活动类别, 2-技能',
  `F_ID` int NULL DEFAULT 0 COMMENT '父标签ID(用于层级分类)',
  `ZT` int NULL DEFAULT 1 COMMENT '状态：1-启用, 0-禁用',
  `RD` int NULL DEFAULT 0 COMMENT '热度值(被引用次数)',
  `BZ` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '备注说明',
  PRIMARY KEY (`BQ_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '标签字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_bqzd
-- ----------------------------
INSERT INTO `t_bqzd` VALUES (1, '社区服务', 1, 0, 1, 0, '参与社区治理、便民服务、邻里互助、反诈宣传等');
INSERT INTO `t_bqzd` VALUES (2, '赛会服务', 1, 0, 1, 0, '体育赛事、学术会议、论坛的引导、咨询与秩序维护');
INSERT INTO `t_bqzd` VALUES (3, '环境保护', 1, 0, 1, 0, '垃圾分类引导、河道清理、植树造林、环保知识宣传');
INSERT INTO `t_bqzd` VALUES (4, '敬老助残', 1, 0, 1, 0, '关爱孤寡老人、协助残障人士出行及康复训练');
INSERT INTO `t_bqzd` VALUES (5, '支教助学', 1, 0, 1, 0, '乡村短期支教、社区课业辅导、科普知识讲座');
INSERT INTO `t_bqzd` VALUES (6, '校园建设', 1, 0, 1, 0, '图书馆整理、校园美化、迎新服务、大型校级活动辅助');
INSERT INTO `t_bqzd` VALUES (7, '摄影摄像', 2, 51, 1, 0, '需自带设备，具备单反拍摄、视频录制及基础后期处理能力');
INSERT INTO `t_bqzd` VALUES (8, '新闻写作', 2, 51, 1, 0, '撰写新闻通稿、活动推文、采访稿，具备较强文字功底');
INSERT INTO `t_bqzd` VALUES (9, '英语翻译', 2, 50, 1, 0, '具备英语口笔译能力，CET-6或专四以上水平优先');
INSERT INTO `t_bqzd` VALUES (10, '计算机维修', 2, 53, 1, 0, '擅长电脑软硬件故障排除、系统重装、网络维护');
INSERT INTO `t_bqzd` VALUES (11, '急救技能', 2, 53, 1, 0, '持有红十字救护员证或AHA证书，熟练掌握CPR及AED使用');
INSERT INTO `t_bqzd` VALUES (12, '驾驶', 2, 53, 1, 0, '持有C1/C2及以上驾照，实际驾驶经验丰富，无重大违章记录');
INSERT INTO `t_bqzd` VALUES (13, '主持演讲', 2, 52, 1, 0, '具备舞台主持或公开演讲经验，普通话标准（二甲以上）');
INSERT INTO `t_bqzd` VALUES (14, '动物保护', 1, 0, 1, 0, '流浪动物救助、生物多样性保护');
INSERT INTO `t_bqzd` VALUES (15, '文化传播', 1, 0, 1, 0, '博物馆讲解、非遗传承、文化交流');
INSERT INTO `t_bqzd` VALUES (16, '医疗卫生', 1, 0, 1, 0, '医院导诊、急救科普、献血辅助');
INSERT INTO `t_bqzd` VALUES (17, '法律援助', 1, 0, 1, 0, '普法宣传、法律咨询辅助');
INSERT INTO `t_bqzd` VALUES (18, '心理关怀', 1, 0, 1, 0, '心理热线、情感陪伴、特殊儿童关爱');
INSERT INTO `t_bqzd` VALUES (19, '乡村振兴', 1, 0, 1, 0, '三下乡、助农直播、乡村规划');
INSERT INTO `t_bqzd` VALUES (20, '大型赛会', 1, 2, 1, 0, '马拉松、亚运会等大型赛事服务');
INSERT INTO `t_bqzd` VALUES (21, '国际交流', 1, 0, 1, 0, '外事接待、留学生互助');
INSERT INTO `t_bqzd` VALUES (22, '应急救援', 1, 0, 1, 0, '防灾演练、紧急救援辅助');
INSERT INTO `t_bqzd` VALUES (23, '视频剪辑', 2, 51, 1, 0, 'Pr, AE, 剪映等视频制作能力');
INSERT INTO `t_bqzd` VALUES (24, '平面设计', 2, 51, 1, 0, 'PS, Ai, Canva海报制作');
INSERT INTO `t_bqzd` VALUES (25, '文案策划', 2, 51, 1, 0, '新闻稿、活动策划案、剧本写作');
INSERT INTO `t_bqzd` VALUES (26, '微信运营', 2, 51, 1, 0, '公众号排版、秀米、SVG制作');
INSERT INTO `t_bqzd` VALUES (28, '日语', 2, 50, 1, 0, '具备日语交流或翻译能力');
INSERT INTO `t_bqzd` VALUES (29, '法语', 2, 50, 1, 0, '具备法语交流或翻译能力');
INSERT INTO `t_bqzd` VALUES (30, '韩语', 2, 50, 1, 0, '具备韩语交流或翻译能力');
INSERT INTO `t_bqzd` VALUES (31, '手语', 2, 50, 1, 0, '掌握基本手语交流');
INSERT INTO `t_bqzd` VALUES (32, '办公软件', 2, 53, 1, 0, '精通Excel数据处理、PPT制作');
INSERT INTO `t_bqzd` VALUES (33, '编程开发', 2, 53, 1, 0, 'Java, Python, Web开发能力');
INSERT INTO `t_bqzd` VALUES (34, '数据分析', 2, 53, 1, 0, 'SPSS, Python数据分析');
INSERT INTO `t_bqzd` VALUES (35, '乐器演奏', 2, 52, 1, 0, '钢琴、吉他、小提琴等');
INSERT INTO `t_bqzd` VALUES (36, '舞蹈表演', 2, 52, 1, 0, '民族舞、街舞等');
INSERT INTO `t_bqzd` VALUES (37, '声乐', 2, 52, 1, 0, '合唱、独唱');
INSERT INTO `t_bqzd` VALUES (38, '体育特长', 2, 53, 1, 0, '篮球、足球、羽毛球裁判或教练能力');
INSERT INTO `t_bqzd` VALUES (39, '礼仪接待', 2, 52, 1, 0, '形象气质佳，懂商务礼仪');
INSERT INTO `t_bqzd` VALUES (40, '体育赛事', 1, 2, 1, 0, '马拉松、运动会、球赛等体育类活动服务');
INSERT INTO `t_bqzd` VALUES (41, '学术会议', 1, 2, 1, 0, '论坛、研讨会、讲座等学术类活动服务');
INSERT INTO `t_bqzd` VALUES (42, '典礼会务', 1, 6, 1, 0, '开学典礼、毕业典礼、晚会等大型仪式');
INSERT INTO `t_bqzd` VALUES (43, '教务辅助', 1, 6, 1, 0, '体测、监考、资料整理等教学辅助工作');
INSERT INTO `t_bqzd` VALUES (44, '校园迎新', 1, 6, 1, 0, '新生报到引导、行李搬运等');
INSERT INTO `t_bqzd` VALUES (45, '同伴互助', 1, 18, 1, 0, '心理站值班、倾听陪伴等');
INSERT INTO `t_bqzd` VALUES (50, '语言能力', 2, 0, 1, 0, '外语及手语沟通能力');
INSERT INTO `t_bqzd` VALUES (51, '媒体设计', 2, 0, 1, 0, '摄影、设计、写作与运营');
INSERT INTO `t_bqzd` VALUES (52, '表演艺术', 2, 0, 1, 0, '舞台表演与主持');
INSERT INTO `t_bqzd` VALUES (53, '专业技能', 2, 0, 1, 0, '计算机、急救、驾驶等硬技能');

-- ----------------------------
-- Table structure for t_gly
-- ----------------------------
DROP TABLE IF EXISTS `t_gly`;
CREATE TABLE `t_gly`  (
  `GLY_ZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '账号',
  `GLY_MM` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `GLY_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '名称',
  PRIMARY KEY (`GLY_ZH`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_gly
-- ----------------------------
INSERT INTO `t_gly` VALUES ('GUOZHIXIE', '6222728271a396263056093557004505', '国志协');

-- ----------------------------
-- Table structure for t_xjbmfzr
-- ----------------------------
DROP TABLE IF EXISTS `t_xjbmfzr`;
CREATE TABLE `t_xjbmfzr`  (
  `XJBM_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '校级部门名称',
  `XJBMFZR_ZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '账号',
  `XJBMFZR_MM` varchar(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `XJBMFZR_XM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '姓名',
  `XJBMFZR_DH` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '电话',
  `ZT` int NULL DEFAULT 1 COMMENT '账号状态：1-启用/正常, 0-禁用/冻结',
  `CREATE_TIME` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间',
  PRIMARY KEY (`XJBMFZR_ZH`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '校级部门负责人信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_xjbmfzr
-- ----------------------------
INSERT INTO `t_xjbmfzr` VALUES ('体育部', '800001', 'e10adc3949ba59abbe56e057f20f883e', '王浩宇', '05761001', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('行政部门', '800002', 'e10adc3949ba59abbe56e057f20f883e', '杨博文', '05761002', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('服务保障单位', '800003', 'e10adc3949ba59abbe56e057f20f883e', '刘雨桐', '05761003', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('党群组织', '800004', 'e10adc3949ba59abbe56e057f20f883e', '黄丽', '05761004', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('教务处', '800005', 'e10adc3949ba59abbe56e057f20f883e', '王桦杰', '05761005', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('国际交流合作处', '800006', 'e10adc3949ba59abbe56e057f20f883e', '周涛', '05761006', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('学生处', '800007', 'e10adc3949ba59abbe56e057f20f883e', '刘静枫', '05761007', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('学校办公室', '800008', 'e10adc3949ba59abbe56e057f20f883e', '赵杰', '05761008', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xjbmfzr` VALUES ('教学辅助单位', '800009', 'e10adc3949ba59abbe56e057f20f883e', '吴敏', '05761009', 1, '2025-12-13 12:00:53');

-- ----------------------------
-- Table structure for t_xs
-- ----------------------------
DROP TABLE IF EXISTS `t_xs`;
CREATE TABLE `t_xs`  (
  `XS_XH` int NOT NULL COMMENT '学生学号',
  `XS_XM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学生姓名',
  `XS_MM` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `XS_DH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '联系电话',
  `XS_XB` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '性别',
  `ZZMM` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '政治面貌',
  `SS_XY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院',
  `ZY_MC` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '所属专业',
  `BJ_BH` int NOT NULL COMMENT '(所属)班级编号',
  `BJ_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属班级',
  `XQ_BQ` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '兴趣标签(用于内容推荐)',
  `JN_BQ` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '技能标签(用于内容推荐)',
  `GRJJ` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '个人简介',
  `ZT` int NULL DEFAULT 1 COMMENT '账号状态：1-启用/正常, 0-禁用/冻结',
  `CREATE_TIME` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间',
  PRIMARY KEY (`XS_XH`) USING BTREE,
  INDEX `FK_XS_BJ`(`BJ_BH` ASC) USING BTREE,
  INDEX `idx_xs_xm`(`XS_XM` ASC) USING BTREE,
  INDEX `idx_xs_dh`(`XS_DH` ASC) USING BTREE,
  CONSTRAINT `FK_XS_BJ` FOREIGN KEY (`BJ_BH`) REFERENCES `t_bj` (`BJ_BH`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学生信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_xs
-- ----------------------------
INSERT INTO `t_xs` VALUES (2024104, '李胜男', 'be218b83f1c803b5e3818fc2996b0549', '19560040425', '1', '群众', '语言文化学院', '英语', 1, '24英语1班', '赛会服务,医疗卫生', '英语翻译,计算机维修,微信运营', '', 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024106, '章客', 'e10adc3949ba59abbe56e057f20f883e', '14346190557', '1', '共青团员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024108, '陈基', 'e10adc3949ba59abbe56e057f20f883e', '13537257037', '1', '共青团员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024110, '陈客', 'e10adc3949ba59abbe56e057f20f883e', '15092168976', '0', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024112, '陈政', 'e10adc3949ba59abbe56e057f20f883e', '16915897494', '1', '共青团员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024114, '王政', 'e10adc3949ba59abbe56e057f20f883e', '14572531874', '0', '共青团员', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024116, '林别', 'e10adc3949ba59abbe56e057f20f883e', '13635028451', '1', '共青团员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024118, '季和', 'e10adc3949ba59abbe56e057f20f883e', '19912753978', '1', '共青团员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024120, '陈别', 'e10adc3949ba59abbe56e057f20f883e', '17627069809', '1', '共青团员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024122, '陈政政', 'e10adc3949ba59abbe56e057f20f883e', '13699540842', '1', '共青团员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024124, '章基大', 'e10adc3949ba59abbe56e057f20f883e', '14647647993', '0', '共青团员', '语言文化学院', '汉语言', 21, '24汉语言1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024126, '卢于基', 'e10adc3949ba59abbe56e057f20f883e', '18009444571', '0', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024128, '方基个', 'e10adc3949ba59abbe56e057f20f883e', '17350615187', '1', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024130, '季拿媒', 'e10adc3949ba59abbe56e057f20f883e', '18576687706', '1', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024132, '陈政于', 'e10adc3949ba59abbe56e057f20f883e', '17801530004', '0', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024134, '王别于', 'e10adc3949ba59abbe56e057f20f883e', '19038881002', '1', '共青团员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024136, '方加政', 'e10adc3949ba59abbe56e057f20f883e', '16524969276', '1', '共青团员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024138, '季拿基', 'e10adc3949ba59abbe56e057f20f883e', '13624487512', '1', '共青团员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024140, '陈府大', 'e10adc3949ba59abbe56e057f20f883e', '13140539523', '0', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024203, '林定关', 'e10adc3949ba59abbe56e057f20f883e', '17049863608', '1', '共青团员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024205, '李定严', 'e10adc3949ba59abbe56e057f20f883e', '14682553129', '1', '共青团员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024207, '李定中', 'e10adc3949ba59abbe56e057f20f883e', '19519737267', '0', '共青团员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024209, '李反定', 'e10adc3949ba59abbe56e057f20f883e', '19732030188', '1', '共青团员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024211, '金协协', 'e10adc3949ba59abbe56e057f20f883e', '13230938449', '1', '共青团员', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024213, '张违加', 'e10adc3949ba59abbe56e057f20f883e', '19799559125', '0', '共青团员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024215, '卢严违', 'e10adc3949ba59abbe56e057f20f883e', '15113177613', '1', '共青团员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024217, '季重定', 'e10adc3949ba59abbe56e057f20f883e', '17954342802', '0', '共青团员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024219, '金反重', 'e10adc3949ba59abbe56e057f20f883e', '18113915011', '1', '共青团员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024221, '方中边', 'e10adc3949ba59abbe56e057f20f883e', '14575300266', '1', '共青团员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024223, '金重加', 'e10adc3949ba59abbe56e057f20f883e', '15905470238', '0', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024225, '李关重', 'e10adc3949ba59abbe56e057f20f883e', '16026232416', '0', '共青团员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024227, '林违反', 'e10adc3949ba59abbe56e057f20f883e', '16349184044', '0', '共青团员', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024229, '季相双', 'e10adc3949ba59abbe56e057f20f883e', '15398405379', '1', '共青团员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024231, '林边违', 'e10adc3949ba59abbe56e057f20f883e', '13427046091', '0', '共青团员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024233, '李严边', 'e10adc3949ba59abbe56e057f20f883e', '18528227598', '0', '共青团员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024235, '陈定边', 'e10adc3949ba59abbe56e057f20f883e', '15192909830', '1', '共青团员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024238, '陈双协', 'e10adc3949ba59abbe56e057f20f883e', '19911238664', '1', '共青团员', '语言文化学院', '汉语言', 21, '24汉语言1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024240, '金反边', 'e10adc3949ba59abbe56e057f20f883e', '19577346431', '1', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024302, '张公边', 'e10adc3949ba59abbe56e057f20f883e', '15768434495', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024304, '王协双', 'e10adc3949ba59abbe56e057f20f883e', '19404137805', '0', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024306, '王和关', 'e10adc3949ba59abbe56e057f20f883e', '14762708121', '0', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024308, '卢国协', 'e10adc3949ba59abbe56e057f20f883e', '14854214339', '0', '共青团员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024310, '陈公边', 'e10adc3949ba59abbe56e057f20f883e', '17365699629', '1', '共青团员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024312, '卢中公', 'e10adc3949ba59abbe56e057f20f883e', '13260364185', '1', '共青团员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024314, '章中依', 'e10adc3949ba59abbe56e057f20f883e', '13655623131', '1', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024316, '王和际', 'e10adc3949ba59abbe56e057f20f883e', '13113562099', '1', '共青团员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024318, '章际公', 'e10adc3949ba59abbe56e057f20f883e', '16257071991', '0', '共青团员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024320, '李国双', 'e10adc3949ba59abbe56e057f20f883e', '18862309221', '1', '共青团员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024322, '卢定', 'e10adc3949ba59abbe56e057f20f883e', '13070227551', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024324, '季关', 'e10adc3949ba59abbe56e057f20f883e', '19573540762', '1', '共青团员', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024326, '李边', 'e10adc3949ba59abbe56e057f20f883e', '19265226803', '0', '共青团员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024328, '陈关', 'e10adc3949ba59abbe56e057f20f883e', '15877442688', '1', '共青团员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024330, '章国', 'e10adc3949ba59abbe56e057f20f883e', '15284370123', '0', '共青团员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024332, '李加', 'e10adc3949ba59abbe56e057f20f883e', '14506048429', '1', '共青团员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024334, '陈公', 'e10adc3949ba59abbe56e057f20f883e', '18055589320', '1', '共青团员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024336, '王约', 'e10adc3949ba59abbe56e057f20f883e', '13501761496', '1', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024338, '陈约', 'e10adc3949ba59abbe56e057f20f883e', '13033164829', '0', '共青团员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024340, '金中', 'e10adc3949ba59abbe56e057f20f883e', '18114278559', '0', '共青团员', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024402, '林关', 'e10adc3949ba59abbe56e057f20f883e', '13872809449', '1', '共青团员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024404, '金约定', 'e10adc3949ba59abbe56e057f20f883e', '14554872772', '1', '共青团员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024406, '卢际双', 'e10adc3949ba59abbe56e057f20f883e', '13687297907', '0', '共青团员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024408, '李中', 'e10adc3949ba59abbe56e057f20f883e', '14064805566', '1', '共青团员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024410, '金定', 'e10adc3949ba59abbe56e057f20f883e', '17045624871', '0', '共青团员', '语言文化学院', '汉语言', 21, '24汉语言1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024412, '林公', 'e10adc3949ba59abbe56e057f20f883e', '14283622742', '0', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024414, '王国', 'e10adc3949ba59abbe56e057f20f883e', '16978208545', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024416, '方际', 'e10adc3949ba59abbe56e057f20f883e', '14033357956', '0', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024418, '林协国', 'e10adc3949ba59abbe56e057f20f883e', '17829924539', '1', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024420, '季协', 'e10adc3949ba59abbe56e057f20f883e', '15468344918', '0', '共青团员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024422, '陈中', 'e10adc3949ba59abbe56e057f20f883e', '14429232879', '0', '共青团员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024424, '王约边', 'e10adc3949ba59abbe56e057f20f883e', '17940320725', '0', '共青团员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024426, '林协', 'e10adc3949ba59abbe56e057f20f883e', '18002998141', '1', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024428, '李际', 'e10adc3949ba59abbe56e057f20f883e', '18594078437', '0', '共青团员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024430, '金定定', 'e10adc3949ba59abbe56e057f20f883e', '18260507306', '1', '共青团员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024432, '林双', 'e10adc3949ba59abbe56e057f20f883e', '19602933163', '0', '共青团员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024434, '李约约', 'e10adc3949ba59abbe56e057f20f883e', '15111164623', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024436, '卢际', 'e10adc3949ba59abbe56e057f20f883e', '15685729661', '1', '共青团员', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024438, '张边和', 'e10adc3949ba59abbe56e057f20f883e', '14028382232', '1', '共青团员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024440, '张约', 'e10adc3949ba59abbe56e057f20f883e', '16367695737', '0', '共青团员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024510, '王边', 'e10adc3949ba59abbe56e057f20f883e', '15730779206', '0', '共青团员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024512, '金定际', 'e10adc3949ba59abbe56e057f20f883e', '16575543551', '1', '共青团员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024514, '陈加', 'e10adc3949ba59abbe56e057f20f883e', '14358314896', '1', '共青团员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024516, '金国和', 'e10adc3949ba59abbe56e057f20f883e', '13628091345', '1', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024518, '林中', 'e10adc3949ba59abbe56e057f20f883e', '18708901768', '1', '共青团员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024520, '季国', 'e10adc3949ba59abbe56e057f20f883e', '15816311767', '0', '共青团员', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024521, '季边', 'e10adc3949ba59abbe56e057f20f883e', '19129807938', '1', '共青团员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024523, '张定', 'e10adc3949ba59abbe56e057f20f883e', '19119545194', '1', '共青团员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024525, '卢依', 'e10adc3949ba59abbe56e057f20f883e', '19103087528', '0', '共青团员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024527, '金中依', 'e10adc3949ba59abbe56e057f20f883e', '18882756572', '1', '共青团员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024529, '陈际国', 'e10adc3949ba59abbe56e057f20f883e', '19844587388', '0', '共青团员', '语言文化学院', '汉语言', 21, '24汉语言1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024530, '张和', 'e10adc3949ba59abbe56e057f20f883e', '16102351505', '0', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024532, '章际约', 'e10adc3949ba59abbe56e057f20f883e', '19343392384', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024534, '季中双', 'e10adc3949ba59abbe56e057f20f883e', '19603292034', '0', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024536, '林际', 'e10adc3949ba59abbe56e057f20f883e', '14372017472', '0', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024538, '卢中中', 'e10adc3949ba59abbe56e057f20f883e', '14638703941', '1', '共青团员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024540, '王际边', 'e10adc3949ba59abbe56e057f20f883e', '18787217904', '1', '共青团员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024550, '陈协协', 'e10adc3949ba59abbe56e057f20f883e', '17208804995', '0', '共青团员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024570, '陈协', 'e10adc3949ba59abbe56e057f20f883e', '19882334040', '1', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2024590, '陈际边', 'e10adc3949ba59abbe56e057f20f883e', '17885102088', '1', '共青团员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025105, '陈府', 'e10adc3949ba59abbe56e057f20f883e', '15875933593', '0', '共青团员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025107, '章拿', 'e10adc3949ba59abbe56e057f20f883e', '16676819765', '1', '共青团员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025109, '陈拿', 'e10adc3949ba59abbe56e057f20f883e', '13976173478', '0', '共青团员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025111, '林政', 'e10adc3949ba59abbe56e057f20f883e', '19455918470', '0', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025113, '王加', 'e10adc3949ba59abbe56e057f20f883e', '17876889918', '1', '共青团员', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025115, '张媒', 'e10adc3949ba59abbe56e057f20f883e', '16557642496', '0', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025117, '林府', 'e10adc3949ba59abbe56e057f20f883e', '16703198444', '0', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025119, '王和', 'e10adc3949ba59abbe56e057f20f883e', '13341988256', '1', '共青团员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025121, '张加客', 'e10adc3949ba59abbe56e057f20f883e', '16168991147', '1', '共青团员', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025123, '王客个', 'e10adc3949ba59abbe56e057f20f883e', '16132937774', '1', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025125, '李拿个', 'e10adc3949ba59abbe56e057f20f883e', '13004897656', '0', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025127, '卢政别', 'e10adc3949ba59abbe56e057f20f883e', '18896615789', '1', '共青团员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025129, '王客基', 'e10adc3949ba59abbe56e057f20f883e', '13991621359', '0', '共青团员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025131, '张客和', 'e10adc3949ba59abbe56e057f20f883e', '16771263999', '0', '共青团员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025133, '章大大', 'e10adc3949ba59abbe56e057f20f883e', '14729424036', '1', '共青团员', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025135, '陈客府', 'e10adc3949ba59abbe56e057f20f883e', '13917680978', '1', '共青团员', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025137, '李基和', 'e10adc3949ba59abbe56e057f20f883e', '16871122540', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025139, '金加基', 'e10adc3949ba59abbe56e057f20f883e', '18292199743', '1', '共青团员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025202, '方关加', 'e10adc3949ba59abbe56e057f20f883e', '13711692531', '1', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025204, '章关定', 'e10adc3949ba59abbe56e057f20f883e', '14892360682', '1', '共青团员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025206, '章定加', 'e10adc3949ba59abbe56e057f20f883e', '18549620462', '0', '共青团员', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025208, '张相反', 'e10adc3949ba59abbe56e057f20f883e', '14411542915', '1', '共青团员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025210, '金相边', 'e10adc3949ba59abbe56e057f20f883e', '15872731505', '1', '共青团员', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025212, '方严相', 'e10adc3949ba59abbe56e057f20f883e', '13878012649', '1', '共青团员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025214, '李关协', 'e10adc3949ba59abbe56e057f20f883e', '13827657067', '1', '共青团员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025216, '季双协', 'e10adc3949ba59abbe56e057f20f883e', '19823370704', '1', '共青团员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025218, '林相双', 'e10adc3949ba59abbe56e057f20f883e', '16195130054', '1', '共青团员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025220, '张重关', 'e10adc3949ba59abbe56e057f20f883e', '15297134965', '1', '共青团员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025222, '金反相', 'e10adc3949ba59abbe56e057f20f883e', '15889394142', '0', '共青团员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025224, '张协双', 'e10adc3949ba59abbe56e057f20f883e', '15224274291', '1', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025226, '王双严', 'e10adc3949ba59abbe56e057f20f883e', '19256664538', '0', '共青团员', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025228, '方关严', 'e10adc3949ba59abbe56e057f20f883e', '15858157890', '0', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025230, '金加违', 'e10adc3949ba59abbe56e057f20f883e', '15995019349', '0', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025232, '季重中', 'e10adc3949ba59abbe56e057f20f883e', '13181946896', '0', '共青团员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025234, '方违边', 'e10adc3949ba59abbe56e057f20f883e', '18501817160', '0', '共青团员', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025237, '章违相', 'e10adc3949ba59abbe56e057f20f883e', '13897004265', '1', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025239, '陈加重', 'e10adc3949ba59abbe56e057f20f883e', '14526726869', '0', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025301, '陈协和', 'e10adc3949ba59abbe56e057f20f883e', '19934772408', '0', '共青团员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025303, '陈中双', 'e10adc3949ba59abbe56e057f20f883e', '19020134213', '1', '共青团员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025305, '陈际加', 'e10adc3949ba59abbe56e057f20f883e', '14969598654', '0', '共青团员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025307, '季协际', 'e10adc3949ba59abbe56e057f20f883e', '14241166793', '1', '共青团员', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025309, '李际公', 'e10adc3949ba59abbe56e057f20f883e', '16855781470', '0', '共青团员', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025311, '李依依', 'e10adc3949ba59abbe56e057f20f883e', '18089347066', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025313, '林公中', 'e10adc3949ba59abbe56e057f20f883e', '14995561306', '1', '共青团员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025315, '王公公', 'e10adc3949ba59abbe56e057f20f883e', '14111541499', '0', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025317, '林关中', 'e10adc3949ba59abbe56e057f20f883e', '19159237009', '0', '共青团员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025319, '季中关', 'e10adc3949ba59abbe56e057f20f883e', '13021629964', '0', '共青团员', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025321, '方加', 'e10adc3949ba59abbe56e057f20f883e', '18977836506', '0', '共青团员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025323, '李关', 'e10adc3949ba59abbe56e057f20f883e', '16384224222', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025325, '王定', 'e10adc3949ba59abbe56e057f20f883e', '16499731944', '1', '共青团员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025327, '季国', 'e10adc3949ba59abbe56e057f20f883e', '19036889218', '0', '共青团员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025329, '金中', 'e10adc3949ba59abbe56e057f20f883e', '16203307933', '1', '共青团员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025331, '方公', 'e10adc3949ba59abbe56e057f20f883e', '17530848041', '1', '共青团员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025333, '王和', 'e10adc3949ba59abbe56e057f20f883e', '18256341668', '1', '共青团员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025335, '陈公', 'e10adc3949ba59abbe56e057f20f883e', '19092859595', '1', '共青团员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025337, '林中', 'e10adc3949ba59abbe56e057f20f883e', '16457257572', '0', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025339, '金公', 'e10adc3949ba59abbe56e057f20f883e', '17852157789', '0', '共青团员', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025401, '方依加', 'e10adc3949ba59abbe56e057f20f883e', '15075680121', '0', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025403, '章国协', 'e10adc3949ba59abbe56e057f20f883e', '15768502489', '0', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025405, '方双边', 'e10adc3949ba59abbe56e057f20f883e', '17920426479', '0', '共青团员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025407, '林际', 'e10adc3949ba59abbe56e057f20f883e', '17571580981', '1', '共青团员', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025409, '金双双', 'e10adc3949ba59abbe56e057f20f883e', '19576200608', '1', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025411, '方和', 'e10adc3949ba59abbe56e057f20f883e', '15803583008', '1', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025413, '陈国', 'e10adc3949ba59abbe56e057f20f883e', '13082271969', '0', '共青团员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025415, '陈依中', 'e10adc3949ba59abbe56e057f20f883e', '13330920607', '0', '共青团员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025417, '方公公', 'e10adc3949ba59abbe56e057f20f883e', '15547044091', '0', '共青团员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025419, '李中', 'e10adc3949ba59abbe56e057f20f883e', '18415552549', '1', '共青团员', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025421, '季关', 'e10adc3949ba59abbe56e057f20f883e', '17972101893', '0', '共青团员', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025423, '季定约', 'e10adc3949ba59abbe56e057f20f883e', '19729963303', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025425, '林公和', 'e10adc3949ba59abbe56e057f20f883e', '19120385999', '0', '共青团员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025427, '王约', 'e10adc3949ba59abbe56e057f20f883e', '13717664545', '0', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025429, '金和', 'e10adc3949ba59abbe56e057f20f883e', '16552152635', '1', '共青团员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025431, '章和', 'e10adc3949ba59abbe56e057f20f883e', '13031919437', '0', '共青团员', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025433, '方际', 'e10adc3949ba59abbe56e057f20f883e', '18637095872', '0', '共青团员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025435, '陈边约', 'e10adc3949ba59abbe56e057f20f883e', '19817546924', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025437, '李国', 'e10adc3949ba59abbe56e057f20f883e', '14799528984', '1', '共青团员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025439, '张依', 'e10adc3949ba59abbe56e057f20f883e', '14833128656', '0', '共青团员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025510, '章加', 'e10adc3949ba59abbe56e057f20f883e', '15633683885', '1', '共青团员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025511, '陈定', 'e10adc3949ba59abbe56e057f20f883e', '19541836188', '0', '共青团员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025513, '林中依', 'e10adc3949ba59abbe56e057f20f883e', '13591732895', '1', '共青团员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025515, '金际国', 'e10adc3949ba59abbe56e057f20f883e', '18366399593', '0', '共青团员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025517, '章边', 'e10adc3949ba59abbe56e057f20f883e', '15635996502', '1', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025519, '陈协中', 'e10adc3949ba59abbe56e057f20f883e', '13786337477', '1', '共青团员', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025520, '章双约', 'e10adc3949ba59abbe56e057f20f883e', '16216443834', '1', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025522, '王约加', 'e10adc3949ba59abbe56e057f20f883e', '16035395823', '1', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025524, '金约定', 'e10adc3949ba59abbe56e057f20f883e', '16724526415', '0', '共青团员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025526, '金定', 'e10adc3949ba59abbe56e057f20f883e', '19447439756', '0', '共青团员', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025528, '方国双', 'e10adc3949ba59abbe56e057f20f883e', '16980617915', '0', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025530, '陈约', 'e10adc3949ba59abbe56e057f20f883e', '16604782856', '1', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025531, '张约', 'e10adc3949ba59abbe56e057f20f883e', '16665313315', '1', '共青团员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025533, '方双关', 'e10adc3949ba59abbe56e057f20f883e', '18197907556', '0', '共青团员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025535, '张协', 'e10adc3949ba59abbe56e057f20f883e', '16772424021', '0', '共青团员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025537, '金公双', 'e10adc3949ba59abbe56e057f20f883e', '16894888672', '1', '共青团员', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025539, '林加双', 'e10adc3949ba59abbe56e057f20f883e', '14051068867', '0', '共青团员', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025540, '卢边关', 'e10adc3949ba59abbe56e057f20f883e', '18916310705', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025560, '章公中', 'e10adc3949ba59abbe56e057f20f883e', '13950283866', '1', '共青团员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025580, '章中', 'e10adc3949ba59abbe56e057f20f883e', '15808597390', '0', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025601, '周宏', 'e10adc3949ba59abbe56e057f20f883e', '13810795896', '0', '共青团员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025602, '姜友', 'e10adc3949ba59abbe56e057f20f883e', '19127745797', '1', '中共党员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025603, '苏利', 'e10adc3949ba59abbe56e057f20f883e', '19130007351', '0', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025604, '董邦', 'e10adc3949ba59abbe56e057f20f883e', '19320427788', '1', '共青团员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025605, '江谦涛', 'e10adc3949ba59abbe56e057f20f883e', '18918062095', '0', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025606, '黄义彬', 'e10adc3949ba59abbe56e057f20f883e', '14559329991', '1', '群众', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025607, '雷政', 'e10adc3949ba59abbe56e057f20f883e', '13364711260', '0', '共青团员', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025608, '陆致', 'e10adc3949ba59abbe56e057f20f883e', '18895544305', '1', '共青团员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025609, '龙策', 'e10adc3949ba59abbe56e057f20f883e', '13732940731', '0', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025610, '范厚', 'e10adc3949ba59abbe56e057f20f883e', '15865975423', '1', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025611, '白盛', 'e10adc3949ba59abbe56e057f20f883e', '13857066742', '0', '共青团员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025612, '苏壮', 'e10adc3949ba59abbe56e057f20f883e', '13490489580', '1', '共青团员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025613, '雷邦', 'e10adc3949ba59abbe56e057f20f883e', '15605701613', '0', '共青团员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025614, '郑思', 'e10adc3949ba59abbe56e057f20f883e', '18093924717', '1', '共青团员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025615, '顾彬', 'e10adc3949ba59abbe56e057f20f883e', '13333255377', '0', '共青团员', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025616, '文风', 'e10adc3949ba59abbe56e057f20f883e', '15486530002', '1', '群众', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025617, '范安', 'e10adc3949ba59abbe56e057f20f883e', '16244771925', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025618, '石家行', 'e10adc3949ba59abbe56e057f20f883e', '17271896845', '1', '共青团员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025619, '邵树', 'e10adc3949ba59abbe56e057f20f883e', '16963093015', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025620, '叶茂', 'e10adc3949ba59abbe56e057f20f883e', '14851695954', '1', '共青团员', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025621, '孔兴', 'e10adc3949ba59abbe56e057f20f883e', '18514386277', '0', '共青团员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025622, '马浩', 'e10adc3949ba59abbe56e057f20f883e', '13108075951', '1', '共青团员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025623, '冯乐', 'e10adc3949ba59abbe56e057f20f883e', '14423966857', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025624, '叶新', 'e10adc3949ba59abbe56e057f20f883e', '17082686998', '1', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025625, '段会', 'e10adc3949ba59abbe56e057f20f883e', '15755351543', '0', '共青团员', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025626, '唐建', 'e10adc3949ba59abbe56e057f20f883e', '17607496606', '1', '中共党员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025627, '梁震', 'e10adc3949ba59abbe56e057f20f883e', '15744271916', '0', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025628, '雷康', 'e10adc3949ba59abbe56e057f20f883e', '18673697221', '1', '共青团员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025629, '石致', 'e10adc3949ba59abbe56e057f20f883e', '13101800244', '0', '共青团员', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025630, '龙诚', 'e10adc3949ba59abbe56e057f20f883e', '16870929924', '1', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025631, '郑博', 'e10adc3949ba59abbe56e057f20f883e', '13631466645', '0', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025632, '邹安', 'e10adc3949ba59abbe56e057f20f883e', '13159497217', '1', '共青团员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025633, '于谦', 'e10adc3949ba59abbe56e057f20f883e', '18347247599', '0', '共青团员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025634, '宋时', 'e10adc3949ba59abbe56e057f20f883e', '16162229701', '1', '共青团员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025635, '罗祥', 'e10adc3949ba59abbe56e057f20f883e', '16957136206', '0', '共青团员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025636, '蔡朗', 'e10adc3949ba59abbe56e057f20f883e', '15725520886', '1', '共青团员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025637, '萧彬', 'e10adc3949ba59abbe56e057f20f883e', '17170671258', '0', '中共党员', '语言文化学院', '汉语言', 21, '24汉语言1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025638, '方风', 'e10adc3949ba59abbe56e057f20f883e', '18713066207', '1', '共青团员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025639, '姜壮', 'e10adc3949ba59abbe56e057f20f883e', '13012216902', '0', '共青团员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025640, '陆策', 'e10adc3949ba59abbe56e057f20f883e', '19814525550', '1', '共青团员', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025641, '曹宁', 'e10adc3949ba59abbe56e057f20f883e', '14366033606', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025642, '钱若', 'e10adc3949ba59abbe56e057f20f883e', '15623908850', '1', '共青团员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025643, '金会', 'e10adc3949ba59abbe56e057f20f883e', '13559965985', '0', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025644, '汤义', 'e10adc3949ba59abbe56e057f20f883e', '16024174341', '1', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025645, '郝发', 'e10adc3949ba59abbe56e057f20f883e', '16419618887', '0', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025646, '赖坚', 'e10adc3949ba59abbe56e057f20f883e', '17755190065', '1', '共青团员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025647, '钱有', 'e10adc3949ba59abbe56e057f20f883e', '19572041541', '0', '共青团员', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025648, '沈良', 'e10adc3949ba59abbe56e057f20f883e', '19072078979', '1', '共青团员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025649, '江榕', 'e10adc3949ba59abbe56e057f20f883e', '16221127012', '0', '共青团员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025650, '常以', 'e10adc3949ba59abbe56e057f20f883e', '17552702705', '1', '共青团员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025651, '冯胜', 'e10adc3949ba59abbe56e057f20f883e', '18511208571', '0', '中共党员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025652, '宋冠', 'e10adc3949ba59abbe56e057f20f883e', '13738638791', '1', '共青团员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025653, '戴鸣', 'e10adc3949ba59abbe56e057f20f883e', '16433260158', '0', '共青团员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025654, '薛群', 'e10adc3949ba59abbe56e057f20f883e', '17584194161', '1', '共青团员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025655, '汤树', 'e10adc3949ba59abbe56e057f20f883e', '14200347922', '0', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025656, '孔邦', 'e10adc3949ba59abbe56e057f20f883e', '16548863358', '1', '共青团员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025657, '陆辉', 'e10adc3949ba59abbe56e057f20f883e', '16625272779', '0', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025658, '陆会', 'e10adc3949ba59abbe56e057f20f883e', '18940412859', '1', '共青团员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025659, '叶钧', 'e10adc3949ba59abbe56e057f20f883e', '15240389590', '0', '共青团员', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025660, '雷朗', 'e10adc3949ba59abbe56e057f20f883e', '19103686759', '1', '共青团员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025661, '于岩', 'e10adc3949ba59abbe56e057f20f883e', '17806542390', '0', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025662, '段鸣', 'e10adc3949ba59abbe56e057f20f883e', '14391124867', '1', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025663, '江盛', 'e10adc3949ba59abbe56e057f20f883e', '16172491237', '0', '共青团员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025664, '余言', 'e10adc3949ba59abbe56e057f20f883e', '16757209987', '1', '共青团员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025665, '董伦', 'e10adc3949ba59abbe56e057f20f883e', '15834568893', '0', '共青团员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025666, '薛辉', 'e10adc3949ba59abbe56e057f20f883e', '19041919366', '1', '共青团员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025667, '雷若', 'e10adc3949ba59abbe56e057f20f883e', '16285348199', '0', '共青团员', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025668, '白志', 'e10adc3949ba59abbe56e057f20f883e', '19044341770', '1', '共青团员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025669, '江壮', 'e10adc3949ba59abbe56e057f20f883e', '14274360111', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025670, '潘有', 'e10adc3949ba59abbe56e057f20f883e', '16813766459', '1', '共青团员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025671, '秦贵', 'e10adc3949ba59abbe56e057f20f883e', '16992322010', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025672, '蔡家', 'e10adc3949ba59abbe56e057f20f883e', '16530220346', '1', '共青团员', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025673, '萧致', 'e10adc3949ba59abbe56e057f20f883e', '14143288754', '0', '共青团员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025674, '叶邦', 'e10adc3949ba59abbe56e057f20f883e', '14950503488', '1', '共青团员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025675, '石辉', 'e10adc3949ba59abbe56e057f20f883e', '19769967780', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025676, '武发', 'e10adc3949ba59abbe56e057f20f883e', '13074856700', '1', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025677, '魏群', 'e10adc3949ba59abbe56e057f20f883e', '14492567562', '0', '共青团员', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025678, '董乐', 'e10adc3949ba59abbe56e057f20f883e', '13685073668', '1', '共青团员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025679, '阎冠', 'e10adc3949ba59abbe56e057f20f883e', '15583291916', '0', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025680, '陆岩', 'e10adc3949ba59abbe56e057f20f883e', '19916883675', '1', '共青团员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025681, '曹时', 'e10adc3949ba59abbe56e057f20f883e', '18171162856', '0', '共青团员', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025682, '龙思', 'e10adc3949ba59abbe56e057f20f883e', '16000141480', '1', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025683, '杜致', 'e10adc3949ba59abbe56e057f20f883e', '16462222684', '0', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025684, '萧政', 'e10adc3949ba59abbe56e057f20f883e', '18780957964', '1', '中共党员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025685, '侯有', 'e10adc3949ba59abbe56e057f20f883e', '15678197432', '0', '共青团员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025686, '蔡行', 'e10adc3949ba59abbe56e057f20f883e', '14857129808', '1', '共青团员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025687, '万乐', 'e10adc3949ba59abbe56e057f20f883e', '18181689747', '0', '共青团员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025688, '唐义', 'e10adc3949ba59abbe56e057f20f883e', '17737937208', '1', '共青团员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025689, '姜茂', 'e10adc3949ba59abbe56e057f20f883e', '18385599516', '0', '共青团员', '语言文化学院', '汉语言', 21, '24汉语言1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025690, '汤发', 'e10adc3949ba59abbe56e057f20f883e', '18684956213', '1', '共青团员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025691, '唐贵', 'e10adc3949ba59abbe56e057f20f883e', '13543772676', '0', '共青团员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025692, '武福', 'e10adc3949ba59abbe56e057f20f883e', '15167075212', '1', '共青团员', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025693, '段福', 'e10adc3949ba59abbe56e057f20f883e', '18280475220', '0', '共青团员', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025694, '叶邦', 'e10adc3949ba59abbe56e057f20f883e', '13825352563', '1', '共青团员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025695, '白强', 'e10adc3949ba59abbe56e057f20f883e', '18157421992', '0', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025696, '金若', 'e10adc3949ba59abbe56e057f20f883e', '17562845060', '1', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025697, '魏志', 'e10adc3949ba59abbe56e057f20f883e', '19277258489', '0', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025698, '常栋', 'e10adc3949ba59abbe56e057f20f883e', '15202306036', '1', '共青团员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025699, '白乐', 'e10adc3949ba59abbe56e057f20f883e', '18348488556', '0', '共青团员', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025700, '姜时', 'e10adc3949ba59abbe56e057f20f883e', '15800528526', '1', '共青团员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025701, '吕力楠', 'e10adc3949ba59abbe56e057f20f883e', '19073645263', '1', '群众', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025702, '薛言伯', 'e10adc3949ba59abbe56e057f20f883e', '17194503557', '0', '中共党员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025703, '蒋和琛', 'e10adc3949ba59abbe56e057f20f883e', '19032760486', '1', '中共党员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025704, '廖超心', 'e10adc3949ba59abbe56e057f20f883e', '15871917497', '0', '共青团员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025705, '吕宁强', 'e10adc3949ba59abbe56e057f20f883e', '14271588349', '0', '中共党员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025706, '袁博启', 'e10adc3949ba59abbe56e057f20f883e', '18312921450', '0', '中共党员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025707, '黄新友', 'e10adc3949ba59abbe56e057f20f883e', '13501212691', '0', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025708, '高震民', 'e10adc3949ba59abbe56e057f20f883e', '14706748356', '0', '中共党员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025709, '高国山', 'e10adc3949ba59abbe56e057f20f883e', '18917304832', '0', '中共党员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025710, '孙毅岩', 'e10adc3949ba59abbe56e057f20f883e', '14068056881', '1', '群众', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025711, '田善德', 'e10adc3949ba59abbe56e057f20f883e', '18037337533', '0', '中共党员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025712, '孔旭翰', 'e10adc3949ba59abbe56e057f20f883e', '17096901474', '0', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025713, '夏航弘', 'e10adc3949ba59abbe56e057f20f883e', '16505090495', '0', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025714, '赵强壮', 'e10adc3949ba59abbe56e057f20f883e', '18724606412', '0', '中共党员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025715, '贾承清', 'e10adc3949ba59abbe56e057f20f883e', '13221707652', '0', '群众', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025716, '高振家', 'e10adc3949ba59abbe56e057f20f883e', '19690987964', '1', '共青团员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025717, '贾伟承', 'e10adc3949ba59abbe56e057f20f883e', '18133402735', '0', '中共党员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025718, '周力全', 'e10adc3949ba59abbe56e057f20f883e', '14315760560', '0', '群众', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025719, '蒋敬炎', 'e10adc3949ba59abbe56e057f20f883e', '14798826312', '0', '共青团员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025720, '丁茂发', 'e10adc3949ba59abbe56e057f20f883e', '16335855167', '0', '共青团员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025721, '郝永福', 'e10adc3949ba59abbe56e057f20f883e', '13191811650', '1', '共青团员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025722, '秦利奇', 'e10adc3949ba59abbe56e057f20f883e', '18621725122', '1', '共青团员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025723, '熊刚豪', 'e10adc3949ba59abbe56e057f20f883e', '17086472744', '0', '中共党员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025724, '江谦谦', 'e10adc3949ba59abbe56e057f20f883e', '17047456317', '1', '群众', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025725, '孟博生', 'e10adc3949ba59abbe56e057f20f883e', '14123415613', '0', '中共党员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025726, '廖钧厚', 'e10adc3949ba59abbe56e057f20f883e', '19917790077', '0', '群众', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025727, '余林宏', 'e10adc3949ba59abbe56e057f20f883e', '13327271227', '1', '中共党员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025728, '孟进致', 'e10adc3949ba59abbe56e057f20f883e', '17958042893', '1', '群众', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025729, '彭敬河', 'e10adc3949ba59abbe56e057f20f883e', '13257374209', '0', '共青团员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025730, '毛榕乐', 'e10adc3949ba59abbe56e057f20f883e', '14267724217', '0', '中共党员', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025731, '易晨政', 'e10adc3949ba59abbe56e057f20f883e', '18770392516', '1', '群众', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025732, '毛雄翔', 'e10adc3949ba59abbe56e057f20f883e', '17227940133', '0', '群众', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025733, '雷富峰', 'e10adc3949ba59abbe56e057f20f883e', '13397330174', '1', '中共党员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025734, '林有顺', 'e10adc3949ba59abbe56e057f20f883e', '19497812387', '1', '群众', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025735, '何梁梁', 'e10adc3949ba59abbe56e057f20f883e', '17882464077', '0', '中共党员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025736, '白友勇', 'e10adc3949ba59abbe56e057f20f883e', '15286506251', '1', '中共党员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025737, '冯邦健', 'e10adc3949ba59abbe56e057f20f883e', '14501442363', '1', '共青团员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025738, '黎晨群', 'e10adc3949ba59abbe56e057f20f883e', '17948848926', '0', '中共党员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025739, '陆心政', 'e10adc3949ba59abbe56e057f20f883e', '17515148602', '0', '群众', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025740, '乔树致', 'e10adc3949ba59abbe56e057f20f883e', '16248183394', '0', '中共党员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025741, '吕会若', 'e10adc3949ba59abbe56e057f20f883e', '16079147338', '1', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025742, '梁元群', 'e10adc3949ba59abbe56e057f20f883e', '17270149152', '1', '群众', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025743, '冯天维', 'e10adc3949ba59abbe56e057f20f883e', '14420508123', '1', '中共党员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025744, '胡全敬', 'e10adc3949ba59abbe56e057f20f883e', '15558312252', '1', '中共党员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025745, '谭风东', 'e10adc3949ba59abbe56e057f20f883e', '17823359967', '1', '中共党员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025746, '马安言', 'e10adc3949ba59abbe56e057f20f883e', '13619029376', '1', '中共党员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025747, '汤豪若', 'e10adc3949ba59abbe56e057f20f883e', '13351318722', '0', '群众', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025748, '冯邦山', 'e10adc3949ba59abbe56e057f20f883e', '17103791625', '0', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025749, '林明辉', 'e10adc3949ba59abbe56e057f20f883e', '17810172651', '0', '群众', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025750, '秦杰壮', 'e10adc3949ba59abbe56e057f20f883e', '14459156031', '1', '中共党员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025751, '石宁承', 'e10adc3949ba59abbe56e057f20f883e', '18432411004', '1', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025752, '何固振', 'e10adc3949ba59abbe56e057f20f883e', '19083405076', '1', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025753, '常富诚', 'e10adc3949ba59abbe56e057f20f883e', '18692997693', '1', '中共党员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025754, '白伦建', 'e10adc3949ba59abbe56e057f20f883e', '13416310768', '0', '群众', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025755, '孙友星', 'e10adc3949ba59abbe56e057f20f883e', '18672925625', '0', '中共党员', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025756, '汪启乐', 'e10adc3949ba59abbe56e057f20f883e', '13038790251', '0', '群众', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025757, '赖乐平', 'e10adc3949ba59abbe56e057f20f883e', '14680684418', '1', '中共党员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025758, '杨翔泰', 'e10adc3949ba59abbe56e057f20f883e', '19583891960', '1', '中共党员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025759, '姚文进', 'e10adc3949ba59abbe56e057f20f883e', '14967787761', '0', '群众', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025760, '孔乐斌', 'e10adc3949ba59abbe56e057f20f883e', '15132940095', '1', '中共党员', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025761, '袁力保', 'e10adc3949ba59abbe56e057f20f883e', '16815772249', '1', '中共党员', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025762, '罗轮振', 'e10adc3949ba59abbe56e057f20f883e', '18303212147', '1', '群众', '语言文化学院', '捷克语', 18, '25捷克语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025763, '袁敬平', 'e10adc3949ba59abbe56e057f20f883e', '14419080836', '1', '群众', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025764, '程学楠', 'e10adc3949ba59abbe56e057f20f883e', '15233626836', '1', '共青团员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025765, '邓炎行', 'e10adc3949ba59abbe56e057f20f883e', '14667182638', '1', '中共党员', '艺术学院', '音乐学', 47, '24音乐学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025766, '康海福', 'e10adc3949ba59abbe56e057f20f883e', '16573828890', '0', '中共党员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025767, '易松树', 'e10adc3949ba59abbe56e057f20f883e', '15898105446', '1', '中共党员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025768, '徐利航', 'e10adc3949ba59abbe56e057f20f883e', '16899543738', '0', '中共党员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025769, '余壮超', 'e10adc3949ba59abbe56e057f20f883e', '19008382298', '1', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025770, '唐志利', 'e10adc3949ba59abbe56e057f20f883e', '14063370307', '0', '中共党员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025771, '周辰彪', 'e10adc3949ba59abbe56e057f20f883e', '17128595437', '1', '群众', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025772, '易敬力', 'e10adc3949ba59abbe56e057f20f883e', '17872980808', '1', '群众', '语言文化学院', '翻译', 5, '24翻译1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025773, '黄世冠', 'e10adc3949ba59abbe56e057f20f883e', '15429276708', '1', '中共党员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025774, '叶邦策', 'e10adc3949ba59abbe56e057f20f883e', '19299430467', '0', '群众', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025775, '钟国航', 'e10adc3949ba59abbe56e057f20f883e', '18825688778', '1', '中共党员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025776, '陈承成', 'e10adc3949ba59abbe56e057f20f883e', '19993212856', '0', '群众', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025777, '汪壮震', 'e10adc3949ba59abbe56e057f20f883e', '14439845542', '1', '中共党员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025778, '徐伯松', 'e10adc3949ba59abbe56e057f20f883e', '15418149883', '0', '中共党员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025779, '赖安山', 'e10adc3949ba59abbe56e057f20f883e', '13986238174', '0', '共青团员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025780, '邓轮昌', 'e10adc3949ba59abbe56e057f20f883e', '18975176635', '0', '共青团员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025781, '韩坚江', 'e10adc3949ba59abbe56e057f20f883e', '16652212777', '1', '群众', '国商学院', '金融工程', 28, '25金融工程2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025782, '许健腾', 'e10adc3949ba59abbe56e057f20f883e', '18615453337', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025783, '江腾乐', 'e10adc3949ba59abbe56e057f20f883e', '19823698696', '1', '中共党员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025784, '崔之星', 'e10adc3949ba59abbe56e057f20f883e', '15111195469', '1', '群众', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025785, '沈朗以', 'e10adc3949ba59abbe56e057f20f883e', '17699425926', '0', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025786, '何旭树', 'e10adc3949ba59abbe56e057f20f883e', '17288333649', '1', '群众', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025787, '许腾清', 'e10adc3949ba59abbe56e057f20f883e', '15183506273', '0', '共青团员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025788, '万厚晨', 'e10adc3949ba59abbe56e057f20f883e', '17891616637', '0', '中共党员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025789, '魏鹏心', 'e10adc3949ba59abbe56e057f20f883e', '15289159928', '0', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025790, '刘广保', 'e10adc3949ba59abbe56e057f20f883e', '14469489182', '0', '中共党员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025791, '彭琛超', 'e10adc3949ba59abbe56e057f20f883e', '16317855391', '0', '中共党员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025792, '傅超清', 'e10adc3949ba59abbe56e057f20f883e', '19813850060', '0', '中共党员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025793, '沈亨广', 'e10adc3949ba59abbe56e057f20f883e', '14602452913', '0', '中共党员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025794, '徐军钧', 'e10adc3949ba59abbe56e057f20f883e', '15121955092', '1', '共青团员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025795, '姜龙琛', 'e10adc3949ba59abbe56e057f20f883e', '16895070803', '1', '中共党员', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025796, '杨固榕', 'e10adc3949ba59abbe56e057f20f883e', '13908749708', '0', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025797, '廖政龙', 'e10adc3949ba59abbe56e057f20f883e', '14210607514', '1', '共青团员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025798, '傅刚福', 'e10adc3949ba59abbe56e057f20f883e', '16822795680', '0', '群众', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025799, '侯轮武', 'e10adc3949ba59abbe56e057f20f883e', '17737650573', '0', '群众', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025800, '贾良仁', 'e10adc3949ba59abbe56e057f20f883e', '18610200038', '1', '群众', '语言文化学院', '法语', 10, '25法语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025801, '郝诚达', 'e10adc3949ba59abbe56e057f20f883e', '18954945855', '1', '群众', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025802, '顾勇辉', 'e10adc3949ba59abbe56e057f20f883e', '16652171186', '1', '群众', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025803, '邓榕文', 'e10adc3949ba59abbe56e057f20f883e', '18796740123', '1', '群众', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025804, '蒋有涛', 'e10adc3949ba59abbe56e057f20f883e', '18268521948', '0', '共青团员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025805, '姚林', 'e10adc3949ba59abbe56e057f20f883e', '14931256174', '1', '中共党员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025806, '林世飞', 'e10adc3949ba59abbe56e057f20f883e', '14277170068', '1', '群众', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025807, '魏栋琛', 'e10adc3949ba59abbe56e057f20f883e', '18884926009', '1', '群众', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025808, '宋宁旭', 'e10adc3949ba59abbe56e057f20f883e', '14319063843', '1', '群众', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025809, '袁勇', 'e10adc3949ba59abbe56e057f20f883e', '13097879215', '0', '中共党员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025810, '彭山兴', 'e10adc3949ba59abbe56e057f20f883e', '16988130774', '0', '中共党员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025811, '龙善', 'e10adc3949ba59abbe56e057f20f883e', '17893572051', '1', '中共党员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025812, '薛杰', 'e10adc3949ba59abbe56e057f20f883e', '18084692293', '1', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025813, '熊策江', 'e10adc3949ba59abbe56e057f20f883e', '14567005392', '1', '群众', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025814, '冯庆建', 'e10adc3949ba59abbe56e057f20f883e', '15010872093', '0', '共青团员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025815, '潘富策', 'e10adc3949ba59abbe56e057f20f883e', '13103521510', '1', '中共党员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025816, '罗江江', 'e10adc3949ba59abbe56e057f20f883e', '16869060131', '0', '中共党员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025817, '田顺思', 'e10adc3949ba59abbe56e057f20f883e', '13580449185', '1', '共青团员', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025818, '夏发中', 'e10adc3949ba59abbe56e057f20f883e', '18206993623', '0', '群众', '语言文化学院', '意大利语', 11, '24意大利语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025819, '罗俊茂', 'e10adc3949ba59abbe56e057f20f883e', '17708836456', '0', '群众', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025820, '陆维学', 'e10adc3949ba59abbe56e057f20f883e', '16604950335', '0', '共青团员', '教育学院', '小学教育', 36, '25小学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025821, '贾朋', 'e10adc3949ba59abbe56e057f20f883e', '15114528541', '0', '群众', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025822, '毛冠乐', 'e10adc3949ba59abbe56e057f20f883e', '15731489547', '0', '群众', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025823, '彭峰启', 'e10adc3949ba59abbe56e057f20f883e', '15867544800', '1', '共青团员', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025824, '邹德宏', 'e10adc3949ba59abbe56e057f20f883e', '13899945567', '0', '中共党员', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025825, '萧良超', 'e10adc3949ba59abbe56e057f20f883e', '14291062847', '0', '中共党员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025826, '苏天', 'e10adc3949ba59abbe56e057f20f883e', '19430684265', '0', '群众', '语言文化学院', '汉语言', 21, '24汉语言1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025827, '白晨彬', 'e10adc3949ba59abbe56e057f20f883e', '16563435691', '0', '共青团员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025828, '何克', 'e10adc3949ba59abbe56e057f20f883e', '13829120019', '1', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025829, '马裕波', 'e10adc3949ba59abbe56e057f20f883e', '18682359424', '0', '中共党员', '教育学院', '科学教育', 39, '24科学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025830, '杨顺', 'e10adc3949ba59abbe56e057f20f883e', '19502749161', '1', '共青团员', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025831, '苏世', 'e10adc3949ba59abbe56e057f20f883e', '18410999524', '0', '共青团员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025832, '徐辉', 'e10adc3949ba59abbe56e057f20f883e', '17284248795', '1', '中共党员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025833, '苏群轮', 'e10adc3949ba59abbe56e057f20f883e', '15701731670', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025834, '方邦朋', 'e10adc3949ba59abbe56e057f20f883e', '17774662853', '0', '共青团员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025835, '孙波龙', 'e10adc3949ba59abbe56e057f20f883e', '14403009450', '1', '中共党员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025836, '尹功祥', 'e10adc3949ba59abbe56e057f20f883e', '17685214157', '1', '中共党员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025837, '贺兴壮', 'e10adc3949ba59abbe56e057f20f883e', '17391984221', '0', '共青团员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025838, '吕健', 'e10adc3949ba59abbe56e057f20f883e', '19280773071', '1', '中共党员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025839, '龚勇岩', 'e10adc3949ba59abbe56e057f20f883e', '18806830644', '1', '中共党员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025840, '董泰', 'e10adc3949ba59abbe56e057f20f883e', '18802824874', '1', '共青团员', '语言文化学院', '商务英语', 4, '25商务英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025841, '顾海群', 'e10adc3949ba59abbe56e057f20f883e', '16992197087', '0', '中共党员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025842, '崔文新', 'e10adc3949ba59abbe56e057f20f883e', '16626321062', '1', '中共党员', '国商学院', '电子商务', 30, '25电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025843, '杨冠富', 'e10adc3949ba59abbe56e057f20f883e', '16970326673', '0', '中共党员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025844, '顾言', 'e10adc3949ba59abbe56e057f20f883e', '13799317508', '0', '群众', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025845, '潘震', 'e10adc3949ba59abbe56e057f20f883e', '16454092883', '0', '共青团员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025846, '阎弘翰', 'e10adc3949ba59abbe56e057f20f883e', '16433907492', '0', '中共党员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025847, '丁安波', 'e10adc3949ba59abbe56e057f20f883e', '16157406678', '1', '中共党员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025848, '吕全', 'e10adc3949ba59abbe56e057f20f883e', '15085559737', '1', '共青团员', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025849, '方政', 'e10adc3949ba59abbe56e057f20f883e', '16208975172', '1', '共青团员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025850, '胡东思', 'e10adc3949ba59abbe56e057f20f883e', '16200490926', '1', '群众', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025851, '何军保', 'e10adc3949ba59abbe56e057f20f883e', '15928551326', '1', '群众', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025852, '姜冠', 'e10adc3949ba59abbe56e057f20f883e', '18838057139', '0', '群众', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025853, '黄健', 'e10adc3949ba59abbe56e057f20f883e', '13566123993', '1', '共青团员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025854, '薛龙', 'e10adc3949ba59abbe56e057f20f883e', '18213841898', '1', '群众', '语言文化学院', '葡萄牙语', 14, '25葡萄牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025855, '沈钧发', 'e10adc3949ba59abbe56e057f20f883e', '18967880406', '0', '群众', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025856, '张涛', 'e10adc3949ba59abbe56e057f20f883e', '17465150910', '0', '群众', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025857, '贺有亮', 'e10adc3949ba59abbe56e057f20f883e', '15126943925', '1', '中共党员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025858, '谭思亮', 'e10adc3949ba59abbe56e057f20f883e', '18225576663', '0', '共青团员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025859, '汤海邦', 'e10adc3949ba59abbe56e057f20f883e', '19143461555', '0', '中共党员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025860, '康启', 'e10adc3949ba59abbe56e057f20f883e', '18695579856', '1', '中共党员', '语言文化学院', '西班牙语', 8, '25西班牙语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025861, '秦岩心', 'e10adc3949ba59abbe56e057f20f883e', '13924863548', '0', '共青团员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025862, '薛鸣义', 'e10adc3949ba59abbe56e057f20f883e', '17312188998', '0', '群众', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025863, '段利昌', 'e10adc3949ba59abbe56e057f20f883e', '17607819301', '0', '中共党员', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025864, '黄维福', 'e10adc3949ba59abbe56e057f20f883e', '19738866024', '0', '群众', '语言文化学院', '英语', 1, '24英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025865, '吕启辉', 'e10adc3949ba59abbe56e057f20f883e', '19568081025', '1', '中共党员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025866, '唐浩军', 'e10adc3949ba59abbe56e057f20f883e', '19143745542', '1', '共青团员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025867, '蒋弘', 'e10adc3949ba59abbe56e057f20f883e', '18618436356', '0', '共青团员', '艺术学院', '美术学', 50, '25美术学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025868, '雷德', 'e10adc3949ba59abbe56e057f20f883e', '17456581169', '1', '中共党员', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025869, '顾全', 'e10adc3949ba59abbe56e057f20f883e', '15109115282', '1', '群众', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025870, '傅国', 'e10adc3949ba59abbe56e057f20f883e', '17963960114', '1', '中共党员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025871, '熊航江', 'e10adc3949ba59abbe56e057f20f883e', '18333204918', '0', '群众', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025872, '吴茂义', 'e10adc3949ba59abbe56e057f20f883e', '13655252701', '0', '中共党员', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025873, '孔俊才', 'e10adc3949ba59abbe56e057f20f883e', '19450957331', '1', '共青团员', '艺术学院', '艺术与科技', 52, '25艺术与科技2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025874, '侯栋腾', 'e10adc3949ba59abbe56e057f20f883e', '17670915259', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025875, '石轮良', 'e10adc3949ba59abbe56e057f20f883e', '16688774228', '1', '群众', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025876, '武义勇', 'e10adc3949ba59abbe56e057f20f883e', '18048473285', '0', '中共党员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025877, '孔民富', 'e10adc3949ba59abbe56e057f20f883e', '18722024643', '1', '群众', '语言文化学院', '英语', 2, '25英语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025878, '郝弘', 'e10adc3949ba59abbe56e057f20f883e', '15282208933', '0', '群众', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025879, '范生策', 'e10adc3949ba59abbe56e057f20f883e', '16863748226', '0', '中共党员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025880, '阎海', 'e10adc3949ba59abbe56e057f20f883e', '17871336170', '0', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025881, '江厚浩', 'e10adc3949ba59abbe56e057f20f883e', '14781653477', '0', '中共党员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025882, '孙鹏胜', 'e10adc3949ba59abbe56e057f20f883e', '13009390817', '0', '群众', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025883, '余彪', 'e10adc3949ba59abbe56e057f20f883e', '18143544519', '0', '中共党员', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025884, '董以善', 'e10adc3949ba59abbe56e057f20f883e', '14642828784', '0', '中共党员', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025885, '林豪富', 'e10adc3949ba59abbe56e057f20f883e', '16921846507', '0', '群众', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025886, '罗功', 'e10adc3949ba59abbe56e057f20f883e', '19729624867', '1', '群众', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025887, '龚东', 'e10adc3949ba59abbe56e057f20f883e', '19566254181', '1', '群众', '语言文化学院', '西班牙语', 7, '24西班牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025888, '钱群言', 'e10adc3949ba59abbe56e057f20f883e', '19192205918', '0', '共青团员', '语言文化学院', '捷克语', 17, '24捷克语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025889, '乔坚超', 'e10adc3949ba59abbe56e057f20f883e', '13555625089', '1', '共青团员', '国商学院', '金融工程', 27, '24金融工程1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025890, '侯弘伯', 'e10adc3949ba59abbe56e057f20f883e', '17827023722', '0', '共青团员', '语言文化学院', '意大利语', 12, '25意大利语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025891, '罗毅才', 'e10adc3949ba59abbe56e057f20f883e', '13712825186', '0', '中共党员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025892, '曹松奇', 'e10adc3949ba59abbe56e057f20f883e', '16100465317', '0', '中共党员', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025893, '廖东胜', 'e10adc3949ba59abbe56e057f20f883e', '14493414629', '0', '共青团员', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025894, '薛泽学', 'e10adc3949ba59abbe56e057f20f883e', '19470690384', '1', '中共党员', '文化和旅游学院', '旅游管理', 44, '25旅游管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025895, '周奇明', 'e10adc3949ba59abbe56e057f20f883e', '15502385923', '0', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025896, '范广健', 'e10adc3949ba59abbe56e057f20f883e', '15309119352', '0', '中共党员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025897, '康波若', 'e10adc3949ba59abbe56e057f20f883e', '16351794664', '0', '中共党员', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025898, '阎峰琛', 'e10adc3949ba59abbe56e057f20f883e', '15902024723', '1', '共青团员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025899, '林晨心', 'e10adc3949ba59abbe56e057f20f883e', '15972318045', '0', '中共党员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025900, '叶辰', 'e10adc3949ba59abbe56e057f20f883e', '18355820634', '0', '中共党员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025901, '萧盛泽', 'e10adc3949ba59abbe56e057f20f883e', '14009729924', '1', '共青团员', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025902, '杜庆', 'e10adc3949ba59abbe56e057f20f883e', '15982483131', '0', '群众', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025903, '贾富梁', 'e10adc3949ba59abbe56e057f20f883e', '17579610459', '0', '中共党员', '艺术学院', '艺术与科技', 51, '24艺术与科技1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025904, '钱河', 'e10adc3949ba59abbe56e057f20f883e', '18170250813', '1', '群众', '文化和旅游学院', '会展经济与管理', 46, '25会展经济与管理2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025905, '胡俊栋', 'e10adc3949ba59abbe56e057f20f883e', '16018271603', '0', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025906, '金钧祥', 'e10adc3949ba59abbe56e057f20f883e', '17814903423', '1', '中共党员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025907, '卢宏山', 'e10adc3949ba59abbe56e057f20f883e', '15318720881', '0', '中共党员', '国商学院', '国际经济与贸易', 23, '24国际经济与贸易1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025908, '薛永利', 'e10adc3949ba59abbe56e057f20f883e', '16721566212', '1', '群众', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025909, '宋冠胜', 'e10adc3949ba59abbe56e057f20f883e', '13841270375', '0', '群众', '国商学院', '计算机科学与技术', 34, '25计算机科学与技术2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025910, '贾士', 'e10adc3949ba59abbe56e057f20f883e', '14490041508', '0', '中共党员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025911, '孟清', 'e10adc3949ba59abbe56e057f20f883e', '18739355561', '1', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025912, '黄风', 'e10adc3949ba59abbe56e057f20f883e', '14637382357', '1', '中共党员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025913, '沈树发', 'e10adc3949ba59abbe56e057f20f883e', '17456065028', '0', '群众', '教育学院', '小学教育', 35, '24小学教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025914, '苏龙善', 'e10adc3949ba59abbe56e057f20f883e', '14928794594', '1', '群众', '文化和旅游学院', '会展经济与管理', 45, '24会展经济与管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025915, '毛生杰', 'e10adc3949ba59abbe56e057f20f883e', '19542512314', '0', '中共党员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025916, '许中文', 'e10adc3949ba59abbe56e057f20f883e', '13948582909', '0', '中共党员', '语言文化学院', '俄语德语', 16, '25俄语德语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025917, '韩天清', 'e10adc3949ba59abbe56e057f20f883e', '15140464731', '0', '共青团员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025918, '孙坚兴', 'e10adc3949ba59abbe56e057f20f883e', '16131583987', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025919, '彭邦力', 'e10adc3949ba59abbe56e057f20f883e', '13235913461', '1', '群众', '语言文化学院', '商务英语', 3, '24商务英语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025920, '邵志', 'e10adc3949ba59abbe56e057f20f883e', '18298100150', '0', '群众', '语言文化学院', '汉语言', 22, '25汉语言2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025921, '熊树固', 'e10adc3949ba59abbe56e057f20f883e', '13540681983', '1', '群众', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025922, '韩信轮', 'e10adc3949ba59abbe56e057f20f883e', '16590056615', '1', '中共党员', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025923, '毛奇思', 'e10adc3949ba59abbe56e057f20f883e', '17344938116', '0', '共青团员', '语言文化学院', '波兰语', 20, '25波兰语2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025924, '史冠健', 'e10adc3949ba59abbe56e057f20f883e', '18243314950', '0', '中共党员', '语言文化学院', '俄语德语', 15, '24俄语德语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025925, '薛冠全', 'e10adc3949ba59abbe56e057f20f883e', '17518541278', '1', '中共党员', '教育学院', '科学教育', 40, '25科学教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025926, '黄克河', 'e10adc3949ba59abbe56e057f20f883e', '17662450023', '1', '中共党员', '国商学院', '国际商务', 26, '25国际商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025927, '杨炎峰', 'e10adc3949ba59abbe56e057f20f883e', '15919679216', '0', '中共党员', '国商学院', '跨境电子商务', 32, '25跨境电子商务2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025928, '姚榕', 'e10adc3949ba59abbe56e057f20f883e', '16511855168', '1', '群众', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025929, '赵广', 'e10adc3949ba59abbe56e057f20f883e', '14448135538', '1', '群众', '教育学院', '数学与应用数学', 42, '25数学与应用数学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025930, '田伟兴', 'e10adc3949ba59abbe56e057f20f883e', '17907878988', '0', '共青团员', '艺术学院', '美术学', 49, '24美术学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025931, '马裕', 'e10adc3949ba59abbe56e057f20f883e', '17216481209', '0', '中共党员', '语言文化学院', '法语', 9, '24法语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025932, '何士', 'e10adc3949ba59abbe56e057f20f883e', '15942232352', '1', '中共党员', '国商学院', '国际经济与贸易', 24, '25国际经济与贸易2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025933, '邵军', 'e10adc3949ba59abbe56e057f20f883e', '18954084095', '1', '共青团员', '教育学院', '数学与应用数学', 41, '24数学与应用数学1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025934, '贾新群', 'e10adc3949ba59abbe56e057f20f883e', '16647506917', '1', '共青团员', '国商学院', '跨境电子商务', 31, '24跨境电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025935, '李栋', 'e10adc3949ba59abbe56e057f20f883e', '18715874849', '1', '共青团员', '文化和旅游学院', '旅游管理', 43, '24旅游管理1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025936, '沈楠发', 'e10adc3949ba59abbe56e057f20f883e', '15774060160', '1', '中共党员', '语言文化学院', '波兰语', 19, '24波兰语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025937, '钟松振', 'e10adc3949ba59abbe56e057f20f883e', '18264269682', '1', '群众', '教育学院', '学前教育', 38, '25学前教育2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025938, '杜若江', 'e10adc3949ba59abbe56e057f20f883e', '14054582804', '1', '中共党员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025939, '李光腾', 'e10adc3949ba59abbe56e057f20f883e', '18658646416', '1', '共青团员', '国商学院', '计算机科学与技术', 33, '24计算机科学与技术1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025940, '叶承友', 'e10adc3949ba59abbe56e057f20f883e', '19023036950', '1', '中共党员', '教育学院', '学前教育', 37, '24学前教育1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025941, '陈昌', 'e10adc3949ba59abbe56e057f20f883e', '13509884583', '1', '中共党员', '语言文化学院', '葡萄牙语', 13, '24葡萄牙语1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025942, '万弘', 'e10adc3949ba59abbe56e057f20f883e', '14480474806', '1', '中共党员', '国商学院', '电子商务', 29, '24电子商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025943, '李之', 'e10adc3949ba59abbe56e057f20f883e', '18540060356', '0', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025944, '许厚广', 'e10adc3949ba59abbe56e057f20f883e', '15936873793', '0', '群众', '艺术学院', '音乐学', 48, '25音乐学2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025945, '李武信', 'e10adc3949ba59abbe56e057f20f883e', '18940059143', '0', '群众', '语言文化学院', '翻译', 6, '25翻译2班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');
INSERT INTO `t_xs` VALUES (2025946, '杨弘力', 'e10adc3949ba59abbe56e057f20f883e', '16429259852', '1', '共青团员', '国商学院', '国际商务', 25, '24国际商务1班', NULL, NULL, NULL, 1, '2025-12-13 12:00:53');

-- ----------------------------
-- Table structure for t_xs_bq
-- ----------------------------
DROP TABLE IF EXISTS `t_xs_bq`;
CREATE TABLE `t_xs_bq`  (
  `XS_XH` int NOT NULL COMMENT '学生学号',
  `BQ_ID` int NOT NULL COMMENT '标签ID',
  `CREATE_TIME` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`XS_XH`, `BQ_ID`) USING BTREE,
  INDEX `FK_XSBQ_BQ`(`BQ_ID` ASC) USING BTREE,
  CONSTRAINT `FK_XSBQ_BQ` FOREIGN KEY (`BQ_ID`) REFERENCES `t_bqzd` (`BQ_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_XSBQ_XS` FOREIGN KEY (`XS_XH`) REFERENCES `t_xs` (`XS_XH`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '学生-标签关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_xs_bq
-- ----------------------------
INSERT INTO `t_xs_bq` VALUES (2024104, 2, '2025-12-15 17:47:43');
INSERT INTO `t_xs_bq` VALUES (2024104, 9, '2025-12-15 17:47:43');
INSERT INTO `t_xs_bq` VALUES (2024104, 10, '2025-12-15 17:47:43');
INSERT INTO `t_xs_bq` VALUES (2024104, 16, '2025-12-15 17:47:43');
INSERT INTO `t_xs_bq` VALUES (2024104, 26, '2025-12-15 17:47:43');

-- ----------------------------
-- Table structure for t_xy
-- ----------------------------
DROP TABLE IF EXISTS `t_xy`;
CREATE TABLE `t_xy`  (
  `XY_MC` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院名称',
  `XY_ZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院账号',
  `XY_MM` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `FZR_XM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '负责人姓名',
  `XY_DH` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院电话',
  PRIMARY KEY (`XY_ZH`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学校各学院信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_xy
-- ----------------------------
INSERT INTO `t_xy` VALUES ('语言文化学院', '100001', 'e10adc3949ba59abbe56e057f20f883e', '张伟', '0576100001');
INSERT INTO `t_xy` VALUES ('国商学院', '100002', 'e10adc3949ba59abbe56e057f20f883e', '赵思远', '0576100002');
INSERT INTO `t_xy` VALUES ('教育学院', '100003', 'e10adc3949ba59abbe56e057f20f883e', '黄晓敏', '0576100003');
INSERT INTO `t_xy` VALUES ('文化和旅游学院', '100004', 'e10adc3949ba59abbe56e057f20f883e', '刘佳', '0576100004');
INSERT INTO `t_xy` VALUES ('艺术学院', '100005', 'e10adc3949ba59abbe56e057f20f883e', '李静怡', '0576100005');
INSERT INTO `t_xy` VALUES ('马克思主义学院', '100006', 'e10adc3949ba59abbe56e057f20f883e', '陈铭', '0576100006');

-- ----------------------------
-- Table structure for t_zy
-- ----------------------------
DROP TABLE IF EXISTS `t_zy`;
CREATE TABLE `t_zy`  (
  `ZY_BH` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '专业编号',
  `ZY_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '专业名称',
  `ZY_XK` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学科',
  `ZY_XZ` int NOT NULL COMMENT '学制',
  `XYZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院编号',
  `SS_XY` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院名称',
  PRIMARY KEY (`ZY_BH`) USING BTREE,
  INDEX `FK_ZY_XY`(`XYZH` ASC) USING BTREE,
  CONSTRAINT `FK_ZY_XY` FOREIGN KEY (`XYZH`) REFERENCES `t_xy` (`XY_ZH`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学校各专业信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_zy
-- ----------------------------
INSERT INTO `t_zy` VALUES ('01', '英语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('02', '商务英语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('03', '翻译', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('04', '西班牙语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('05', '法语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('06', '意大利语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('07', '葡萄牙语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('08', '俄语德语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('09', '捷克语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('10', '波兰语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('11', '汉语言', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('12', '国际经济与贸易', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('13', '国际商务', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('14', '金融工程', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('15', '电子商务', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('16', '跨境电子商务', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('17', '计算机科学与技术', '工学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('18', '小学教育', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('19', '学前教育', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('20', '科学教育', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('21', '数学与应用数学', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('22', '旅游管理', '管理学', 4, '100004', '文化和旅游学院');
INSERT INTO `t_zy` VALUES ('23', '会展经济与管理', '管理学', 4, '100004', '文化和旅游学院');
INSERT INTO `t_zy` VALUES ('24', '音乐学', '艺术', 4, '100005', '艺术学院');
INSERT INTO `t_zy` VALUES ('25', '美术学', '艺术', 4, '100005', '艺术学院');
INSERT INTO `t_zy` VALUES ('26', '艺术与科技', '艺术', 4, '100005', '艺术学院');

-- ----------------------------
-- Table structure for t_zyhd
-- ----------------------------
DROP TABLE IF EXISTS `t_zyhd`;
CREATE TABLE `t_zyhd`  (
  `HD_BH` int NOT NULL AUTO_INCREMENT COMMENT '活动编号',
  `HD_MC` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动名称',
  `BM_KSSJ` datetime NULL DEFAULT NULL COMMENT '报名开始时间',
  `BM_JSSJ` datetime NULL DEFAULT NULL COMMENT '报名结束时间',
  `HD_KSSJ` datetime NULL DEFAULT NULL COMMENT '活动开始时间',
  `HD_JSSJ` datetime NULL DEFAULT NULL COMMENT '活动结束时间',
  `HD_NR` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '活动内容',
  `HD_DD` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动地点',
  `ZM_RS` int NULL DEFAULT 0 COMMENT '招募人数(整数)',
  `YBM_RS` int NULL DEFAULT 0 COMMENT '已报名人数(缓存字段)',
  `BBH` int NULL DEFAULT 0 COMMENT '乐观锁版本号(VERSION)',
  `HD_BQ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动类别标签(用于匹配兴趣)',
  `JN_YQ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '技能要求标签(用于匹配技能)',
  `ZY_XZ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '专业限制(用于匹配专业,空则不限)',
  `HDXQ` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动需求条件',
  `HD_BZ` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动保障',
  `HD_FQ_DW` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动发起单位',
  `HD_ZT` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动状态：报名未开始；活动报名中；活动未开始；活动进行中；活动已结束',
  `FB_ZT` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '发布状态：未申报；已发布；已下架；待发布',
  `HD_XF` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '（预设）活动学分',
  `LL_CS` int NULL DEFAULT 0 COMMENT '点击查看详情的次数',
  `BB_CS` int NULL DEFAULT NULL COMMENT '被报名次数',
  PRIMARY KEY (`HD_BH`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '志愿活动信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_zyhd
-- ----------------------------
INSERT INTO `t_zyhd` VALUES (1, '审核评估志愿者', '2026-02-05 14:00:00', '2026-02-07 14:00:00', '2026-02-08 14:00:00', '2026-02-08 16:00:00', '保障审核评估前期工作顺利开展', '浙江外国语学院', 4, 0, 0, '校园建设', NULL, NULL, '无', '无', '教学辅助单位', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (2, '体质健康测试志愿者', '2026-01-20 08:00:00', '2026-01-22 08:00:00', '2026-01-23 08:00:00', '2026-02-03 17:00:00', '协助体育教师完成体质健康测试相关测试工作', '浙江外国语学院', 42, 0, 0, '校园建设', NULL, NULL, '无', '包一顿工作餐', '体育部', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (3, '心晴驿站新生打卡活动志愿者', '2025-12-26 11:00:00', '2025-12-28 11:00:00', '2025-12-29 11:00:00', '2026-01-02 18:00:00', '负责心晴驿站的新生引导与礼品发放', '浙江外国语学院·心晴驿站', 20, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (4, '教工气排球志愿者招募', '2025-12-18 12:00:00', '2025-12-20 12:00:00', '2025-12-21 12:00:00', '2025-12-29 14:00:00', '教工气排球赛事志愿服务（场地引导、秩序协助等）', '浙江外国语学院（校内）', 27, 0, 0, '赛会服务', NULL, NULL, '无', '无', '体育部', '报名未开始', '已发布', '0.5', 1, 0);
INSERT INTO `t_zyhd` VALUES (5, '健步走志愿者招募', '2026-03-03 08:00:00', '2026-03-05 08:00:00', '2026-03-06 08:00:00', '2026-03-06 12:00:00', '健步走活动现场志愿服务（签到引导、秩序维护、物资协助等）', '浙江外国语学院（校内）', 10, 0, 0, '赛会服务', NULL, NULL, '无', '无', '体育部', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (6, '心理访谈引导志愿者（3日）', '2026-01-05 09:00:00', '2026-01-07 09:00:00', '2026-01-08 09:00:00', '2026-01-10 20:00:00', '负责心晴驿站的引导与礼品发放', '浙江外国语学院·心晴驿站', 3, 0, 0, '校园建设', NULL, NULL, '无', '无', '教育学院', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (7, '两河会议志愿者招募', '2026-02-11 11:00:00', '2026-02-13 11:00:00', '2026-02-14 11:00:00', '2026-02-14 20:00:00', '协助会议场地布置、会议进行、路线指引等岗位', '浙江外国语学院（校内）', 17, 0, 0, '赛会服务', NULL, NULL, '无', '无', '文化和旅游学院', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (8, '心晴驿站打卡志愿者招募（第一期）', '2026-02-13 11:00:00', '2026-02-15 11:00:00', '2026-02-16 11:00:00', '2026-02-20 18:00:00', '负责心晴驿站的引导与礼品发放', '浙江外国语学院·雅正4楼下心晴驿站', 30, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (9, '迷你马拉松礼包分装志愿活动', '2025-12-20 10:00:00', '2025-12-22 10:00:00', '2025-12-23 10:00:00', '2025-12-23 12:00:00', '进行迷你马拉松礼包分装', '浙江外国语学院', 20, 0, 0, '赛会服务', NULL, NULL, '无', '无', '服务保障单位', '报名未开始', '已发布', '0.5', 1, 0);
INSERT INTO `t_zyhd` VALUES (10, '心理访谈引导志愿者（2日）', '2026-02-10 09:00:00', '2026-02-12 09:00:00', '2026-02-13 09:00:00', '2026-02-14 16:00:00', '心理访谈引导相关志愿服务', '浙江外国语学院·心晴驿站', 5, 0, 0, '校园建设', NULL, NULL, '无', '无', '教育学院', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (11, '第五届全球外国语大学联盟校长论坛暨协作组年会志愿服务', '2026-02-27 08:00:00', '2026-03-01 08:00:00', '2026-03-02 08:00:00', '2026-03-05 18:00:00', '外宾接机/抵离、信息咨询、语言服务、场内引导、嘉宾1V1接待等', '浙江外国语学院（校内及校外会场）', 118, 0, 0, '赛会服务', '英语翻译', NULL, '浙江外国语学院全日制在校生至政治立场坚定，遵纪守法至年满18周岁至形象气质良好、身心健康至沟通协调能力强，英语口语流利（非中国国籍志愿者需具备基本汉语交流能力）至可全程参加培训及活动。', '提供岗前培训', '国际交流合作处', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (12, '会议志愿者招募（2日）', '2025-12-23 09:00:00', '2025-12-25 09:00:00', '2025-12-26 09:00:00', '2025-12-27 10:00:00', '协助会议进行（签到/引导/会务协助等）', '浙江外国语学院（校内）', 6, 0, 0, '校园建设', NULL, NULL, '无', '无', '学校办公室', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (13, '运动会志愿者招募', '2026-02-02 08:00:00', '2026-02-04 08:00:00', '2026-02-05 08:00:00', '2026-02-05 18:00:00', '协助运动会进行（检录、场地秩序、物资、引导等）', '浙江外国语学院（校内）', 245, 0, 0, '赛会服务', '急救技能', NULL, '无', '无', '体育部', '报名未开始', '已发布', '0.5', 1, 0);
INSERT INTO `t_zyhd` VALUES (14, '心晴驿站打卡志愿者招募（第二期）', '2026-02-20 11:00:00', '2026-02-22 11:00:00', '2026-02-23 11:00:00', '2026-02-27 18:00:00', '负责心晴驿站的引导与礼品发放', '浙江外国语学院·雅正4楼下心晴驿站', 20, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (15, '中国拉丁美洲学会年会暨“中拉关系：新机遇、新挑战”研讨会志愿服务', '2025-12-22 08:00:00', '2025-12-24 08:00:00', '2025-12-25 08:00:00', '2025-12-26 18:00:00', '接待联系嘉宾、会场布置、入场签到等', '杭州（会议会场）', 15, 0, 0, '赛会服务', '英语翻译', '西班牙语,葡萄牙语', '无', '无', '国志协', '报名未开始', '已发布', '0.5', 5, 0);
INSERT INTO `t_zyhd` VALUES (16, '离退休人员返校活动志愿者招募', '2025-12-01 08:00:00', '2026-02-13 08:00:00', '2026-02-04 08:00:00', '2026-02-04 12:00:00', '协助开展老年趣味活动及维持秩序、校园内引导、老同志帮扶', '浙江外国语学院', 12, 0, 0, '敬老助残', NULL, NULL, '无', '无', '党群组织', '报名中', '已发布', '0.5', 14, 1);
INSERT INTO `t_zyhd` VALUES (17, '杭州某国际会议志愿服务', '2026-02-16 08:00:00', '2026-02-18 08:00:00', '2026-02-19 08:00:00', '2026-02-21 20:00:00', '外宾接待、语言协助、会场引导、信息咨询、嘉宾入住办理等', '杭州市余杭区（室内为主）', 60, 0, 0, '赛会服务', '英语翻译', '英语,法语,西班牙语,阿拉伯语', '浙江外国语学院全日制在校生至政治立场坚定，遵纪守法至年满18周岁至形象气质良好、身心健康至沟通协调能力强，能使用相应语种有效沟通至可全程参加培训及活动。优先：大型国际赛会志愿经验至党员/预备党员/团员/优秀学生骨干。', '提供岗前培训', '国志协', '报名未开始', '已发布', '0.5', 1, 0);
INSERT INTO `t_zyhd` VALUES (18, '开学典礼筹备志愿者招募', '2026-03-01 16:00:00', '2026-03-03 16:00:00', '2026-03-04 16:00:00', '2026-03-04 18:00:00', '在行健馆贴座椅背贴', '浙江外国语学院·行健馆', 40, 0, 0, '校园建设', NULL, NULL, '无', '无', '学校办公室', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (19, '开学报到润院打卡点引导互动志愿者招募', '2025-12-31 08:00:00', '2026-01-02 08:00:00', '2026-01-03 08:00:00', '2026-01-03 16:00:00', '打卡点引导、信息咨询解答、互动氛围营造、协助应急处理', '浙江外国语学院·润院', 4, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '报名未开始', '已发布', '0.5', 2, 0);
INSERT INTO `t_zyhd` VALUES (20, '铁路杭州西站志愿服务', '2026-01-06 08:00:00', '2026-01-08 18:00:00', '2026-01-09 08:00:00', '2026-01-16 16:00:00', '站内引导、咨询、秩序维护等志愿服务', '杭州西站', 10, 0, 0, '赛会服务', NULL, NULL, '着装得体（不穿奇装异服/不适合运动鞋）至仪容仪表规范（男生不留胡须，女生长发扎马尾，不染彩发，不涂有色指甲油）至性格外向，有领导能力至精神面貌良好，有一定志愿服务经历。', '提供中餐、饮用水、点心及防暑降温物资至服务满3天及以上提供交通补贴30元/天至服务满3天可开具社会实践证明至岗位均为室内。', '国志协', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (21, '全国数字贸易大赛跨境电商直播赛道总决赛志愿服务', '2026-01-12 14:00:00', '2026-01-14 14:00:00', '2026-01-15 14:00:00', '2026-01-17 18:00:00', '设备组：场地布置、设备监控与紧急维修至\n接待联络组：报到、参观引导、嘉宾与参赛者引导、答疑至\n考务组：签到抽签、候赛与比赛组织、场地引导、评委嘉宾服务至\n会务组：物料准备、赛区封闭及人员进出控制。', '浙江外国语学院（校内）', 30, 0, 0, '赛会服务', '计算机维修', '计算机科学与技术,电子商务', '无', '无', '国商学院', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (22, '迎新志愿者招募', '2026-01-31 06:00:00', '2026-02-02 06:00:00', '2026-02-03 06:00:00', '2026-02-03 19:00:00', '协助迎新工作顺利展开（站点引导、物资/行李协助、信息咨询等）', '浙江外国语学院各迎新点（屏峰地铁站、正大门、西门、西北门、小北门、行健馆、望A、各寝室楼、小推车服务点等）', 213, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (23, '世界互联网大会乌镇峰会志愿者招募', '2026-01-15 08:00:00', '2026-01-17 08:00:00', '2026-01-18 08:00:00', '2026-01-22 18:00:00', '峰会期间承担接待、引导、咨询等志愿服务', '浙江省嘉兴市桐乡乌镇', 40, 0, 0, '赛会服务', '英语翻译', NULL, '省内高校全日制在读学生至自愿参加志愿服务至遵纪守法无违法犯罪记录至18周岁以上，身心健康至可参加会前培训至服从调剂与岗位安排并遵守纪律至至少熟练运用一门外语进行交流（VIP接待外宾）。', '能开公假，食宿统一负责', '国志协', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (24, '第五届世界生物圈保护区大会志愿服务', '2026-01-24 08:00:00', '2026-01-26 08:00:00', '2026-01-27 08:00:00', '2026-02-01 18:00:00', '外宾接机/抵离、信息咨询、语言服务、场内引导、嘉宾接待等', '杭州（会场及相关点位）', 50, 0, 0, '赛会服务', '英语翻译', '法语,西班牙语', '浙江外国语学院全日制在校生至政治立场坚定、遵纪守法至年满18周岁至形象气质良好、身心健康至沟通协调能力强，英语口语流利，具备中英文写作能力（非中国国籍志愿者需较好汉语交流能力）至可全程参加培训及活动。优先：大型国际赛会志愿经验至法语/西班牙语等小语种特长至党员/预备党员/团员/优秀学生骨干至服务期间全勤。', '可请公假至提供岗前培训', '国志协', '报名未开始', '已发布', '0.5', 1, 0);
INSERT INTO `t_zyhd` VALUES (25, '学院毕业典礼志愿者招募', '2026-02-26 10:00:00', '2026-02-28 10:00:00', '2026-03-01 10:00:00', '2026-03-01 12:00:00', '整理毕业证书壳子、搬运宣传物料、布置场地、引导进场等', '浙江外国语学院（校内）', 30, 0, 0, '校园建设', NULL, NULL, '无', '无', '语言文化学院', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (26, '毕业典礼布置志愿者招募', '2025-12-27 09:00:00', '2025-12-29 09:00:00', '2025-12-30 09:00:00', '2025-12-30 12:00:00', '座椅到位后分类粘贴椅背贴，检查椅子无破损', '浙江外国语学院（校内）', 40, 0, 0, '校园建设', NULL, NULL, '无', '无', '服务保障单位', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (27, '创新创业文化节志愿服务', '2026-02-12 15:00:00', '2026-02-14 15:00:00', '2026-02-15 15:00:00', '2026-02-16 18:00:00', '摊位布置与秩序维护、游客引导与活动讲解、后勤保障工作', '浙江外国语学院（校内，具体地点另行通知）', 20, 0, 0, '校园建设', NULL, NULL, '热情开朗，有服务意识至责任心强，能按时到岗至对宋韵文化或创新创业活动感兴趣者优先。', '无', '国商学院', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (28, '三进大会志愿服务', '2025-12-24 14:00:00', '2025-12-26 14:00:00', '2025-12-27 14:00:00', '2025-12-28 18:00:00', '引导参会人员到校及校内行程指引至协助签到、礼仪、茶歇、会场布置等', '浙江外国语学院及相关酒店会场', 75, 0, 0, '赛会服务', '礼仪接待', NULL, '确保全程参与至对校园足够熟悉便于引导至服从安排、有志愿服务精神至外向灵活者优先，最好具备一定领导能力。', '无', '马克思主义学院', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (29, '三位一体活动志愿者招募', '2025-12-30 06:00:00', '2026-01-01 06:00:00', '2026-01-02 06:00:00', '2026-01-02 17:00:00', '协助三位一体活动顺利进行（考场引导、秩序维护、物资与信息协助等）', '浙江外国语学院', 72, 0, 0, '校园建设', NULL, NULL, '无', '提供岗前培训', '教务处', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (30, '简历门诊与职业规划咨询活动志愿者招募', '2026-02-21 13:00:00', '2026-02-23 13:00:00', '2026-02-24 13:00:00', '2026-02-24 16:00:00', '记录学生咨询内容并统计数量至回收导师易拉宝至活动前协助点位引导与布置至活动中待命处理临时情况。', '浙江外国语学院', 6, 0, 0, '校园建设', '新闻写作', NULL, '无', '无', '行政部门', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (31, '中国体外诊断（IVD）产业发展大会志愿服务', '2026-01-19 07:00:00', '2026-01-21 16:00:00', '2026-01-22 07:00:00', '2026-01-23 19:00:00', '咨询、指引', '杭州大会展中心及周边', 10, 0, 0, '赛会服务', '英语翻译', NULL, '英语口语流畅', '无', '国志协', '报名未开始', '已发布', '0.5', 2, 0);
INSERT INTO `t_zyhd` VALUES (32, '献血活动志愿者招募（5人）', '2026-02-22 10:00:00', '2026-02-24 10:00:00', '2026-02-25 10:00:00', '2026-02-25 13:00:00', '维持秩序、协助医护人员、发放物资', '浙江外国语学院·雅正四楼下花坛处', 5, 0, 0, '社区服务', NULL, NULL, '无', '无', '服务保障单位', '报名未开始', '已发布', '0.5', 0, 0);
INSERT INTO `t_zyhd` VALUES (33, '雷锋月姚缘社区志愿服务', '2026-01-07 13:00:00', '2026-01-09 13:00:00', '2026-01-10 13:00:00', '2026-01-10 16:00:00', '书籍整理归类与打包', '姚缘社区（杭州）', 5, 0, 0, '社区服务', NULL, NULL, '无', '无', '国志协', '报名未开始', '已发布', '0.5', 1, 0);
INSERT INTO `t_zyhd` VALUES (34, '春运铁路杭州站志愿服务', '2026-01-21 08:00:00', '2026-01-23 08:00:00', '2026-01-24 08:00:00', '2026-02-06 16:00:00', '站内引导、咨询、秩序维护等', '杭州站', 5, 0, 0, '赛会服务', NULL, NULL, '着装得体（不穿无袖/裙子/短裤/打底裤/破洞裤/花裤等，不穿凉鞋拖鞋高跟鞋等）至仪容仪表规范（前不遮眉、侧不掩耳、后不及领至男生不留胡须至女生长发马尾至不染彩发至不涂有色指甲油至不浓妆不戴多余饰品）至外向、有领导能力至精神面貌良好、有志愿服务经历。', '交通补贴30元/天至提供中餐、点心和水至服务满3天及以上可盖寒假社会实践证明章至提供暖宝宝、围巾、手套等保暖用品。', '国志协', '报名未开始', '已发布', '0.5', 69, 0);
INSERT INTO `t_zyhd` VALUES (35, '垃圾分类宣传短片拍摄志愿者招募', '2026-01-13 13:00:00', '2026-01-15 13:00:00', '2026-01-16 13:00:00', '2026-01-16 15:00:00', '参与完成“垃圾大作战”垃圾分类宣传短片拍摄', '浙江外国语学院·大操场', 20, 0, 0, '环境保护', '摄影摄像', '艺术与科技', '无', '无', '艺术学院', '报名未开始', '已发布', '0.5', 2, 0);
INSERT INTO `t_zyhd` VALUES (36, '献血活动志愿者招募（6人）', '2025-12-01 10:00:00', '2025-12-02 10:00:00', '2025-12-03 10:00:00', '2025-12-04 13:00:00', '协助献血活动开展，引导献血学生，协助医务人员工作', '浙江外国语学院·雅正四楼下花坛处', 6, 0, 0, '社区服务', NULL, NULL, '无', '无', '服务保障单位', '已结束', '已发布', '0.5', 1, 0);
INSERT INTO `t_zyhd` VALUES (37, '余杭区国际会议志愿服务', '2025-12-07 08:00:00', '2025-12-08 08:00:00', '2025-12-09 08:00:00', '2026-01-14 20:00:00', '国内外嘉宾抵离服务、信息咨询、语言服务、场内引导等志愿服务', '杭州（余杭区会场）', 50, 0, 0, '赛会服务', '英语翻译', '英语,商务英语', '年满18周岁至形象气质良好、身心健康至沟通协调能力强，英语口语流利，具备中英文写作能力（非中国国籍志愿者需具备基本汉语交流能力）至要求全勤上岗，需请假至少提前3天告知负责人。', '无', '国志协', '进行中', '已发布', '0.5', 33, 0);
INSERT INTO `t_zyhd` VALUES (38, '校友返校日1对1接待志愿者招募', '2025-12-07 09:00:00', '2025-12-08 16:00:00', '2025-12-10 09:00:00', '2025-12-10 17:00:00', '提前联络校友并确认抵离信息至引导校友参与不同活动至作为观众参与校友会活动至对接用餐至确认离校时间并收尾。', '浙江外国语学院（校内）', 35, 0, 0, '赛会服务', '礼仪接待', NULL, '无', '无', '党群组织', '已结束', '已发布', '0.5', 6, 0);

-- ----------------------------
-- Table structure for t_zyhd_bq
-- ----------------------------
DROP TABLE IF EXISTS `t_zyhd_bq`;
CREATE TABLE `t_zyhd_bq`  (
  `HD_BH` int NOT NULL COMMENT '活动编号',
  `BQ_ID` int NOT NULL COMMENT '标签ID',
  `CREATE_TIME` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`HD_BH`, `BQ_ID`) USING BTREE,
  INDEX `FK_ZYHDBQ_BQ`(`BQ_ID` ASC) USING BTREE,
  CONSTRAINT `FK_ZYHDBQ_BQ` FOREIGN KEY (`BQ_ID`) REFERENCES `t_bqzd` (`BQ_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ZYHDBQ_HD` FOREIGN KEY (`HD_BH`) REFERENCES `t_zyhd` (`HD_BH`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '活动-标签关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_zyhd_bq
-- ----------------------------
INSERT INTO `t_zyhd_bq` VALUES (1, 6, '2025-12-11 20:46:50');
INSERT INTO `t_zyhd_bq` VALUES (1, 43, '2025-12-13 20:25:18');
INSERT INTO `t_zyhd_bq` VALUES (2, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (2, 43, '2025-12-13 20:25:18');
INSERT INTO `t_zyhd_bq` VALUES (3, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (4, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (4, 40, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (5, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (5, 40, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (6, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (7, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (7, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (8, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (9, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (9, 40, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (10, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (11, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (11, 9, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (11, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (12, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (12, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (13, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (13, 11, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (13, 40, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (14, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (15, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (15, 9, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (15, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (16, 4, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (17, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (17, 9, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (17, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (18, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (18, 42, '2025-12-13 20:25:18');
INSERT INTO `t_zyhd_bq` VALUES (19, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (20, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (21, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (21, 10, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (22, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (22, 44, '2025-12-13 20:25:18');
INSERT INTO `t_zyhd_bq` VALUES (23, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (23, 9, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (23, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (24, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (24, 9, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (24, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (25, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (25, 42, '2025-12-13 20:25:18');
INSERT INTO `t_zyhd_bq` VALUES (26, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (26, 42, '2025-12-13 20:25:18');
INSERT INTO `t_zyhd_bq` VALUES (27, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (28, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (28, 39, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (28, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (29, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (30, 6, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (30, 8, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (31, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (31, 9, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (31, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (32, 1, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (33, 1, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (34, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (35, 3, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (35, 7, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (36, 1, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (37, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (37, 9, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (37, 41, '2025-12-13 20:25:13');
INSERT INTO `t_zyhd_bq` VALUES (38, 2, '2025-12-11 21:06:42');
INSERT INTO `t_zyhd_bq` VALUES (38, 39, '2025-12-11 21:06:42');

-- ----------------------------
-- Table structure for t_zyhdbmb
-- ----------------------------
DROP TABLE IF EXISTS `t_zyhdbmb`;
CREATE TABLE `t_zyhdbmb`  (
  `ID` int NOT NULL AUTO_INCREMENT,
  `XS_XH` int NULL DEFAULT NULL COMMENT '学生学号',
  `XS_XM` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '学生姓名',
  `SS_XY` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '所属学院',
  `HD_BH` int NULL DEFAULT NULL COMMENT '活动编号',
  `HD_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '已报名活动名称',
  `HD_SJ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '已报名活动的活动时间',
  `HD_DD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '已报名活动的活动点',
  `BM_ZT` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '报名状态：未审核；已审核通过；已拒绝',
  `QD_SJ` datetime NULL DEFAULT NULL COMMENT '签到时间',
  `QT_SJ` datetime NULL DEFAULT NULL COMMENT '签退时间',
  `QD_ZT` int NULL DEFAULT 0 COMMENT '考勤状态: 0-未签 1-正常 2-迟到 3-缺勤',
  `HD_SC` decimal(10, 1) NULL DEFAULT 0.0 COMMENT '参与活动时长',
  `HD_XF` decimal(10, 1) NULL DEFAULT 0.0 COMMENT '获得学分',
  `ZYZ_PJ` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '志愿者评价',
  `FZR_PF` float NULL DEFAULT 0 COMMENT '负责人对学生的评分',
  `BM_SJ` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '报名时间',
  `SH_SJ` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `SH_LY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '审核/驳回理由',
  `GJD_ZT` int NULL DEFAULT 0 COMMENT '公假单确认状态 0未确认 1已确认',
  `GJD_SJ` datetime NULL DEFAULT NULL COMMENT '公假单出具时间',
  `ZM_ZT` int NULL DEFAULT 0 COMMENT '证明确认状态 0未确认 1已确认',
  `ZM_SJ` datetime NULL DEFAULT NULL COMMENT '证明出具时间',
  `XS_PF` int NULL DEFAULT NULL COMMENT '学生对活动的评分(1-5分, 用于协同过滤)',
  PRIMARY KEY (`ID`) USING BTREE,
  INDEX `idx_zyhdbmb_hdbh`(`HD_BH` ASC) USING BTREE,
  INDEX `idx_zyhdbmb_bmzt`(`BM_ZT` ASC) USING BTREE,
  INDEX `idx_zyhdbmb_xsxh`(`XS_XH` ASC) USING BTREE,
  INDEX `idx_zyhdbmb_hd_zt`(`HD_BH` ASC, `BM_ZT` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 414 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '志愿活动报名表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_zyhdbmb
-- ----------------------------
INSERT INTO `t_zyhdbmb` VALUES (413, 2024104, '李胜男', '语言文化学院', 16, '离退休人员返校活动志愿者招募', '2026-02-04 08:00-2026-02-04 12:00', '浙江外国语学院', '已拒绝', NULL, NULL, 0, 0.0, 0.0, NULL, 0, '2025-12-15 12:07:09', NULL, '不符合', 0, NULL, 0, NULL, NULL);

-- ----------------------------
-- View structure for departments
-- ----------------------------
DROP VIEW IF EXISTS `departments`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `departments` AS select `t_bm`.`BMBH` AS `dept_id`,`t_bm`.`BMMC` AS `dept_name`,`t_bm`.`BMLX` AS `dept_type`,`t_bm`.`FZRXM` AS `manager_name`,`t_bm`.`FZRMM` AS `manager_password`,`t_bm`.`FZRDH` AS `manager_phone` from `t_bm`;

-- ----------------------------
-- View structure for majors
-- ----------------------------
DROP VIEW IF EXISTS `majors`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `majors` AS select `t_zy`.`ZYBH` AS `major_id`,`t_zy`.`ZYMC` AS `major_name`,`t_zy`.`ZYXK` AS `major_subject`,`t_zy`.`ZYXZ` AS `major_attr`,`t_zy`.`BMBH` AS `dept_id` from `t_zy`;

-- ----------------------------
-- View structure for school_officers
-- ----------------------------
DROP VIEW IF EXISTS `school_officers`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `school_officers` AS select `t_xjfzr`.`XJFZRZH` AS `officer_username`,`t_xjfzr`.`XJFZRMM` AS `officer_password`,`t_xjfzr`.`XJFZRXM` AS `officer_name` from `t_xjfzr`;

-- ----------------------------
-- View structure for students
-- ----------------------------
DROP VIEW IF EXISTS `students`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `students` AS select `t_xs`.`XSXH` AS `student_id`,`t_xs`.`XSXM` AS `student_name`,`t_xs`.`XSMM` AS `password`,`t_xs`.`LXDH` AS `phone`,`t_xs`.`XSXB` AS `gender`,`t_xs`.`ZZMM` AS `political_status`,`t_xs`.`XYBH` AS `academy_id`,`t_xs`.`BJBH` AS `class_id`,`t_xs`.`XQ_BQ` AS `interest_tags`,`t_xs`.`JN_BQ` AS `skill_tags`,`t_xs`.`GXQK` AS `bio` from `t_xs`;

-- ----------------------------
-- View structure for sys_admins
-- ----------------------------
DROP VIEW IF EXISTS `sys_admins`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `sys_admins` AS select `t_xtgly`.`XTGLYZH` AS `admin_username`,`t_xtgly`.`XTGLYMM` AS `admin_password`,`t_xtgly`.`XTGLYXM` AS `admin_name` from `t_xtgly`;

-- ----------------------------
-- View structure for view_students
-- ----------------------------
DROP VIEW IF EXISTS `view_students`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_students` AS select `t_xs`.`XS_XH` AS `student_id`,`t_xs`.`XS_XM` AS `student_name` from `t_xs`;

-- ----------------------------
-- View structure for volunteer_activity
-- ----------------------------
DROP VIEW IF EXISTS `volunteer_activity`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `volunteer_activity` AS select `t_zyhd`.`HDBH` AS `activity_id`,`t_zyhd`.`HDMC` AS `activity_name`,`t_zyhd`.`HDLX` AS `activity_type`,`t_zyhd`.`KSSJ` AS `start_time`,`t_zyhd`.`HDSC` AS `duration_hours`,`t_zyhd`.`XYRS` AS `capacity`,`t_zyhd`.`JZSJ` AS `deadline`,`t_zyhd`.`BMBH` AS `dept_id`,`t_zyhd`.`HDZT` AS `status`,`t_zyhd`.`HDDD` AS `location`,`t_zyhd`.`HDMS` AS `description`,`t_zyhd`.`HDBQ` AS `tags`,`t_zyhd`.`HDTP` AS `image_url` from `t_zyhd`;

-- ----------------------------
-- Event structure for evt_auto_update_activity_status
-- ----------------------------
DROP EVENT IF EXISTS `evt_auto_update_activity_status`;
delimiter ;;
CREATE EVENT `evt_auto_update_activity_status`
ON SCHEDULE
EVERY '1' MINUTE STARTS '2025-12-11 18:35:38'
DO BEGIN
    -- 1. 更新为 [报名中]: 当前时间 >= 报名开始时间 AND 当前时间 < 报名结束时间
    UPDATE t_zyhd 
    SET HD_ZT = '报名中' 
    WHERE NOW() >= BM_KSSJ AND NOW() < BM_JSSJ AND HD_ZT != '已下架';

    -- 2. 更新为 [待开始/准备中]: 当前时间 >= 报名结束时间 AND 当前时间 < 活动开始时间
    UPDATE t_zyhd 
    SET HD_ZT = '待开始' 
    WHERE NOW() >= BM_JSSJ AND NOW() < HD_KSSJ AND HD_ZT != '已下架';

    -- 3. 更新为 [进行中]: 当前时间 >= 活动开始时间 AND 当前时间 < 活动结束时间
    UPDATE t_zyhd 
    SET HD_ZT = '进行中' 
    WHERE NOW() >= HD_KSSJ AND NOW() < HD_JSSJ AND HD_ZT != '已下架';

    -- 4. 更新为 [已结束]: 当前时间 >= 活动结束时间
    UPDATE t_zyhd 
    SET HD_ZT = '已结束' 
    WHERE NOW() >= HD_JSSJ AND HD_ZT != '已下架';
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table t_xs
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_auto_sync_tags_insert`;
delimiter ;;
CREATE TRIGGER `trg_auto_sync_tags_insert` AFTER INSERT ON `t_xs` FOR EACH ROW BEGIN
    -- 新增学生时，如果有标签文本，直接生成关联数据
    IF (NEW.XQ_BQ IS NOT NULL OR NEW.JN_BQ IS NOT NULL) THEN
        INSERT INTO t_xs_bq (XS_XH, BQ_ID)
        SELECT 
            NEW.XS_XH, 
            t.BQ_ID
        FROM 
            t_bqzd t
        WHERE 
            FIND_IN_SET(t.BQ_MC, REPLACE(IFNULL(NEW.XQ_BQ, ''), '，', ',')) > 0
            OR 
            FIND_IN_SET(t.BQ_MC, REPLACE(IFNULL(NEW.JN_BQ, ''), '，', ',')) > 0;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table t_xs
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_auto_sync_tags_update`;
delimiter ;;
CREATE TRIGGER `trg_auto_sync_tags_update` AFTER UPDATE ON `t_xs` FOR EACH ROW BEGIN
    -- 只有当兴趣标签(XQ_BQ) 或 技能标签(JN_BQ) 发生变化时才执行，避免浪费性能
    IF NOT (NEW.XQ_BQ <=> OLD.XQ_BQ AND NEW.JN_BQ <=> OLD.JN_BQ) THEN
        
        -- 第一步：先删除该学生在关联表中的所有旧数据
        DELETE FROM t_xs_bq WHERE XS_XH = NEW.XS_XH;
        
        -- 第二步：扫描标签字典表，将匹配到的标签 ID 重新插入关联表
        INSERT INTO t_xs_bq (XS_XH, BQ_ID)
        SELECT 
            NEW.XS_XH, 
            t.BQ_ID
        FROM 
            t_bqzd t
        WHERE 
            -- 核心匹配逻辑：判断标签名是否存在于学生的文本字段中
            -- REPLACE用于兼容中文逗号，FIND_IN_SET用于精准匹配逗号分隔的字符串
            FIND_IN_SET(t.BQ_MC, REPLACE(IFNULL(NEW.XQ_BQ, ''), '，', ',')) > 0
            OR 
            FIND_IN_SET(t.BQ_MC, REPLACE(IFNULL(NEW.JN_BQ, ''), '，', ',')) > 0;
            
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table t_zyhdbmb
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_increase_signup_count_on_insert`;
delimiter ;;
CREATE TRIGGER `trg_increase_signup_count_on_insert` AFTER INSERT ON `t_zyhdbmb` FOR EACH ROW BEGIN
    -- 1) 总申请次数：任何报名（无论审核/取消）都累计
    UPDATE t_zyhd 
    SET BB_CS = COALESCE(BB_CS, 0) + 1
    WHERE HD_BH = NEW.HD_BH;

    -- 2) 已报名人数：仅统计“已审核通过”的有效报名
    IF NEW.BM_ZT = '已审核通过' THEN
        UPDATE t_zyhd 
        SET YBM_RS = YBM_RS + 1 
        WHERE HD_BH = NEW.HD_BH;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table t_zyhdbmb
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_update_signup_count_on_update`;
delimiter ;;
CREATE TRIGGER `trg_update_signup_count_on_update` AFTER UPDATE ON `t_zyhdbmb` FOR EACH ROW BEGIN
    -- 情况1: 从未审核/已拒绝 -> 已审核通过，增加人数
    IF OLD.BM_ZT != '已审核通过' AND NEW.BM_ZT = '已审核通过' THEN
        UPDATE t_zyhd 
        SET YBM_RS = YBM_RS + 1 
        WHERE HD_BH = NEW.HD_BH;
    -- 情况2: 从已审核通过 -> 未审核/已拒绝，减少人数
    ELSEIF OLD.BM_ZT = '已审核通过' AND NEW.BM_ZT != '已审核通过' THEN
        UPDATE t_zyhd 
        SET YBM_RS = GREATEST(YBM_RS - 1, 0) 
        WHERE HD_BH = NEW.HD_BH;
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table t_zyhdbmb
-- ----------------------------
DROP TRIGGER IF EXISTS `trg_decrease_signup_count_on_delete`;
delimiter ;;
CREATE TRIGGER `trg_decrease_signup_count_on_delete` AFTER DELETE ON `t_zyhdbmb` FOR EACH ROW BEGIN
    IF OLD.BM_ZT = '已审核通过' THEN
        UPDATE t_zyhd 
        SET YBM_RS = GREATEST(YBM_RS - 1, 0) 
        WHERE HD_BH = OLD.HD_BH;
    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
