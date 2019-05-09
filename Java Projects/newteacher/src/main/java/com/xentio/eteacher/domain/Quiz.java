package com.xentio.eteacher.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

@Entity
@Table(name = "quiz")
@SQLDelete(sql="UPDATE quiz SET deleted = '1' WHERE id = ?")
@Where(clause="deleted <> '1'")
public class Quiz implements Serializable {
	private static final long serialVersionUID = 3198862993432740109L;

	@Id
	@GeneratedValue
	private Integer id;

	@Column(nullable = false)
	private String name;
	
	@Column(name = "creator_id", nullable = false)
	private Integer creatorId;

	@Column(name = "grade")
	private String grade;

	@Column(name = "subject")
	private String subject;
	
	@Column(name = "strand")
	private String strand;
	
	@Column(name = "objective")
	private String objective;

	@Lob
	@Column(name = "description")
	private String description;

	@Column(name = "entry_type")
	private Integer entryType;
	
	@Column(name="pdf_id")
	private Long pdfId;
	
	@Column(name="isntr_image_id")
	private Long instrImageId;
	
	@Column(name = "is_proof_read")
	private boolean isProofRead = true;
	
	@Column(nullable=false, columnDefinition="char(1) default '0'")
	private char deleted = '0';


	@OneToMany(cascade={CascadeType.ALL}, mappedBy="quiz")
	@OrderBy("id")
	@Where(clause="deleted <> '1'")
	private List<Question> questions = new ArrayList<Question>();
	
	@OneToMany(cascade={CascadeType.ALL}, mappedBy="lesson")
	@Fetch(FetchMode.JOIN)
	@OrderBy("id")
	private List<LessonAssignment> assignments = new ArrayList<LessonAssignment>();
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(Integer creatorId) {
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getEntryType() {
		return entryType;
	}

	public void setEntryType(Integer entryType) {
		this.entryType = entryType;
	}

	public Long getPdfId() {
		return pdfId;
	}

	public void setPdfId(Long pdfId) {
		this.pdfId = pdfId;
	}

	public Long getInstrImageId() {
		return instrImageId;
	}

	public void setInstrImageId(Long instrImageId) {
		this.instrImageId = instrImageId;
	}

	public boolean isProofRead() {
		return isProofRead;
	}

	public void setProofRead(boolean isProofRead) {
		this.isProofRead = isProofRead;
	}

	public char getDeleted() {
		return deleted;
	}

	public void setDeleted(char deleted) {
		this.deleted = deleted;
	}

	public List<Question> getQuestions() {
		return questions;
	}

	public void setQuestions(List<Question> questions) {
		this.questions = questions;
	}

	public List<LessonAssignment> getAssignments() {
		return assignments;
	}

	public void setAssignments(List<LessonAssignment> assignments) {
		this.assignments = assignments;
	}
}
