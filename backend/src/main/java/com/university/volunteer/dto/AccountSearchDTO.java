package com.university.volunteer.dto;

/**
 * 账号搜索DTO
 * 用于管理员搜索和分页查询账号
 */
public class AccountSearchDTO {
    private String keyword;       // 搜索关键词（姓名或学号/工号）
    private Integer page;         // 页码
    private Integer size;         // 每页大小
    private String accountType;   // "student" or "department_head"

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }
}