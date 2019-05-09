package com.xentio.eteacher.domain.bean;

import com.xentio.eteacher.domain.Answer;

public class QuestionAverageByAnswerBean {
	private Answer answer;
	private float answerVal;
	private int count;
	private Boolean correct;
	private String freeResponse;
	private String firstStudentName;
	
	public Answer getAnswer() {
		return answer;
	}
	public void setAnswer(Answer answer) {
		this.answer = answer;
	}
	public float getAnswerVal() {
		return answerVal;
	}
	public void setAnswerVal(float answerVal) {
		this.answerVal = answerVal;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public Boolean getCorrect() {
		return correct;
	}
	public void setCorrect(Boolean correct) {
		this.correct = correct;
	}
	public String getFreeResponse() {
		return freeResponse;
	}
	public void setFreeResponse(String freeResponse) {
		this.freeResponse = freeResponse;
	}
	public String getFirstStudentName() {
		return firstStudentName;
	}
	public void setFirstStudentName(String firstStudentName) {
		this.firstStudentName = firstStudentName;
	}
	
}
