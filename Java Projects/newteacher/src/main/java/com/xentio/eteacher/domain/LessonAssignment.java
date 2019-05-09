package com.xentio.eteacher.domain;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "lessonassignment")
public class LessonAssignment {

	@Id
	@GeneratedValue
	private Integer id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "lesson_id", nullable = false)
	private Quiz lesson; 	

	@Column(name = "start_date")
	private Date start;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "creator_id", nullable = false)
	private User creator;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "lessonassignment_student", joinColumns = { 
			@JoinColumn(name = "lessonassignment_id", nullable = false, updatable = false) }, 
			inverseJoinColumns = { @JoinColumn(name = "student_id", 
					nullable = false, updatable = false) })
	private Set<User> students = new HashSet<User>(0);
	
	@OneToMany(mappedBy="lessonAssignment")
	private Set<StudentAnswer> studentAnswers = new HashSet<StudentAnswer>(0);
	
	@Column(name = "is_quiz", nullable = false)
	private Boolean isQuiz;
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Quiz getLesson() {
		return lesson;
	}

	public void setLesson(Quiz lesson) {
		this.lesson = lesson;
	}

	public User getCreator() {
		return creator;
	}

	public void setCreator(User creator) {
		this.creator = creator;
	}

	public Date getStart() {
		return start;
	}

	public void setStart(Date start) {
		this.start = start;
	}

	public Set<User> getStudents() {
		return students;
	}

	public void setStudents(Set<User> students) {
		this.students = students;
	}

	public Set<StudentAnswer> getStudentAnswers() {
		return studentAnswers;
	}

	public void setStudentAnswers(Set<StudentAnswer> studentAnswers) {
		this.studentAnswers = studentAnswers;
	}

	public Boolean getIsQuiz() {
		return isQuiz;
	}

	public void setIsQuiz(Boolean isQuiz) {
		this.isQuiz = isQuiz;
	}
}
