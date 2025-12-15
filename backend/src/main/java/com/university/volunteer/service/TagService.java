package com.university.volunteer.service;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.Tag;
import com.university.volunteer.mapper.TagMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 标签服务类
 * 提供标签的增删改查和管理功能
 */
@Service
public class TagService {

    @Autowired
    private TagMapper tagMapper;

    /**
     * 获取所有启用的标签
     */
    public Result<List<Tag>> getAllEnabledTags() {
        try {
            List<Tag> tags = tagMapper.findAllEnabled();
            return Result.success(tags);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取标签列表失败: " + e.getMessage());
        }
    }

    /**
     * 根据类型获取标签
     * @param type 标签类型 (1-兴趣类别, 2-技能)
     */
    public Result<List<Tag>> getTagsByType(Integer type) {
        try {
            if (type == null || (type != 1 && type != 2)) {
                return Result.error("标签类型参数错误");
            }
            List<Tag> tags = tagMapper.findByType(type);
            return Result.success(tags);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取标签列表失败: " + e.getMessage());
        }
    }

    /**
     * 根据父标签ID获取子标签
     */
    public Result<List<Tag>> getTagsByParentId(Integer parentId) {
        try {
            if (parentId == null) {
                return Result.error("父标签ID不能为空");
            }
            List<Tag> tags = tagMapper.findByParentId(parentId);
            return Result.success(tags);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取子标签列表失败: " + e.getMessage());
        }
    }

    /**
     * 根据ID获取标签详情
     */
    public Result<Tag> getTagById(Integer tagId) {
        try {
            if (tagId == null) {
                return Result.error("标签ID不能为空");
            }
            Tag tag = tagMapper.findById(tagId);
            if (tag == null) {
                return Result.error("标签不存在");
            }
            return Result.success(tag);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("获取标签详情失败: " + e.getMessage());
        }
    }

    /**
     * 创建新标签（管理员权限）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<Tag> createTag(Tag tag) {
        try {
            // 验证必填字段
            if (tag.getBqMc() == null || tag.getBqMc().trim().isEmpty()) {
                return Result.error("标签名称不能为空");
            }
            if (tag.getBqLx() == null || (tag.getBqLx() != 1 && tag.getBqLx() != 2)) {
                return Result.error("标签类型必须为1(兴趣)或2(技能)");
            }

            // 设置默认值
            if (tag.getZt() == null) {
                tag.setZt(1); // 默认启用
            }
            if (tag.getRd() == null) {
                tag.setRd(0); // 默认热度为0
            }

            int rows = tagMapper.insert(tag);
            if (rows > 0) {
                return Result.success(tag);
            } else {
                return Result.error("创建标签失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("创建标签失败: " + e.getMessage());
        }
    }

    /**
     * 更新标签（管理员权限）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> updateTag(Tag tag) {
        try {
            if (tag.getBqId() == null) {
                return Result.error("标签ID不能为空");
            }

            int rows = tagMapper.update(tag);
            if (rows > 0) {
                return Result.success("标签更新成功");
            } else {
                return Result.error("标签更新失败，标签不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("标签更新失败: " + e.getMessage());
        }
    }

    /**
     * 删除标签（逻辑删除，管理员权限）
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> deleteTag(Integer tagId) {
        try {
            if (tagId == null) {
                return Result.error("标签ID不能为空");
            }

            int rows = tagMapper.delete(tagId);
            if (rows > 0) {
                return Result.success("标签删除成功");
            } else {
                return Result.error("标签删除失败，标签不存在");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("标签删除失败: " + e.getMessage());
        }
    }

    /**
     * 增加标签热度
     */
    @Transactional(rollbackFor = Exception.class)
    public Result<String> increaseTagHotness(Integer tagId) {
        try {
            if (tagId == null) {
                return Result.error("标签ID不能为空");
            }

            int rows = tagMapper.updateHotness(tagId, 1);
            if (rows > 0) {
                return Result.success("标签热度更新成功");
            } else {
                return Result.error("标签热度更新失败");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("标签热度更新失败: " + e.getMessage());
        }
    }
}