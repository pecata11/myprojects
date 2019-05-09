package com.xentio.eteacher.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

@Entity
@Table(name = "goal_assignment")
@SQLDelete(sql = "UPDATE goal_assignment SET deleted = '1' WHERE id = ?")
@Where(clause = "deleted <> '1'")
public class GoalAssignment implements Serializable {
	private static final long serialVersionUID = 4227088704483295721L;

	@Id
	@GeneratedValue
	private Long id;

	@Column(name = "goal_id", nullable = false)
	private Long goalId;

	@Column(name = "class_id", nullable = false)
	private Long classId;

	@Column(name = "group_id")
	private Long groupId;
	
	@Column(name = "student_id")
	private Long studentId;

	@Column(name = "is_auto", nullable = false)
	private Boolean isAuto;
	
	@Column(name = "create_time", nullable = false)
	private Date createTime;
	
	@Column(nullable=false, columnDefinition="char(1) default '0'")
	private char deleted = '0';
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getGoalId() {
		return goalId;
	}

	public void setGoalId(Long goalId) {
		this.goalId = goalId;
	}

	public Long getClassId() {
		return classId;
	}

	public void setClassId(Long classId) {
		this.classId = classId;
	}

	public Long getGroupId() {
		return groupId;
	}

	public void setGroupId(Long groupId) {
		this.groupId = groupId;
	}

	public Long getStudentId() {
		return studentId;
	}

	public void setStudentId(Long studentId) {
		this.studentId = studentId;
	}

	public Boolean getIsAuto() {
		return isAuto;
	}

	public void setIsAuto(Boolean isAuto) {
		this.isAuto = isAuto;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public char getDeleted() {
		return deleted;
	}

	public void setDeleted(char deleted) {
		this.deleted = deleted;
	}
	
}