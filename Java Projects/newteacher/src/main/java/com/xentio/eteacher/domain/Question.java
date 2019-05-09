package com.xentio.eteacher.domain;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;

import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

@Entity
@Table(name = "question")
@SQLDelete(sql="UPDATE question SET deleted = '1' WHERE id = ?")
@Where(clause="deleted <> '1'")
public class Question implements Serializable {
	private static final long serialVersionUID = -893136733165240837L;

	@Id
	@GeneratedValue
	private Integer id;

	@Lob
	private String text;

	@Column(name = "image_id")
	private Long imageId;
	
	@Column(nullable=false, columnDefinition="char(1) default '0'")
	private char deleted = '0';
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "quiz_id", nullable = false)
	private Quiz quiz;
	
	@OneToMany(cascade={CascadeType.ALL}, mappedBy="question")
	@OrderBy("id")
	@Where(clause="deleted <> '1'")
	private List<Answer> answers = new ArrayList<Answer>();
	
	@Lob
	private String hint;
	
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

	public Long getImageId() {
		return imageId;
	}

	public void setImageId(Long imageId) {
		this.imageId = imageId;
	}

	public char getDeleted() {
		return deleted;
	}

	public void setDeleted(char deleted) {
		this.deleted = deleted;
	}

	public Quiz getQuiz() {
		return quiz;
	}

	public void setQuiz(Quiz quiz) {
		this.quiz = quiz;
	}

	public List<Answer> getAnswers() {
		return answers;
	}

	public void setAnswers(List<Answer> answers) {
		this.answers = answers;
	}

	public String getHint() {
		return hint;
	}

	public void setHint(String hint) {
		this.hint = hint;
	}
}
