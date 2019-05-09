package com.xentio.eteacher.domain.bean;

import java.util.Date;

public class AssignmentLessonBean {

	private int assignmentId;
	private String lesonName;
	private Date assignmentStart;
	
	public String getLesonName() {
		return lesonName;
	}
	public void setLesonName(String lesonName) {
		this.lesonName = lesonName;
	}
	public Date getAssignmentStart() {
		return assignmentStart;
	}
	public void setAssignmentStart(Date assignmentStart) {
		this.assignmentStart = assignmentStart;
	}
	public int getAssignmentId() {
		return assignmentId;
	}
	public void setAssignmentId(int assignmentId) {
		this.assignmentId = assignmentId;
	}
}
