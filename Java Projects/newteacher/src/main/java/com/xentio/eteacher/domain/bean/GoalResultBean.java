package com.xentio.eteacher.domain.bean;

public class GoalResultBean {
	private int id;	
	private String name;
	private int target;
	private String objective;

	public GoalResultBean(){
		
	}
	
	public GoalResultBean(int id, String name, int target) {
		super();
		this.id = id;
		this.name = name;
		this.target = target;
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
	public int getTarget() {
		return target;
	}
	public void setTarget(int target) {
		this.target = target;
	}
	public String getObjective() {
		return objective;
	}
	public void setObjective(String objective) {
		this.objective = objective;
	}
}