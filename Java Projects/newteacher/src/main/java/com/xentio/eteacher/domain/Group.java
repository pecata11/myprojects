package com.xentio.eteacher.domain;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "student_group")
public class Group implements Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue
	private Integer id;

	@Column(nullable = false)
	private String name;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "teacher_id", nullable = false)
	private User teacher;

	@Column
	private Integer subjectId;
	
	@Column
	private String subjectName;
	
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "group_student", joinColumns = { 
			@JoinColumn(name = "group_id", nullable = false, updatable = false) }, 
			inverseJoinColumns = { @JoinColumn(name = "student_id", 
					nullable = false, updatable = false) })
	private Set<User> students = new HashSet<User>(0);
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "class_id", nullable = false)
	private StudentClass studentClass;


	public Integer getId() {
		return id;
	}


	public void setId(Integer id) {
		this.id = id;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public User getTeacher() {
		return teacher;
	}


	public void setTeacher(User teacher) {
		this.teacher = teacher;
	}


	public Set<User> getStudents() {
		return students;
	}


	public void setStudents(Set<User> students) {
		this.students = students;
	}


	public StudentClass getStudentClass() {
		return studentClass;
	}


	public void setStudentClass(StudentClass studentClass) {
		this.studentClass = studentClass;
	}


	public Integer getSubjectId() {
		return subjectId;
	}


	public void setSubjectId(Integer subjectId) {
		this.subjectId = subjectId;
	}


	public String getSubjectName() {
		return subjectName;
	}


	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}
}