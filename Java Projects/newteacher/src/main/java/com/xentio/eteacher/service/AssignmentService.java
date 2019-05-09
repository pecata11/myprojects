package com.xentio.eteacher.service;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xentio.eteacher.domain.Group;
import com.xentio.eteacher.domain.LessonAssignment;
import com.xentio.eteacher.domain.Quiz;
import com.xentio.eteacher.domain.StudentClass;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AssignmentLessonToStudentBean;

@Service("assignmentService")
@Transactional
public class AssignmentService {

	@Autowired
	private SessionFactory sessionFactory;

	@Autowired
	private QuizService quizService;
	
	@Autowired
	private StudentService studentService;

	public void createAssignmentAndAddStudents(AssignmentLessonToStudentBean assignmentBean) {
		Session session = sessionFactory.getCurrentSession();
		
		User teacher = studentService.getLoggedUser();
		if(assignmentBean.getStudentId().startsWith("c1")){ //check if it is All Students
			StudentClass stClass = (StudentClass)session.load(StudentClass.class, assignmentBean.getClassId());
			for (Integer id : assignmentBean.getLessonIds()) {
				LessonAssignment la = quizService.createLessonAssignment(id, assignmentBean.getStartDate(), teacher.getId(), assignmentBean.getIsQuiz());
				for (User student : stClass.getStudents()) {
					la.getStudents().add(student);
				}
			}
		} else if(assignmentBean.getStudentId().startsWith("g")){ //check if it is a group
			Group gr = (Group)session.load(Group.class, Integer.valueOf(assignmentBean.getStudentId().substring(1, assignmentBean.getStudentId().length())));
			for (Integer id : assignmentBean.getLessonIds()) {
				LessonAssignment la = quizService.createLessonAssignment(id, assignmentBean.getStartDate(), teacher.getId(), assignmentBean.getIsQuiz());
				for (User student : gr.getStudents()) {
					la.getStudents().add(student);
				}
			}
		} else {
			User student = (User) session.load(User.class, Integer.valueOf(assignmentBean.getStudentId()));
			for (Integer id : assignmentBean.getLessonIds()) {
				LessonAssignment la = quizService.createLessonAssignment(id, assignmentBean.getStartDate(), teacher.getId(), assignmentBean.getIsQuiz());
				la.getStudents().add(student);
			}
		}
	}

	public String clearAssignment(Integer classId, String studentId) {
		Session session = sessionFactory.getCurrentSession();
		
		User teacher = studentService.getLoggedUser();
		
		if(studentId.startsWith("c1")){ //check if it is All Students
			StudentClass stClass = (StudentClass)session.load(StudentClass.class, classId);
			List<LessonAssignment> list = getAssignmentByCreator(teacher.getId());
			for (LessonAssignment lessonAssignment : list) {
				for (User student : stClass.getStudents()) {
					lessonAssignment.getStudents().remove(student);
				}
			}
			
			return "Class " + stClass.getName() + " playlist cleared.";
		} else if(studentId.startsWith("g")){ //check if it is a group
			Group gr = (Group)session.load(Group.class, Integer.valueOf(studentId.substring(1, studentId.length())));
			List<LessonAssignment> list = getAssignmentByCreator(teacher.getId());
			for (LessonAssignment lessonAssignment : list) {
				for (User student : gr.getStudents()) {
					lessonAssignment.getStudents().remove(student);
				}
			}
			return "Group " + gr.getName() + " playlist cleared.";
		} else {
			User student = (User) session.load(User.class, Integer.valueOf(studentId));
			List<LessonAssignment> list = getAssignmentByCreator(teacher.getId());
			for (LessonAssignment lessonAssignment : list) {
				lessonAssignment.getStudents().remove(student);
			}
			return "Student " + student.getFirstName() + " " + student.getLastName() + " playlist cleared.";
		}
	}

	public List<LessonAssignment> getAssignmentByCreator(int teacherId) {
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("from LessonAssignment where creator.id = :teacherId");
		q.setInteger("teacherId", teacherId);
		
		return q.list();
	}
	
	@SuppressWarnings("unchecked") 
	public List<Quiz> getQuizzes(Integer lessonId) {
		Session session = sessionFactory.getCurrentSession();
		
		Query query = session.createQuery("FROM  Quiz where (grade,subject,strand) in (Select q.grade,q.subject,q.strand from Quiz q where q.id = :lessonId)");
		query.setInteger("lessonId", lessonId);
		
		return query.list();
	}
	
	@SuppressWarnings("unchecked") 
	public List<Quiz> getAssignedQuizzes(Integer classId, String studentId) {
		Session session = sessionFactory.getCurrentSession();
		
		if(studentId.startsWith("c1")){ //check if it is All Students
			return getAssignedQuizzesOfClasses(classId);
		} else if(studentId.startsWith("g")){ //check if it is a group
			Group gr = (Group)session.load(Group.class, Integer.valueOf(studentId.substring(1, studentId.length())));
			return getAssignedQuizzesOfGoup(gr.getId());
		} else {
			return getAssignedQuizzes(Integer.valueOf(studentId));
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<Quiz> getAssignedQuizzes(Integer studentId) {
		Session session = sessionFactory.getCurrentSession();		
		Query query = session.createQuery("SELECT q FROM Quiz q " +
				"JOIN q.assignments la " +
				"JOIN la.students las " + 
				"WHERE las.id=:studentId AND la.start < now()" +
				" AND la.id not in " +
				"(SELECT distinct a.lessonAssignment.id FROM StudentAnswer as a " +
				"WHERE a.studentId=:studentId)");
	
		query.setInteger("studentId", studentId);
		
		return query.list();
	}
	@SuppressWarnings("unchecked")
	public List<Quiz> getAssignedQuizzesOfGoup(int groupId) {
		Session session = sessionFactory.getCurrentSession();		
		Query query = session.createQuery("SELECT q FROM Quiz q " +
				"JOIN q.assignments la " +
				"JOIN la.students las " + 
				"WHERE las.id in (SELECT st.id from Group gr join gr.students st where gr.id=:groupId) " +
				" AND la.start < now() " +
				" AND la.id not in " +
				"(SELECT distinct a.lessonAssignment.id FROM StudentAnswer as a " +
				"WHERE a.studentId in (SELECT st.id from Group gr join gr.students st where gr.id=:groupId))");
	
		query.setInteger("groupId", groupId);
		
		return query.list();
	}
	@SuppressWarnings("unchecked")
	public List<Quiz> getAssignedQuizzesOfClasses(int classId) {
		Session session = sessionFactory.getCurrentSession();		
		Query query = session.createQuery("SELECT q FROM Quiz q " +
				"JOIN q.assignments la " +
				"JOIN la.students las " + 
				"WHERE las.id in (SELECT st.id from StudentClass cl join cl.students st where cl.id=:classId) " +
				" AND la.start < now() " +
				" AND la.id not in " +
				"(SELECT distinct a.lessonAssignment.id FROM StudentAnswer as a " +
				"WHERE a.studentId in (SELECT st.id from StudentClass cl join cl.students st where cl.id=:classId))");
	
		query.setInteger("classId", classId);
		
		return query.list();
	}

	@SuppressWarnings("unchecked")
	public List<Quiz> getQuizzesFromSearch(String lessonIds) {
		String lessonIdsClear = lessonIds.substring(0, lessonIds.length() - 1);
		Session session = sessionFactory.getCurrentSession();	
		Query query = session.createQuery("from Quiz where id in ("+lessonIdsClear+")");
		List<Quiz> resList = query.list();
		return resList;
	}	
}
