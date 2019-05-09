package com.xentio.eteacher.domain.bean;

public class AnswerBean {

	private int id;
	private String text;
	private boolean isSelected;
	private boolean isCorrect;
	private boolean isDeleted;
	private String intervention;
	
	private boolean isFreeResponse;
	private String studentFreeResponse;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public boolean isSelected() {
		return isSelected;
	}

	public void setSelected(boolean isSelected) {
		this.isSelected = isSelected;
	}

	public boolean isCorrect() {
		return isCorrect;
	}

	public void setCorrect(boolean isCorrect) {
		this.isCorrect = isCorrect;
	}

	public boolean isFreeResponse() {
		return isFreeResponse;
	}

	public void setFreeResponse(boolean isFreeResponse) {
		this.isFreeResponse = isFreeResponse;
	}

	public boolean isDeleted() {
		return isDeleted;
	}

	public void setDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}

	public String getStudentFreeResponse() {
		return studentFreeResponse;
	}

	public void setStudentFreeResponse(String studentFreeResponse) {
		this.studentFreeResponse = studentFreeResponse;
	}
	
	public String getIntervention() {
		return intervention;
	}
	
	public void setIntervention(String intervention) {
		this.intervention = intervention;
	}
}
