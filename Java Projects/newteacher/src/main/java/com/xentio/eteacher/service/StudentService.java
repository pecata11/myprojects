package com.xentio.eteacher.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StringType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xentio.eteacher.domain.Answer;
import com.xentio.eteacher.domain.Goal;
import com.xentio.eteacher.domain.LessonAssignment;
import com.xentio.eteacher.domain.Role;
import com.xentio.eteacher.domain.StudentActivity;
import com.xentio.eteacher.domain.StudentAnswer;
import com.xentio.eteacher.domain.StudentClass;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AverageLessonsByGoal;
import com.xentio.eteacher.domain.bean.GoalResultBean;
import com.xentio.eteacher.domain.bean.QuizListBean;
import com.xentio.eteacher.domain.bean.StudentDashboardBean;
import com.xentio.eteacher.domain.bean.UserBean;
import com.xentio.eteacher.service.DashboardService.AverageSortLesson;
import com.xentio.eteacher.service.DashboardService.LessonSort;

@Service("studentService")
@Transactional
public class StudentService {
	protected static Logger logger = Logger.getLogger(StudentService.class);

	@Autowired
	private SessionFactory sessionFactory;

	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private StudentClassService studentClassService;

	@Autowired
	private DashboardService dashboardService;

	@SuppressWarnings("unchecked") 
	public List<User> getAll() {
		logger.warn("Retrieving all students");

		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM  User where access=2 order by firstName, lastName");

		return query.list();
	}

	public User get(Integer id) {
		Session session = sessionFactory.getCurrentSession();
		User student = (User) session.get(User.class, id);
	
		return student;
	}

	public void add(User user) {
		logger.warn("Adding new student");

		String encodedPassword = passwordEncoder.encodePassword(
				user.getPassword(), null);
		user.setPassword(encodedPassword);
		Session session = sessionFactory.getCurrentSession();
		session.save(user);
		
		StudentClass stClass = new StudentClass();	
		stClass.setTeacher(user);
    	stClass.setName("My Class");
    	studentClassService.save(stClass);
	}

	
	
	public void delete(Integer id) {
		logger.warn("Deleting existing student");

		Session session = sessionFactory.getCurrentSession();
		User user = (User) session.get(User.class, id);

		session.delete(user);
		
		Query query = session.createQuery("DELETE FROM  StudentAnswer WHERE studentId = :id");
		query.setParameter("id", id);
		query.executeUpdate();
	}

	public void edit(User user) {
		logger.warn("Editing existing student");

		Session session = sessionFactory.getCurrentSession();
		User existingStudent = (User) session.get(User.class,
				user.getId());

		existingStudent.setFirstName(user.getFirstName());
		existingStudent.setLastName(user.getLastName());
		existingStudent.setUsername(user.getUsername());
		
		String encodedPassword = passwordEncoder.encodePassword(
				user.getPassword(), null);
		existingStudent.setPassword(encodedPassword);

		session.save(existingStudent);
	}
	
	public User searchByUsername(String username) {
		User user = null;
		try {
			Session session = sessionFactory.getCurrentSession();

			Query query = session.createQuery("FROM  User where username='"
					+ username + "'");
			user = (User) query.uniqueResult();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
	
	public User searchByUserId(int userId) {
		User user = null;
		try {
			Session session = sessionFactory.getCurrentSession();

			Query query = session.createQuery("FROM  User where id=:userId");
			query.setParameter("userId", userId);
			user = (User) query.uniqueResult();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}
	
	public User getLoggedUser(){
		Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
		if(!(principal instanceof UserDetails)) {
			return null;
		}
		
		User user = searchByUsername(((UserDetails) principal).getUsername());
		return user;
	}

	public void add(UserBean userb) {
		logger.warn("Adding new student");

		String encodedPassword = passwordEncoder.encodePassword(
				userb.getPassword(), null);
		userb.setPassword(encodedPassword);
		Session session = sessionFactory.getCurrentSession();
		
		User usern = new User();
        usern.setFirstName(userb.getFirstName());
        usern.setLastName(userb.getLastName());
        usern.setPassword(userb.getPassword());
        usern.setUsername(userb.getUsername());
        session.save(usern);
        
        if(userb.getRoleId() != null){
        	usern.getRoles().add(getRole(userb.getRoleId()));
        	if(userb.getRoleId() < 4){
        		usern.setAccess(User.TEACHER_ACCESS);
        		StudentClass stClass = new StudentClass();	
        		stClass.setTeacher(usern);
            	stClass.setName("My Class");
            	studentClassService.save(stClass);
        	}
        }
        
        if(userb.getClassId()!=null)
        {
        	StudentClass stClass = (StudentClass) session.load(StudentClass.class, userb.getClassId());		
        	stClass.getStudents().add(usern);
        }
	}
	
	public void edit(UserBean userb) {
		logger.warn("Editing existing student");

		Session session = sessionFactory.getCurrentSession();
		
		User existingStudent = (User) session.get(User.class,
				userb.getId());
		existingStudent.setFirstName(userb.getFirstName());
		existingStudent.setLastName(userb.getLastName());
		existingStudent.setUsername(userb.getUsername());
		
		String encodedPassword = passwordEncoder.encodePassword(
				userb.getPassword(), null);
		
		existingStudent.setPassword(encodedPassword);
		
		session.save(existingStudent);
		
		User teacher = this.getLoggedUser();
		List <StudentClass> classes = studentClassService.getClassesByTeacher(teacher.getId());
		for (StudentClass studentClass : classes) {
			 studentClass.getStudents().remove(existingStudent);
			}
		if(userb.getClassId()!=null)
		{
			StudentClass stClass = (StudentClass) session.load(StudentClass.class, userb.getClassId());		
	        stClass.getStudents().add(existingStudent);
		}
	}
	
	public long getCompletedLessonsCount(int studentId) {
		Session session = sessionFactory.getCurrentSession();

		Query query = session.createQuery("SELECT count(distinct quizId) FROM  StudentAnswer where studentId=:studentId");
		query.setParameter("studentId", studentId);
		return (Long)query.uniqueResult();
	}
	
	public void appendTimeSpent(StudentActivity activity) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createSQLQuery("INSERT INTO student_activity(student_id, week_of_year, time_spent_mlls) VALUES(:studentId, :weekOfYear, :timeSpent) " +
				"ON DUPLICATE KEY UPDATE time_spent_mlls = " +
				"IF(week_of_year = :weekOfYear, time_spent_mlls , 0)  +  :timeSpent");
		query.setParameter("studentId", activity.getStudentId());
		query.setParameter("timeSpent", activity.getTimeSpentMlls());
		query.setParameter("weekOfYear", activity.getWeekOfYear());

		query.executeUpdate();
	}
	
	public StudentActivity getActivity(long studentId) {
		Session session = sessionFactory.getCurrentSession();
		StudentActivity studentActivity = (StudentActivity) session.get(StudentActivity.class, studentId);
	
		return studentActivity;
	}
	
	public Role getRole(int id) {
		Session session = sessionFactory.getCurrentSession();
		Role r = (Role) session.get(Role.class, id);

		return r;
	}
	
	public List<Role> getRoles() {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM  Role");

		return query.list();
	}
	
	public Map<String, String> getRolesMap() {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM  Role where id > 1");

		return mapRoles(query.list());
	}
	
	private Map<String, String> mapRoles(List<Role> list) {
		Map<String, String> classes = new LinkedHashMap<String, String>();
    	for (Role role : list) {
    		classes.put(role.getId().toString(), role.getName());
		}
		return classes;
	}
	
	@SuppressWarnings("unchecked")
	public List<StudentDashboardBean>getStudentStatistic(int studentId){

		Session session = sessionFactory.getCurrentSession();

		List<StudentDashboardBean> resList = new ArrayList<StudentDashboardBean>();

		SQLQuery q = session.createSQLQuery("SELECT DISTINCT id, name, target, objective FROM goal WHERE id IN ( " +
				"SELECT goal_id FROM goal_assignment WHERE class_id IN ( " +
				"SELECT class_id FROM class_student WHERE student_id = :studentId " +
				") AND student_id IS NULL AND deleted = 0 " +
				") OR id IN ( " +
				"SELECT goal_id FROM goal_assignment WHERE group_id IN ( " +
				"SELECT group_id FROM group_student WHERE student_id = :studentId " +
				") AND student_id IS NULL and deleted = 0 " +
				") OR id IN ( " +
				"SELECT goal_id FROM goal_assignment WHERE student_id = :studentId AND deleted = 0 " +
				")");
		q.addScalar("name", StringType.INSTANCE)
			.addScalar("id", org.hibernate.type.IntegerType.INSTANCE)
			.addScalar("target", org.hibernate.type.IntegerType.INSTANCE)
			.addScalar("objective", StringType.INSTANCE);

		q.setResultTransformer(Transformers.aliasToBean(GoalResultBean.class));

		
		q.setInteger("studentId", studentId);
		List<GoalResultBean> goalList = q.list();

		for(GoalResultBean goal : goalList)
		{
			
			float average = getAverageLessonsByGoalObjective(studentId, goal.getObjective());

			StudentDashboardBean dashBean = new StudentDashboardBean();

			dashBean.setGoalName(goal.getName());
			dashBean.setGoalTarget(goal.getTarget());
			//calculate real value to show on progress bar's.
			float realValue = 100f*average/dashBean.getGoalTarget();
			dashBean.setStudentAverageCompletedLessons(Math.round(average));
			
			if(realValue >= 80f)
				dashBean.setColor("#A2C954"); //green
				else if(realValue >= 60f && realValue < 80f)
					dashBean.setColor("#FFFF99"); //yellow
				else 
					dashBean.setColor("#FA8072"); //red
			resList.add(dashBean);
		}
		return resList;
	}

	@SuppressWarnings("unchecked")
	public float getAverageLessonsByGoalObjective(Integer studentId,String goalObjective) {

		List<LessonAssignment> lasList = dashboardService.getStudentAnswerByObjective(studentId, goalObjective);

		float totalScore = 0;
		for(LessonAssignment ls:lasList)
		{
			List<StudentAnswer> studAnswer = dashboardService.getStudentAnswer(studentId,ls.getId());
			int ans = 0;
			int correctAns = 0;
			for(StudentAnswer studentAnswer:studAnswer){
				ans++;
				if (studentAnswer.getIsCorrect())
					correctAns++;
			}
			float average = 0;
			if(ans != 0){
				average = (float) Math.round(100 * correctAns / ans);
			}
			totalScore += average;
		}
		float finalResult = totalScore / lasList.size();

		return finalResult;
	}
}