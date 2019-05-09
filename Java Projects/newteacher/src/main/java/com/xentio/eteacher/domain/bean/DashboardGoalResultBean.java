package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.List;

import com.xentio.eteacher.domain.Goal;
import com.xentio.eteacher.domain.Group;

public class DashboardGoalResultBean {
	private int studentId;
	private String name;
	private List<Float> correctAnswer = new ArrayList<Float>();
	private Group group; 
	private List<String> cellColors = new ArrayList<String>();
	private List<Goal> targetGoals = new ArrayList<Goal>();
	
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

	public List<Float> getCorrectAnswer() {
		return correctAnswer;
	}
	public void setCorrectAnswer(List<Float> correctAnswer) {
		this.correctAnswer = correctAnswer;
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
	public List<Goal> getTargetGoals() {
		return targetGoals;
	}
	public void setTargetGoals(List<Goal> targetGoals) {
		this.targetGoals = targetGoals;
	}
}
