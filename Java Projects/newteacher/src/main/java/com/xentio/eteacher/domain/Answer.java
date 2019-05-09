package com.xentio.eteacher.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

@Entity
@Table(name = "answer")
@SQLDelete(sql="UPDATE answer SET deleted = '1' WHERE id = ?")
@Where(clause="deleted <> '1'")
public class Answer implements Serializable {
	private static final long serialVersionUID = 540148935455414960L;

	@Id
	@GeneratedValue
	private Integer id;

	@Lob
	private String text;

	@Column(name = "quiz_id", nullable = false)
	private Integer quizId;
	
	@Column(name = "is_correct", nullable = false)
	private Boolean isCorrect;
	
	@Column(name = "is_free_response")
	private Boolean isFreeResponse;

	@Lob
	private String intervention;

	@Column(nullable=false, columnDefinition="char(1) default '0'")
	private char deleted = '0';
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "question_id", nullable = false)
	private Question question;
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public Integer getQuizId() {
		return quizId;
	}

	public void setQuizId(Integer quizId) {
		this.quizId = quizId;
	}

	public Boolean getIsCorrect() {
		return isCorrect;
	}

	public void setIsCorrect(Boolean isCorrect) {
		this.isCorrect = isCorrect;
	}

	public Boolean getIsFreeResponse() {
		return isFreeResponse;
	}

	public void setIsFreeResponse(Boolean isFreeResponse) {
		this.isFreeResponse = isFreeResponse;
	}

	public String getIntervention() {
		return intervention;
	}
	
	public void setIntervention(String intervention) {
		this.intervention = intervention;
	}

	public char getDeleted() {
		return deleted;
	}

	public void setDeleted(char deleted) {
		this.deleted = deleted;
	}

	public Question getQuestion() {
		return question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}
}