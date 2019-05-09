package com.xentio.eteacher.domain.bean;

import com.xentio.eteacher.domain.Answer;
import com.xentio.eteacher.domain.Question;
import com.xentio.eteacher.domain.StudentAnswer;

public class DashboardQuestAnsBean {
	private Question question;
	private StudentAnswer stAnswer;
	private Answer answer;
	private Answer correctAnswerOfQuestion;
	
	public Question getQuestion() {
		return question;
	}
	public void setQuestion(Question question) {
		this.question = question;
	}
	public StudentAnswer getStAnswer() {
		return stAnswer;
	}
	public void setStAnswer(StudentAnswer stAnswer) {
		this.stAnswer = stAnswer;
	}
	public Answer getAnswer() {
		return answer;
	}
	public void setAnswer(Answer answer) {
		this.answer = answer;
	}
	public Answer getCorrectAnswerOfQuestion() {
		return correctAnswerOfQuestion;
	}
	public void setCorrectAnswerOfQuestion(Answer correctAnswerOfQuestion) {
		this.correctAnswerOfQuestion = correctAnswerOfQuestion;
	}
	
}
