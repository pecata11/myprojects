package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.List;

public class AssignClassBean {

	private int classId;
	private boolean checkall;

	private List<Integer> studentsIds = new ArrayList<Integer>();
	
	public AssignClassBean() {
	}

	public List<Integer> getStudentsIds() {
		return studentsIds;
	}

	public void setStudentsIds(List<Integer> studentsIds) {
		this.studentsIds = studentsIds;
	}

	public int getClassId() {
		return classId;
	}

	public void setClassId(int classId) {
		this.classId = classId;
	}

	public boolean isCheckall() {
		return checkall;
	}

	public void setCheckall(boolean checkall) {
		this.checkall = checkall;
	}
}
