package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.List;

import com.xentio.eteacher.domain.Group;

public class DashboardResultBean {
	private int studentId;
	private String name;
	private float studentGrowth;
	private List<Float> correctAnswer = new ArrayList<Float>();
	private Group group; 
	private String color;
	private List<String> cellColors = new ArrayList<String>();
	
	private int lessonId;
	
	private int classId;
	
	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public float getStudentGrowth() {
		return studentGrowth;
	}
	public void setStudentGrowth(float studentGrowth) {
		this.studentGrowth = studentGrowth;
	}
	public List<Float> getCorrectAnswer() {
		return correctAnswer;
	}
	public void setCorrectAnswer(List<Float> correctAnswer) {
		this.correctAnswer = correctAnswer;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public List<String> getCellColors() {
		return cellColors;
	}
	public void setCellColors(List<String> cellColors) {
		this.cellColors = cellColors;
	}
	public Group getGroup() {
		return group;
	}
	public void setGroup(Group group) {
		this.group = group;
	}
	public int getClassId() {
		return classId;
	}
	public void setClassId(int classId) {
		this.classId = classId;
	}
	public int getLessonId() {
		return lessonId;
	}
	public void setLessonId(int lessonId) {
		this.lessonId = lessonId;
	}
}
