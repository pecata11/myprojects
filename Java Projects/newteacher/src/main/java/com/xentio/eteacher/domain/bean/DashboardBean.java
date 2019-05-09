package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.List;

public class DashboardBean {
	
	private int classId;
	private List<Integer> assignmentLessonIds = new ArrayList<Integer>();
	private List<AssignmentLessonBean> assignmentLessons = new ArrayList<AssignmentLessonBean>();
	
	private String excludedStudentIds;
	
	private String sortByColumn;
	private String sortDirection;
	
	private int subjectId;
	
	private String groupId;
	
	private boolean isCellColor;
	
	public int getClassId() {
		return classId;
	}
	public void setClassId(int classId) {
		this.classId = classId;
	}
	public List<Integer> getAssignmentLessonIds() {
		return assignmentLessonIds;
	}
	public void setAssignmentLessonIds(List<Integer> assignmentLessonIds) {
		this.assignmentLessonIds = assignmentLessonIds;
	}
	public List<AssignmentLessonBean> getAssignmentLessons() {
		return assignmentLessons;
	}
	public void setAssignmentLessons(List<AssignmentLessonBean> assignmentLessons) {
		this.assignmentLessons = assignmentLessons;
	}
	public String getExcludedStudentIds() {
		return excludedStudentIds;
	}
	public void setExcludedStudentIds(String excludedStudentIds) {
		this.excludedStudentIds = excludedStudentIds;
	}
	public String getSortByColumn() {
		return sortByColumn;
	}
	public void setSortByColumn(String sortByColumn) {
		this.sortByColumn = sortByColumn;
	}
	public String getSortDirection() {
		return sortDirection;
	}
	public void setSortDirection(String sortDirection) {
		this.sortDirection = sortDirection;
	}
	public int getSubjectId() {
		return subjectId;
	}
	public void setSubjectId(int subjectId) {
		this.subjectId = subjectId;
	}
	public boolean isCellColor() {
		return isCellColor;
	}
	public void setCellColor(boolean isCellColor) {
		this.isCellColor = isCellColor;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
}