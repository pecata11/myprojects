package com.xentio.eteacher.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "hint_log")
public class HintLog {

	@Id
	@GeneratedValue
	private Integer id;
	
	@Column(name = "student_id", nullable = false)
	private Integer studentId;
	
	@Column(name = "quiz_id", nullable = false)
	private Integer quizId;

	@Column(name = "question_id", nullable = false)
	private Integer questionId;
	
	@Column(name = "assignment_id", nullable = false)
	private Integer assignmentId;

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

	public Integer getAssignmentId() {
		return assignmentId;
	}

	public void setAssignmentId(Integer assignmentId) {
		this.assignmentId = assignmentId;
	}
}
