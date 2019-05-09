package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;

public class QuestionBean {
	private int id; 
	private int quizId;
	private String text;
	
	private boolean hasFreeResponse;
	private String freeResponsePrompt;
	private String hint;
	
	private CroppableImage image = new CroppableImage();
	
	private List<AnswerBean> answers = new ArrayList<AnswerBean>();

	private String error;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getQuizId() {
		return quizId;
	}

	public void setQuizId(int quizId) {
		this.quizId = quizId;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getFreeResponsePrompt() {
		return freeResponsePrompt;
	}

	public void setFreeResponsePrompt(String freeResponsePrompt) {
		this.freeResponsePrompt = freeResponsePrompt;
	}

	public boolean isHasFreeResponse() {
		return hasFreeResponse;
	}

	public void setHasFreeResponse(boolean hasFreeResponse) {
		this.hasFreeResponse = hasFreeResponse;
	}

	public CroppableImage getImage() {
		return image;
	}

	public void setImage(CroppableImage image) {
		this.image = image;
	}

	public List<AnswerBean> getAnswers() {
		return answers;
	}

	public void setAnswers(List<AnswerBean> answers) {
		this.answers = answers;
	}
	
	public String getError() {
		return error;
	}

	public void setError(String error) {
		this.error = error;
	}

	public boolean hasMarkedAnswer() {
		boolean hasMarked = false;
		int countNonFreeResponse = 0;
		for(AnswerBean answerBean : answers) {
			if(!answerBean.isFreeResponse()) {
				countNonFreeResponse++;
				if(answerBean.isSelected()) {
					hasMarked = true;	
				}
			}
		}
		
		return countNonFreeResponse == 0 || hasMarked;
	}
	
	private void cleanDeleted() {
		Iterator<AnswerBean> aIter = answers.iterator();
		while(aIter.hasNext()) {
			AnswerBean answer= aIter.next();
			if(answer == null || answer.isDeleted()) {
				aIter.remove();
			}
		}
	}
	
	public boolean validateCreate(int entryType) {
		cleanDeleted();
		error = null;
		boolean hasErrors = false;
		
		if (entryType == QuizBean.MANUAL_TYPE && StringUtils.isBlank(text)) {
			setError("Please Enter a Question.");
			hasErrors = true;
		}
		
		if(entryType == QuizBean.IMAGE_TYPE && image.getPdfImageId() <= 0 && image.getImageId() <= 0) {
			hasErrors = true;
			error = "Please choose an image.";
		}
		
		if(hasFreeResponse) {//skip rest validation if has free response
			return !hasErrors;
		}
		
		int notEmptyAnswerCount = 0;
		boolean hasSelectedNotEmptyAnswer = false;
		for (AnswerBean answer : answers) {
			if(answer!= null && (entryType == QuizBean.IMAGE_TYPE || StringUtils.isNotBlank(answer.getText()))) {
				if(answer.isSelected()) {
					hasSelectedNotEmptyAnswer = true;
				}
				notEmptyAnswerCount ++;
			}
		}
		
		if(notEmptyAnswerCount < 2) {
			hasErrors = true;
			if(error == null) {
				setError("At least 2 answers required.");
			}
		}
		if(!hasSelectedNotEmptyAnswer) {
			hasErrors = true;
			if(error == null) {
				setError("Please designate a correct answer.");
			}
		}
		
		return !hasErrors;
	}

	public String getHint() {
		return hint;
	}

	public void setHint(String hint) {
		this.hint = hint;
	}
}
