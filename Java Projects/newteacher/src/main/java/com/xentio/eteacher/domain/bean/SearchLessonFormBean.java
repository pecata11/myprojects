package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.List;

public class SearchLessonFormBean {
	private String grade;

	private String subject;

	private String strand;

	private String objective;
	
	private String searchTerm;
	
	private List<Integer> lessonIds = new ArrayList<Integer>();
	
	private boolean checkall;
	
	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getStrand() {
		return strand;
	}

	public void setStrand(String strand) {
		this.strand = strand;
	}

	public String getObjective() {
		return objective;
	}

	public void setObjective(String objective) {
		this.objective = objective;
	}

	public String getSearchTerm() {
		return searchTerm;
	}

	public void setSearchTerm(String searchTerm) {
		this.searchTerm = searchTerm;
	}

	public List<Integer> getLessonIds() {
		return lessonIds;
	}

	public void setLessonIds(List<Integer> lessonIds) {
		this.lessonIds = lessonIds;
	}

	public boolean isCheckall() {
		return checkall;
	}

	public void setCheckall(boolean checkall) {
		this.checkall = checkall;
	}

}
