package com.university.volunteer.mapper;

import com.university.volunteer.entity.Student;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StudentMapper {
    Student findByXh(String xh);
    
    Student findById(Integer xsId);
    
    Student findByUsername(String username);
    
    Student findStudentById(Integer xsId);
    
    void updateStudent(Student student);
    
    int updateStudentProfile(Student student);
    
    int updateStudentFullInfo(Student student);
    
    int updatePassword(@Param("studentId") Integer studentId, @Param("newPassword") String newPassword);
    
    List<Student> findAll();
    
    int insertStudent(Student student);
    
    int deleteStudent(Integer xsId);
    
    List<Student> searchStudents(@Param("xh") String xh,
                                 @Param("xm") String xm,
                                 @Param("xyBh") Integer xyBh);
    
    List<Student> findStudentsByPage(@Param("keyword") String keyword);
    
    Integer existsByStudentId(Integer studentId);
    
    /**
     * 统计学生总数
     */
    int countAllStudents();
}
