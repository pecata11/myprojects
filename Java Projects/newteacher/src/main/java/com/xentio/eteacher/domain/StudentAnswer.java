package com.xentio.eteacher.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.Lob;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "student_answer")
public class StudentAnswer implements Serializable {
	private static final long serialVersionUID = 3160643862075365191L;

	@Id
	@GeneratedValue
	private Integer id;

	@Column(name = "student_id", nullable = false)
	private Integer studentId;
	
	@Column(name = "quiz_id", nullable = false)
	private Integer quizId;

	@Column(name = "question_id", nullable = false)
	private Integer questionId;
	
	@Column(name = "answer_id", nullable = false)
	private Integer answerId;

	@Column(name = "is_correct", nullable = false)
	private Boolean isCorrect;

	@Column(name = "perform_time", nullable = false)
	private Date performTime;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "lesson_assignment_id", nullable = true)
	private LessonAssignment lessonAssignment;
	
	@Lob
	@Column(name = "free_response")
	private String freeResponse;
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getStudentId() {
		return studentId;
	}

	public void setStudentId(Integer studentId) {
		this.studentId = studentId;
	}

	public Integer getQuizId() {
		return quizId;
	}

	public void setQuizId(Integer quizId) {
		this.quizId = quizId;
	}

	public Integer getQuestionId() {
		return questionId;
	}

	public void setQuestionId(Integer questionId) {
		this.questionId = questionId;
	}

	public Integer getAnswerId() {
		return answerId;
	}

	public void setAnswerId(Integer answerId) {
		this.answerId = answerId;
	}

	public Boolean getIsCorrect() {
		return isCorrect;
	}

	public void setIsCorrect(Boolean isCorrect) {
		this.isCorrect = isCorrect;
	}

	public Date getPerformTime() {
		return performTime;
	}

	public void setPerformTime(Date performTime) {
		this.performTime = performTime;
	}

	public LessonAssignment getLessonAssignment() {
		return lessonAssignment;
	}

	public void setLessonAssignment(LessonAssignment lessonAssignment) {
		this.lessonAssignment = lessonAssignment;
	}

	public String getFreeResponse() {
		return freeResponse;
	}

	public void setFreeResponse(String freeResponse) {
		this.freeResponse = freeResponse;
	}
	

}
