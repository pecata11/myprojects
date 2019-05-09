package com.xentio.eteacher.domain.bean;

import com.xentio.eteacher.domain.Question;

public class AnswerAverageByQuestionBean {
	private Question question;
	private float answer;
	private int count;
	private int classId;
	private int assignmentId;
	private String sortByColumn;
	private String sortDirection;
	
	public Question getQuestion() {
		return question;
	}
	public void setQuestion(Question question) {
		this.question = question;
	}
	public float getAnswer() {
		return answer;
	}
	public void setAnswer(float answer) {
		this.answer = answer;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public int getClassId() {
		return classId;
	}
	public void setClassId(int classId) {
		this.classId = classId;
	}
	public int getAssignmentId() {
		return assignmentId;
	}
	public void setAssignmentId(int assignmentId) {
		this.assignmentId = assignmentId;
	}
	public String getSortByColumn() {
		return sortByColumn;
	}
	public void setSortByColumn(String sortByColumn) {
		this.sortByColumn = sortByColumn;
	}
	public String getSortDirection() {
		return sortDirection;
	}
	public void setSortDirection(String sortDirection) {
		this.sortDirection = sortDirection;
	}
	

}
