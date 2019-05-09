package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class AssignmentLessonToStudentBean {

	private int classId;
	private String studentId;
	private Date startDate;
	private List<Integer> lessonIds = new ArrayList<Integer>();
	
	private Boolean isQuiz;
	
	private Integer lessonId;
	
	public int getClassId() {
		return classId;
	}
	public void setClassId(int classId) {
		this.classId = classId;
	}

	public String getStudentId() {
		return studentId;
	}
	public void setStudentId(String studentId) {
		this.studentId = studentId;
	}

	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public List<Integer> getLessonIds() {
		return lessonIds;
	}
	public void setLessonIds(List<Integer> lessonIds) {
		this.lessonIds = lessonIds;
	}
	public Boolean getIsQuiz() {
		return isQuiz;
	}
	public void setIsQuiz(Boolean isQuiz) {
		this.isQuiz = isQuiz;
	}
	public Integer getLessonId() {
		return lessonId;
	}
	public void setLessonId(Integer lessonId) {
		this.lessonId = lessonId;
	}

}
