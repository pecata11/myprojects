package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.List;

import com.xentio.eteacher.domain.Goal;
import com.xentio.eteacher.domain.Group;

public class DashStudentResults {
	private int studentId;
	private String name;
	private List<DashStudentResult> results = new ArrayList<DashStudentResult>();

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
	public List<DashStudentResult> getResults() {
		return results;
	}
	public void setResults(List<DashStudentResult> results) {
		this.results = results;
	}
}