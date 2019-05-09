package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.List;


public class SearchResultBean {

	private String quizName;

	private String creatorName;

	private Integer lessonId;
	
	private List<Integer> lessonIds = new ArrayList<Integer>();

	public String getQuizName() {
		return quizName;
	}

	public void setQuizName(String quizName) {
		this.quizName = quizName;
	}



	public String getCreatorName() {
		return creatorName;
	}

	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}

	public Integer getLessonId() {
		return lessonId;
	}

	public void setLessonId(Integer lessonId) {
		this.lessonId = lessonId;
	}

	public List<Integer> getLessonIds() {
		return lessonIds;
	}

	public void setLessonIds(List<Integer> lessonIds) {
		this.lessonIds = lessonIds;
	}

}
