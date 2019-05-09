package com.xentio.eteacher.service;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StringType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xentio.eteacher.domain.Goal;
import com.xentio.eteacher.domain.GoalAssignment;
import com.xentio.eteacher.domain.bean.GoalAssignmentBean;
import com.xentio.eteacher.domain.bean.GoalBean;
import com.xentio.eteacher.domain.bean.QuizListBean;

@Service("goalService")
@Transactional
public class GoalService {
	@Autowired
	private SessionFactory sessionFactory;

	public GoalBean getGoalBean(long goalId) {
		Session session = sessionFactory.getCurrentSession();
		Goal goal = (Goal) session.load(Goal.class, goalId);
		
		GoalBean goalBean = new GoalBean();
		goalBean.setId(goal.getId());
		goalBean.setCreatorId(goal.getCreatorId());
		goalBean.setCurrAssignment(new GoalAssignmentBean());
		goalBean.setGrade(goal.getGrade());
		goalBean.setSubject(goal.getSubject());
		goalBean.setStrand(goal.getStrand());
		goalBean.setObjective(goal.getObjective());
		goalBean.setName(goal.getName());
		goalBean.setTarget("" + goal.getTarget());
		
		String sql = 
				"SELECT ga.id, ga.is_auto, ga.group_id, ga.class_id, ga.student_id, " +
				"cl.name AS class_name, CONCAT(sg.name, ' - ', sg.subjectName) group_name, CONCAT(u.first_name, ' ', u.last_name) student_name " +
				"FROM goal_assignment ga " +  
				"JOIN classes cl ON ga.class_id = cl.id " + 
				"LEFT JOIN student_group sg ON ga.group_id = sg.id " +
				"LEFT JOIN user u ON ga.student_id = u.id " +
				"WHERE ga.goal_id = :goalId AND ga.deleted=0";
		Query query = session.createSQLQuery(sql);
		query.setLong("goalId", goalId);
        query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
        List data = query.list();

		List<GoalAssignmentBean> goalAssBeans = new ArrayList<GoalAssignmentBean>();
        for(Object object : data) {			
        	GoalAssignmentBean goalAssBean = new GoalAssignmentBean();

			Map row = (Map) object;
			goalAssBean.setId(((BigInteger)row.get("id")).longValue());
			goalAssBean.setAuto((Boolean)row.get("is_auto"));
			
			BigInteger classId = (BigInteger)row.get("class_id");
			goalAssBean.setClassId(classId != null ? classId.longValue() : 0);
			
			BigInteger groupId = (BigInteger)row.get("group_id");
			goalAssBean.setGroupId(groupId != null ? groupId.longValue() : 0);
			
			BigInteger studentId = (BigInteger)row.get("student_id");
			goalAssBean.setStudentId(studentId != null ? studentId.longValue() : 0);
			
			goalAssBean.setClassName((String)row.get("class_name"));
			goalAssBean.setGroupName((String)row.get("group_name"));
			goalAssBean.setStudentName((String)row.get("student_name"));
			
			goalAssBeans.add(goalAssBean);
        }
		goalBean.setAssignments(goalAssBeans);

		
		return goalBean;
	}

	@SuppressWarnings("unchecked") 
	public List<Goal> getGoalsByUserId(long userId) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM Goal where creatorId =:userId");
		query.setLong("userId", userId);
		return query.list();
	}

	public void save(GoalBean goalBean) {
		Session session = sessionFactory.getCurrentSession();
		Goal goal = new Goal();

		goal.setSubject(goalBean.getSubject());
		goal.setGrade(goalBean.getGrade());
		goal.setStrand(goalBean.getStrand());
		goal.setObjective(goalBean.getObjective());
		goal.setCreatorId(goalBean.getCreatorId());
		goal.setCreateTime(new Date());
		goal.setName(goalBean.getName());
		goal.setTarget(Integer.parseInt(goalBean.getTarget()));

		session.saveOrUpdate(goal);

		for (GoalAssignmentBean goalAssBean : goalBean.getAssignments()) {
			GoalAssignment goalAss = new GoalAssignment();
			goalAss.setGoalId(goal.getId());
			goalAss.setClassId(goalAssBean.getClassId());
			goalAss.setGroupId(goalAssBean.getGroupId() > 0 ? goalAssBean.getGroupId() : null);
			goalAss.setStudentId(goalAssBean.getStudentId() > 0 ? goalAssBean.getStudentId() : null);
			goalAss.setIsAuto(goalAssBean.isAuto());
			goalAss.setCreateTime(new Date());

			session.save(goalAss);
		}
	}
	
	public void update(GoalBean goalBean) {
		Session session = sessionFactory.getCurrentSession();
		Goal goal = (Goal) session.get(Goal.class, goalBean.getId());
		goal.setName(goalBean.getName());
		goal.setTarget(Integer.parseInt(goalBean.getTarget()));

		//update goal name or target
		session.update(goal);

		//clean deleted assignments
		Query query = session.createQuery("FROM GoalAssignment where goalId =:goalId");
		query.setLong("goalId", goal.getId());
		List<GoalAssignment> goalAssList = query.list();
		cleanDeleted(goalBean.getAssignments(), goalAssList, session);
		
		//add newly created assignments
		for (GoalAssignmentBean goalAssBean : goalBean.getAssignments()) {
			if (goalAssBean.getId() > 0) {
				continue;
			}
			
			GoalAssignment goalAss = new GoalAssignment();
			goalAss.setGoalId(goal.getId());
			goalAss.setClassId(goalAssBean.getClassId());
			goalAss.setGroupId(goalAssBean.getGroupId() > 0 ? goalAssBean.getGroupId() : null);
			goalAss.setStudentId(goalAssBean.getStudentId() > 0 ? goalAssBean.getStudentId() : null);
			goalAss.setIsAuto(goalAssBean.isAuto());
			goalAss.setCreateTime(new Date());

			session.save(goalAss);
		}
	}
	
	public List<QuizListBean> getAutoAssignedLessons(long studentId, int limit) {
		Session session = sessionFactory.getCurrentSession();
		
		// student result by objective
		String sql = "SELECT objective, AVG(res)*100 AS avgResult FROM ( " +
		    "SELECT quiz_id, SUM(IF(is_correct = 1, 1, 0)) / COUNT(is_correct) AS res, q.objective " + 
		    "FROM student_answer sa JOIN quiz q ON q.id = sa.quiz_id " +
		    "WHERE student_id = :studentId AND q.deleted = 0 " +
		    "GROUP BY quiz_id) AS obj " +
		"GROUP BY objective";	
		
		SQLQuery query = session.createSQLQuery(sql);
		query.setLong("studentId", studentId);
        query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
        List data = query.list();

		Map<String, Double> objAvgResultMap = new HashMap<String, Double>();
        for(Object object : data) {			
			Map row = (Map) object;
			String objective = (String)row.get("objective");
			BigDecimal avgResult = (BigDecimal)row.get("avgResult");
			if(objective != null && avgResult != null) {
				objAvgResultMap.put(objective, avgResult.doubleValue());
			}
        }

        //student goal by objective
        sql = "SELECT objective, target " + 
        "FROM goal WHERE id IN " +
        "(SELECT goal_id FROM ( " +
            "SELECT goal_id " +
            "FROM goal_assignment " + 
            "WHERE student_id = :studentId AND is_auto=1 " +
            "UNION " +
            "SELECT ga.goal_id " + 
            "FROM goal_assignment ga JOIN class_student cs ON ga.class_id = cs.class_id " +
            "WHERE cs.student_id = :studentId AND is_auto=1 " +
            "UNION " +
            "SELECT  ga.goal_id " + 
            "FROM goal_assignment ga JOIN group_student gs ON ga.group_id = gs.group_id " +
            "WHERE gs.student_id = :studentId AND is_auto=1 " +
        ") AS something) " +
        "ORDER BY target";        
		
		query = session.createSQLQuery(sql);
		query.setLong("studentId", studentId);
        query.setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP);
        data = query.list();
        
        Map<String, Double> objGoalMap = new HashMap<String, Double>();
        for(Object object : data) {			
			Map row = (Map) object;
			String objective = (String)row.get("objective");
			Integer target = (Integer)row.get("target");
			if(objective != null && target != null) {
				objGoalMap.put(objective, target.doubleValue());
			}
        }
        
        //objectives where student have lower avg score than goal, or did't preformed lesson with goaled objective
        Set<String> objectives = new HashSet<String>();
        for(String objective : objGoalMap.keySet()) {
        	if(objAvgResultMap.containsKey(objective)) {
        		Double score = objAvgResultMap.get(objective);
        		Double goal = objGoalMap.get(objective);
        		if(score < goal) {
        			objectives.add(objective);
        		}
        	} else {
        		//student did't performed lesson with goaled objective
        		objectives.add(objective);
        	}
        }
        
        if(objectives.isEmpty()) {
        	return new ArrayList<QuizListBean>();
        }
        
        StringBuffer objectiveBuffer = new StringBuffer();
        Object[] objectivesArray = objectives.toArray();
        for(int i = 0; i < objectivesArray.length; i++) {
        	objectiveBuffer.append('\'' + (String)objectivesArray[i] + '\'');
        	if(i < objectivesArray.length - 1) {
        		objectiveBuffer.append(',');	
        	}
        }
        
        //select NON taken lessons for the problematic objectives
        sql = "SELECT id, name, null as assignmentId " +
        		"FROM quiz " +
        		"WHERE id NOT IN (SELECT quiz_id FROM student_answer WHERE student_id = :studentId) " +
        		"AND is_proof_read = 0 AND deleted = 0 and objective IN(" + objectiveBuffer.toString() + ") LIMIT " + limit;
        query = session.createSQLQuery(sql);
		query.setLong("studentId", studentId);

		query.addScalar("name", StringType.INSTANCE)
			.addScalar("id", org.hibernate.type.IntegerType.INSTANCE)
			.addScalar("assignmentId", org.hibernate.type.IntegerType.INSTANCE);
		
		query.setResultTransformer(Transformers.aliasToBean(QuizListBean.class));
		return query.list();
	}
	
	
	private void cleanDeleted(List<GoalAssignmentBean> goalAssBeans, List<GoalAssignment> goalAssEntities, Session session) {
		Iterator<GoalAssignment> entityIter = goalAssEntities.iterator();
		while(entityIter.hasNext()) {
			GoalAssignment g = entityIter.next();
			if(!containsAssignment(goalAssBeans, g.getId())) {
				entityIter.remove();
				session.delete(g);
			} 
		}
	}
	
	private boolean containsAssignment(List<GoalAssignmentBean> goalAssBeans, long assId) {
		for(GoalAssignmentBean goalAssBean : goalAssBeans) {
			if(goalAssBean.getId() == assId) {
				return true;
			}
		}
		return false;
	}
	
	public void delete(long id) {
		Session session = sessionFactory.getCurrentSession();
		
		Goal goal = (Goal) session.get(Goal.class, id);
		if(goal == null) 
			return;
		
		session.delete(goal);
		
		Query query = session.createQuery("UPDATE GoalAssignment SET deleted=1 WHERE goalId = :id");
		query.setParameter("id", id);
		query.executeUpdate();
	}
	
	/*
	 * Used in Goal dashboard drilldown.
	 */ 
	
	public Goal getGoalById(Long goalId) {
		Goal goal=null;
		try 
		{
			Session session = sessionFactory.getCurrentSession();
			Query query = session.createQuery("FROM Goal where id=:goalId");
			query.setParameter("goalId", goalId);
			goal = (Goal) query.uniqueResult();
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return goal;
	}
}
