package com.xentio.eteacher.domain.bean;

import com.xentio.eteacher.domain.Quiz;

public class AverageLessonsByGoal {

	private int studentId;
	private int assignmentId;
	private String lessonName;
	private float averageResult;

	
	public String getLessonName() {
		return lessonName;
	}
	public void setLessonName(String lessonName) {
		this.lessonName = lessonName;
	}
	public float getAverageResult() {
		return averageResult;
	}
	public void setAverageResult(float averageResult) {
		this.averageResult = averageResult;
	}
	
	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
	public int getAssignmentId() {
		return assignmentId;
	}
	public void setAssignmentId(int assignmentId) {
		this.assignmentId = assignmentId;
	}
	
}
