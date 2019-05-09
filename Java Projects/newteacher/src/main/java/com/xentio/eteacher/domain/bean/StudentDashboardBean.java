package com.xentio.eteacher.domain.bean;

public class StudentDashboardBean {

	private Integer studentId;
	private String goalName;
	private int studentAverageCompletedLessons;
	private Integer goalTarget;
	private Integer gap;
	private String color;
	
	public String getGoalName() {
		return goalName;
	}
	public void setGoalName(String goalName) {
		this.goalName = goalName;
	}
	public int getStudentAverageCompletedLessons() {
		return studentAverageCompletedLessons;
	}
	public void setStudentAverageCompletedLessons(
		int	studentAverageCompletedLessons) {
		this.studentAverageCompletedLessons = studentAverageCompletedLessons;
	}
	public Integer getGoalTarget() {
		return goalTarget;
	}
	public void setGoalTarget(Integer goalTarget) {
		this.goalTarget = goalTarget;
	}
	public Integer getStudentId() {
		return studentId;
	}
	public void setStudentId(Integer studentId) {
		this.studentId = studentId;
	}
	public Integer getGap() {
		return gap;
	}
	public void setGap(Integer gap) {
		this.gap = gap;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	
	
}
