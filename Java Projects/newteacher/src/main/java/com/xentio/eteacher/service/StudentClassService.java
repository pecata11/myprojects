package com.xentio.eteacher.service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xentio.eteacher.domain.StudentClass;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AssignClassBean;

@Service("studentClassService")
@Transactional
public class StudentClassService {

	@Autowired
	private SessionFactory sessionFactory;
	
	public Map<String, String> getMapClassesByTeacher(int reacherId){
		List<StudentClass> list = getClassesByTeacher(reacherId);
    	return fromListToMap(list);
	}

	private Map<String, String> fromListToMap(List<StudentClass> list) {
		Map<String, String> classes = new LinkedHashMap<String, String>();
    	for (StudentClass studentClass : list) {
    		classes.put(studentClass.getId().toString(), studentClass.getName());
		}
		return classes;
	}
	
	public Map<String, String> getMapClasses(){
		List<StudentClass> list = getClasses();
		return fromListToMap(list);
	}
	
	@SuppressWarnings("unchecked") 
	public List<StudentClass> getClasses() {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM StudentClass");
		return query.list();
	}
	
	@SuppressWarnings("unchecked") 
	public List<StudentClass> getClassesByTeacher(int teacherId) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM StudentClass where teacher.id = :teacherId");
		query.setInteger("teacherId", teacherId);
		
		return query.list();
	}
	
	public void save(StudentClass stClass) {
		Session session = sessionFactory.getCurrentSession();
		session.saveOrUpdate(stClass);
	}

	public void delete(int id) {
		Session session = sessionFactory.getCurrentSession();
		StudentClass stClass = (StudentClass) session.get(StudentClass.class, id);
		session.delete(stClass);
	}

	public StudentClass get(int id) {
		Session session = sessionFactory.getCurrentSession();
		StudentClass stClass = (StudentClass) session.get(StudentClass.class, id);
		return stClass;
	}
	
	public List<StudentClass> getClassesByStudent(int studentId, int teacherId) {
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("select clasese from StudentClass clasese left join clasese.students st where st.id = :id and  clasese.teacher.id = :teacherId");
		q.setInteger("id", studentId);
		q.setInteger("teacherId", teacherId);
		return q.list();
	}

	public List<User> getStudentByClass(int classId) {
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("select ss.students from StudentClass ss where ss.id = :id");
		q.setInteger("id", classId);
		return q.list();
	}
	
	public void addStudentToClass(AssignClassBean assignClassBean, int teacherId) {
		if(assignClassBean.getStudentsIds() == null)
			return;
		
		Session session = sessionFactory.getCurrentSession();
		
		//-----------------------------
		// remove this code when a student can be assigned to multiple classes of one teacher
		for (Integer id : assignClassBean.getStudentsIds()) {
			List<StudentClass> stClasses = getClassesByStudent(id, teacherId);
			User student = (User) session.load(User.class, id);
			for (StudentClass studentClass : stClasses) {
				studentClass.getStudents().remove(student);
			}
		}
		//-------------------------
		
		StudentClass stClass = (StudentClass) session.load(StudentClass.class, assignClassBean.getClassId());
		
		for (Integer id : assignClassBean.getStudentsIds()) {
			User student = (User) session.load(User.class, id);
			stClass.getStudents().add(student);
		}
	}
	
	public void removeStudentFromClass(AssignClassBean assignClassBean, int teacherId) {
		if(assignClassBean.getStudentsIds() == null)
			return;
		
		Session session = sessionFactory.getCurrentSession();
		
		StudentClass stClass = (StudentClass) session.load(StudentClass.class, assignClassBean.getClassId());
		
		for (Integer id : assignClassBean.getStudentsIds()) {
			User student = (User) session.load(User.class, id);
			stClass.getStudents().remove(student);
		}
	}
}
