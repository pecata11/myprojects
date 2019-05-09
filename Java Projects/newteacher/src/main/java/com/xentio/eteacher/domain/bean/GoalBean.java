package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.hibernate.validator.constraints.NotBlank;
import org.hibernate.validator.constraints.Range;
import org.springframework.format.annotation.NumberFormat;

public class GoalBean {

	private long id;

	@NotBlank
	private String name;
	
	@NumberFormat
	@Range(min = 1, max = 100)
	private String target;
	
	private long creatorId;
	private String grade;
	private String subject;
	private String strand;
	private String objective;
	
	private GoalAssignmentBean currAssignment = new GoalAssignmentBean();
	private List<GoalAssignmentBean> assignments = new ArrayList<GoalAssignmentBean>();

	public void cleanDeletedAssignments() {
		Iterator<GoalAssignmentBean> iter = assignments.iterator();
		while(iter.hasNext()) {
			GoalAssignmentBean goallAss = iter.next();
			if(goallAss != null && goallAss.getClassId() == 0 && goallAss.getClassName() == null) {
				iter.remove();
			}
		}
	}
	
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(long creatorId) {
		this.creatorId = creatorId;
	}

	public String getTarget() {
		return target;
	}

	public void setTarget(String target) {
		this.target = target;
	}

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

	public GoalAssignmentBean getCurrAssignment() {
		return currAssignment;
	}

	public void setCurrAssignment(GoalAssignmentBean currAssignment) {
		this.currAssignment = currAssignment;
	}

	public List<GoalAssignmentBean> getAssignments() {
		return assignments;
	}

	public void setAssignments(List<GoalAssignmentBean> assignments) {
		this.assignments = assignments;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof GoalBean) {
			return this.getId() == ((GoalBean)obj).getId();	
		}
		return false;
	}
	
	@Override
	public int hashCode(){
		return 0;
	}
}
