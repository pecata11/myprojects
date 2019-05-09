package com.xentio.eteacher.domain.bean;

import com.xentio.eteacher.domain.Goal;

public class DashStudentResult {
	private Goal goal;
	private String result;
	private String color;
	public Goal getGoal() {
		return goal;
	}
	public void setGoal(Goal goal) {
		this.goal = goal;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public boolean getHasResult() {
		return !result.equals("N/A");
	}
}