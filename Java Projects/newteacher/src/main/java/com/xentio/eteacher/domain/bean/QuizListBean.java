package com.xentio.eteacher.domain.bean;


public class QuizListBean {

	private int id;	
	private String name;
	private Integer assignmentId;
	
	public QuizListBean(){
		
	}
	
	public QuizListBean(int id, String name, Integer assignmentId) {
		super();
		this.id = id;
		this.name = name;
		this.assignmentId = assignmentId;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getAssignmentId() {
		return assignmentId;
	}
	public void setAssignmentId(Integer assignmentId) {
		this.assignmentId = assignmentId;
	}
}
