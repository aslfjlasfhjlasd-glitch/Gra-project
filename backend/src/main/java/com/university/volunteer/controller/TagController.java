package com.university.volunteer.controller;

import com.university.volunteer.common.Result;
import com.university.volunteer.entity.Tag;
import com.university.volunteer.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 标签控制器
 * 提供标签相关的API接口
 */
@RestController
@RequestMapping("/api/tags")
@CrossOrigin
public class TagController {

    @Autowired
    private TagService tagService;

    /**
     * 获取所有启用的标签
     * GET /api/tags
     */
    @GetMapping
    public Result<List<Tag>> getAllTags() {
        return tagService.getAllEnabledTags();
    }

    /**
     * 根据类型获取标签
     * GET /api/tags/type/{type}
     * @param type 标签类型 (1-兴趣类别, 2-技能)
     */
    @GetMapping("/type/{type}")
    public Result<List<Tag>> getTagsByType(@PathVariable Integer type) {
        return tagService.getTagsByType(type);
    }

    /**
     * 根据父标签ID获取子标签
     * GET /api/tags/parent/{parentId}
     */
    @GetMapping("/parent/{parentId}")
    public Result<List<Tag>> getTagsByParentId(@PathVariable Integer parentId) {
        return tagService.getTagsByParentId(parentId);
    }

    /**
     * 根据ID获取标签详情
     * GET /api/tags/{id}
     */
    @GetMapping("/{id}")
    public Result<Tag> getTagById(@PathVariable Integer id) {
        return tagService.getTagById(id);
    }

    /**
     * 创建新标签（管理员权限）
     * POST /api/tags
     */
    @PostMapping
    public Result<Tag> createTag(@RequestBody Tag tag) {
        return tagService.createTag(tag);
    }

    /**
     * 更新标签（管理员权限）
     * PUT /api/tags/{id}
     */
    @PutMapping("/{id}")
    public Result<String> updateTag(@PathVariable Integer id, @RequestBody Tag tag) {
        tag.setBqId(id);
        return tagService.updateTag(tag);
    }

    /**
     * 删除标签（管理员权限）
     * DELETE /api/tags/{id}
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteTag(@PathVariable Integer id) {
        return tagService.deleteTag(id);
    }

    /**
     * 增加标签热度
     * POST /api/tags/{id}/hotness
     */
    @PostMapping("/{id}/hotness")
    public Result<String> increaseHotness(@PathVariable Integer id) {
        return tagService.increaseTagHotness(id);
    }
}