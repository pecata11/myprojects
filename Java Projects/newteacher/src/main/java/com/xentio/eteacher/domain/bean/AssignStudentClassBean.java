package com.xentio.eteacher.domain.bean;

import com.xentio.eteacher.domain.StudentClass;
import com.xentio.eteacher.domain.User;

public class AssignStudentClassBean {

	private User student;
	private StudentClass studentClass;
	
	
	public AssignStudentClassBean(User student, StudentClass studentClass) {
		super();
		this.student = student;
		this.studentClass = studentClass;
	}
	public User getStudent() {
		return student;
	}
	public void setStudent(User student) {
		this.student = student;
	}
	public StudentClass getStudentClass() {
		return studentClass;
	}
	public void setStudentClass(StudentClass studentClass) {
		this.studentClass = studentClass;
	}
}
