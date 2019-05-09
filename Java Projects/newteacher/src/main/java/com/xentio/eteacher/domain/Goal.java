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

import com.xentio.eteacher.domain.bean.GoalBean;

@Entity
@Table(name = "goal")
@SQLDelete(sql = "UPDATE goal SET deleted = '1' WHERE id = ?")
@Where(clause = "deleted <> '1'")
public class Goal implements Serializable {
	private static final long serialVersionUID = -5437597579423565176L;

	@Id
	@GeneratedValue
	private Long id;

	@Column(nullable = false)
	private String name;

	@Column(nullable = false)
	private Integer target;

	@Column(name = "creator_id", nullable = false)
	private Long creatorId;

	@Column(name = "grade", nullable = false)
	private String grade;

	@Column(name = "subject", nullable = false)
	private String subject;

	@Column(name = "strand", nullable = false)
	private String strand;

	@Column(name = "objective", nullable = false)
	private String objective;

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

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getTarget() {
		return target;
	}

	public void setTarget(Integer target) {
		this.target = target;
	}

	public Long getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Long creatorId) {
		this.creatorId = creatorId;
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

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Goal) {
			return this.getId() == ((Goal)obj).getId();	
		}
		return false;
	}
	
	@Override
	public int hashCode(){
		return 0;
	}
}