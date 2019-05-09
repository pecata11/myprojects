package com.xentio.eteacher.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "student_activity")
public class StudentActivity implements Serializable {
	private static final long serialVersionUID = -8720570898970074069L;

	@Id
	@Column(name = "student_id", nullable = false)
	private Long studentId;

	@Column(name = "week_of_year", nullable = false)
	private Integer weekOfYear;

	@Column(name = "time_spent_mlls", nullable = false)
	private Long timeSpentMlls;
	

	public Long getStudentId() {
		return studentId;
	}

	public void setStudentId(Long studentId) {
		this.studentId = studentId;
	}

	public Long getTimeSpentMlls() {
		return timeSpentMlls;
	}

	public void setTimeSpentMlls(Long timeSpentMlls) {
		this.timeSpentMlls = timeSpentMlls;
	}

	public Integer getWeekOfYear() {
		return weekOfYear;
	}

	public void setWeekOfYear(Integer weekOfYear) {
		this.weekOfYear = weekOfYear;
	}

}
