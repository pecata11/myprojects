package com.xentio.eteacher.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xentio.eteacher.domain.Answer;
import com.xentio.eteacher.domain.Goal;
import com.xentio.eteacher.domain.GoalAssignment;
import com.xentio.eteacher.domain.Group;
import com.xentio.eteacher.domain.LessonAssignment;
import com.xentio.eteacher.domain.Question;
import com.xentio.eteacher.domain.Quiz;
import com.xentio.eteacher.domain.StudentAnswer;
import com.xentio.eteacher.domain.StudentClass;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AnswerAverageByQuestionBean;
import com.xentio.eteacher.domain.bean.AssignmentLessonBean;
import com.xentio.eteacher.domain.bean.AverageLessonsByGoal;
import com.xentio.eteacher.domain.bean.DashboardBean;
import com.xentio.eteacher.domain.bean.DashboardGoalResultBean;
import com.xentio.eteacher.domain.bean.DashboardQuestAnsBean;
import com.xentio.eteacher.domain.bean.DashboardResultBean;
import com.xentio.eteacher.domain.bean.GoalBean;
import com.xentio.eteacher.domain.bean.QuestionAverageByAnswerBean;

@Service("dashboardService")
@Transactional
public class DashboardService {

	public static String LITERACY = "literacy"; // id = 1
	public static String MATH = "math"; // id = 2

	@Autowired
	private SessionFactory sessionFactory;
	
	@Autowired
	private StudentService studentService;

	@Autowired
	private StudentClassService studentClassService;
	
	public List<AssignmentLessonBean> getQuizAndLessonAssingment(int classId,
			int subjectId) {
		Session session = sessionFactory.getCurrentSession();

		List<LessonAssignment> las;

		if (classId < 1) {
			return new ArrayList<AssignmentLessonBean>();
		} else {
			Query q = session
					.createQuery("select distinct las from Quiz q "
							+ " join q.assignments las "
							+ " join las.studentAnswers sans where sans.studentId in "
							+ " (select st.id from StudentClass clasese left join clasese.students st where clasese.id = :classId) and "
							+ " lower(q.subject) =:subject");
			q.setInteger("classId", classId);
			q.setString("subject", subjectId == 1 ? LITERACY : MATH);
			las = q.list();
		}

		List<AssignmentLessonBean> assignmentLessons = new ArrayList<AssignmentLessonBean>();
		for (LessonAssignment la : las) {
			AssignmentLessonBean a = new AssignmentLessonBean();
			a.setLesonName(la.getLesson().getName());
			a.setAssignmentId(la.getId());
			a.setAssignmentStart(la.getStart());

			assignmentLessons.add(a);
		}

		return assignmentLessons;
	}

	public List<AssignmentLessonBean> getQuizAndLessonAssingment(
			List<Integer> assignmentIds) {
		List<AssignmentLessonBean> assignmentLessons = new ArrayList<AssignmentLessonBean>();
		if (assignmentIds == null || assignmentIds.isEmpty()) {
			return assignmentLessons;
		}
		StringBuilder sb = new StringBuilder();
		for (Iterator<Integer> iterator = assignmentIds.iterator(); iterator
				.hasNext();) {
			Integer id = (Integer) iterator.next();
			sb.append(id);
			if (iterator.hasNext())
				sb.append(",");
		}

		Session session = sessionFactory.getCurrentSession();

		Query q = session.createQuery("from LessonAssignment where id in ("
				+ sb.toString() + ") order by id");
		List<LessonAssignment> las = q.list();

		for (LessonAssignment la : las) {
			AssignmentLessonBean a = new AssignmentLessonBean();
			a.setLesonName(la.getLesson().getName());
			a.setAssignmentId(la.getId());
			a.setAssignmentStart(la.getStart());

			assignmentLessons.add(a);
		}

		return assignmentLessons;
	}

	public List<DashboardResultBean> getStudentGrowth(
			DashboardBean dashboardBean) {
		List<Integer> assIds = dashboardBean.getAssignmentLessonIds();
		String excludedStudentIds = dashboardBean.getExcludedStudentIds();
		int classId = dashboardBean.getClassId();

		List<DashboardResultBean> zbeans = new ArrayList<DashboardResultBean>();
		if (assIds == null || assIds.isEmpty()) {
			return zbeans;
		}
		StringBuilder sb = new StringBuilder();
		for (Iterator<Integer> iterator = assIds.iterator(); iterator.hasNext();) {
			Integer id = (Integer) iterator.next();
			sb.append(id);
			if (iterator.hasNext())
				sb.append(",");
		}

		StringBuffer sbQuery = new StringBuffer(
				"select distinct studentId from StudentAnswer where lessonAssignment.id in ("
						+ sb.toString()
						+ ") and studentId in (select st.id from StudentClass clasese left join clasese.students st where clasese.id = :classId) ");
		if (StringUtils.isNotBlank(excludedStudentIds)) {
			sbQuery.append(" and studentId not in(" + excludedStudentIds + ")");
		}
		Session session = sessionFactory.getCurrentSession();

		Query q = session.createQuery(sbQuery.toString());
		q.setInteger("classId", classId);
		List<Integer> stIds = q.list();

		for (Integer sId : stIds) {
			DashboardResultBean b = new DashboardResultBean();
			User student = (User) session.get(User.class, sId);
			b.setName(student.getFirstName() + " " + student.getLastName());
			b.setStudentId(sId);

			Query qGroup = session
					.createQuery("select gr from Group gr left join gr.students sts where sts.id = :stId and gr.studentClass.id = :classId and gr.subjectId = :subjectId");
			qGroup.setInteger("classId", classId);
			qGroup.setInteger("stId", sId);
			qGroup.setInteger("subjectId", dashboardBean.getSubjectId());

			Group group = (Group) qGroup.uniqueResult();
			b.setGroup(group);
			b.setClassId(classId);

			for (Integer assId : assIds) {
				List<StudentAnswer> anss = getStudentAnswer(sId, assId);
				float ansN = 0;
				float correctAns = 0;
				for (StudentAnswer studentAnswer : anss) {
					//set last question Id for lessons assignment 
					b.setLessonId(studentAnswer.getQuizId());
					
					ansN++;
					if (studentAnswer.getIsCorrect())
						correctAns++;
				}
				Float tempResult = (ansN == 0 ? null : (float) Math.round(100
						* correctAns / ansN));
				b.getCorrectAnswer().add(tempResult);
			}

			float gr = calculateGrowth(b);

			b.setStudentGrowth(Math.round(gr));
			zbeans.add(b);
		}

		Comparator<DashboardResultBean> comp;
		if ("growth".equals(dashboardBean.getSortByColumn())) {
			comp = new GrowthSort(dashboardBean.getSortDirection());
		} else if ("name".equals(dashboardBean.getSortByColumn())) {
			comp = new NameSort(dashboardBean.getSortDirection());
		} else if ("group".equals(dashboardBean.getSortByColumn())) {
			comp = new GroupSort(dashboardBean.getSortDirection());
		} else if (StringUtils.isNotBlank(dashboardBean.getSortByColumn())
				&& StringUtils.isNumeric(dashboardBean.getSortByColumn())) {
			comp = new ResultFloatSort(Integer.valueOf(dashboardBean
					.getSortByColumn()), dashboardBean.getSortDirection());
		} else {
			comp = new DefaultSort();
		}

		Collections.sort(zbeans, comp);

		return zbeans;
	}

	class DefaultSort implements Comparator<DashboardResultBean> {

		private float getLastValue(DashboardResultBean a) {
			for (int i = a.getCorrectAnswer().size() - 1; i >= 0; i--)
				if (a.getCorrectAnswer().get(i) != null) {
					return a.getCorrectAnswer().get(i);
				}
			return -101;
		}

		public int compare(DashboardResultBean a, DashboardResultBean b) {

			float aVal = getLastValue(a);
			float bVal = getLastValue(b);

			int com = Float.compare(bVal, aVal);
			if (com == 0) {
				return Float
						.compare(b.getStudentGrowth(), a.getStudentGrowth());
			}
			return com;
		}
	}

	class ResultFloatSort implements Comparator<DashboardResultBean> {

		private int columnNumber;
		private String direction;

		public ResultFloatSort(int columnNumber, String direction) {
			super();
			this.columnNumber = columnNumber;
			this.direction = direction;
		}

		private float getLastValue(DashboardResultBean a) {
			if (columnNumber <= a.getCorrectAnswer().size()
					&& a.getCorrectAnswer().get(columnNumber) != null) {

				return a.getCorrectAnswer().get(columnNumber);
			}
			return -101;
		}

		public int compare(DashboardResultBean a, DashboardResultBean b) {

			float aVal = getLastValue(a);
			float bVal = getLastValue(b);

			int com = "up".equals(direction) ? Float.compare(bVal, aVal)
					: Float.compare(aVal, bVal);
			if (com == 0) {
				return Float
						.compare(b.getStudentGrowth(), a.getStudentGrowth());
			}
			return com;
		}
	}

	class NameSort implements Comparator<DashboardResultBean> {
		private String direction;

		public NameSort(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(DashboardResultBean a, DashboardResultBean b) {

			int com = "up".equals(direction) ? b.getName().compareToIgnoreCase(
					a.getName()) : a.getName().compareToIgnoreCase(b.getName());
			if (com == 0) {
				return Float
						.compare(b.getStudentGrowth(), a.getStudentGrowth());
			}
			return com;
		}
	}

	class GroupSort implements Comparator<DashboardResultBean> {
		private String direction;

		public GroupSort(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(DashboardResultBean a, DashboardResultBean b) {

			int com = "up".equals(direction) ? b.getGroup().getName()
					.compareToIgnoreCase(a.getGroup().getName()) : a.getGroup()
					.getName().compareToIgnoreCase(b.getGroup().getName());
			if (com == 0) {
				return Float
						.compare(b.getStudentGrowth(), a.getStudentGrowth());
			}
			return com;
		}
	}

	class GrowthSort implements Comparator<DashboardResultBean> {
		private String direction;

		public GrowthSort(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(DashboardResultBean a, DashboardResultBean b) {
			float a1 = a.getStudentGrowth() != -1 ? a.getStudentGrowth() : -101;
			float b1 = b.getStudentGrowth() != -1 ? b.getStudentGrowth() : -101;

			return "up".equals(direction) ? Float.compare(b1, a1) : Float
					.compare(a1, b1);
		}
	}

	public void calculateAverage(List<DashboardResultBean> list) {
		DashboardResultBean average = new DashboardResultBean();
		average.setName("Average");

		List<Float> avAnswers = new ArrayList<Float>();

		for (DashboardResultBean drBean : list) {
			for (int i = 0; i < drBean.getCorrectAnswer().size(); i++) {
				if (avAnswers.size() <= i) {
					avAnswers.add(0f);
				}

				float f = avAnswers.get(i)
						+ (drBean.getCorrectAnswer().get(i) != null ? drBean
								.getCorrectAnswer().get(i) : 0);
				avAnswers.set(i, f);
			}
		}

		for (int i = 0; i < avAnswers.size(); i++) {
			int numberStudents = 0;
			for (int j = 0; j < list.size(); j++) {
				DashboardResultBean drBean = list.get(j);
				if (drBean.getCorrectAnswer().size() > i
						&& drBean.getCorrectAnswer().get(i) != null)
					numberStudents++;
			}
			avAnswers.set(i,
					(float) Math.round(avAnswers.get(i) / numberStudents));
		}

		average.setCorrectAnswer(avAnswers);
		float gr = calculateGrowth(average);
		average.setStudentGrowth(Math.round(gr));

		list.add(average);
	}

	private float calculateGrowth(DashboardResultBean b) {
		float gr = -1;
		if (b.getCorrectAnswer().size() > 1) {
			int indexBegin = -1;
			int indexEnd = -1;
			for (int i = 0; i < b.getCorrectAnswer().size(); i++) {
				if (b.getCorrectAnswer().get(i) != null && indexBegin == -1) {
					indexBegin = i;
				}
				int inx = b.getCorrectAnswer().size() - i - 1;
				if (b.getCorrectAnswer().get(inx) != null && indexEnd == -1) {
					indexEnd = inx;
				}
			}

			if (indexBegin != indexEnd && indexBegin != -1 && indexEnd != -1) {
				gr = b.getCorrectAnswer().get(indexEnd)
						- b.getCorrectAnswer().get(indexBegin);
			}
		}
		return gr;
	}

	public List<StudentAnswer> getStudentAnswer(int studentId, int assignmentId) {
		Session session = sessionFactory.getCurrentSession();

		Query q = session
				.createQuery("from StudentAnswer where studentId = :studentId and lessonAssignment.id = :assignmentId");
		q.setInteger("studentId", studentId);
		q.setInteger("assignmentId", assignmentId);
		return q.list();
	}

	public List<DashboardQuestAnsBean> getStudentAnswerForDashBoard(
			int studentId, int assignmentId) {
		Session session = sessionFactory.getCurrentSession();

		Query q = session
				.createQuery("from StudentAnswer where studentId = :studentId and lessonAssignment.id = :assignmentId");
		q.setInteger("studentId", studentId);
		q.setInteger("assignmentId", assignmentId);

		List<DashboardQuestAnsBean> list = new ArrayList<DashboardQuestAnsBean>();

		List<StudentAnswer> ans = q.list();
		for (StudentAnswer studentAnswer : ans) {
			Question quest = (Question) session.get(Question.class,
					studentAnswer.getQuestionId());

			DashboardQuestAnsBean sb = new DashboardQuestAnsBean();
			sb.setQuestion(quest);
			sb.setStAnswer(studentAnswer);

			for (Answer qans : quest.getAnswers()) {
				if (studentAnswer.getAnswerId().equals(qans.getId())) {
					sb.setAnswer(qans);
				}
				if (qans.getIsCorrect()) {
					sb.setCorrectAnswerOfQuestion(qans);
				}
			}

			list.add(sb);
		}

		return list;
	}

	public List<AnswerAverageByQuestionBean> getAnswerAverageByQuestion(
			int classId, int assignmentId,String sortByColumn,String sortDirection ) {
		Session session = sessionFactory.getCurrentSession();

		StringBuffer sbQuery = new StringBuffer(
				"from StudentAnswer sa where sa.lessonAssignment.id = :assignmentId and sa.studentId in "
						+ " (select st.id from StudentClass clasese left join clasese.students st where clasese.id = :classId) ");
		Query q = session.createQuery(sbQuery.toString());
		q.setInteger("classId", classId);
		q.setInteger("assignmentId", assignmentId);

		Map<Integer, AnswerAverageByQuestionBean> map = new HashMap<Integer, AnswerAverageByQuestionBean>();

		List<StudentAnswer> ans = q.list();

		for (StudentAnswer studentAnswer : ans) {

			if (!map.containsKey(studentAnswer.getQuestionId())) {
				map.put(studentAnswer.getQuestionId(),
						new AnswerAverageByQuestionBean());
			}

			AnswerAverageByQuestionBean bean = map.get(studentAnswer
					.getQuestionId());
			bean.setCount(bean.getCount() + 1);
			bean.setClassId(classId);
			bean.setAssignmentId(assignmentId);

			if (studentAnswer.getIsCorrect())
				bean.setAnswer(bean.getAnswer() + 1);
		}

		for (Integer qId : map.keySet()) {
			Question quest = (Question) session.get(Question.class, qId);
			AnswerAverageByQuestionBean bean = map.get(qId);
			bean.setQuestion(quest);
			bean.setAnswer((float) Math.round(100 * bean.getAnswer()
					/ bean.getCount()));
		}

		List<AnswerAverageByQuestionBean> ansBean = new ArrayList<AnswerAverageByQuestionBean>(
				map.values());
		Comparator<AnswerAverageByQuestionBean> comp;
			if ("question".equals(sortByColumn)) {
				comp = new QuestionSort(sortDirection);
			} else if ("average".equals(sortByColumn)) {
				comp = new AverageSort(sortDirection);
			} else {
				comp = new AverageSort(sortDirection);
			}
	
		Collections.sort(ansBean, comp);

		return ansBean;
	}

	class QuestionSort implements Comparator<AnswerAverageByQuestionBean> {
		private String direction;

		public QuestionSort(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(AnswerAverageByQuestionBean a,
				AnswerAverageByQuestionBean b) {

			int com = "up".equals(direction) ? b.getQuestion().getText()
					.compareToIgnoreCase(a.getQuestion().getText()) : a
					.getQuestion().getText()
					.compareToIgnoreCase(b.getQuestion().getText());
			if (com == 0) {
				return Float.compare(b.getAnswer(), a.getAnswer());
			}
			return com;
		}
	}

	class AverageSort implements Comparator<AnswerAverageByQuestionBean> {
		private String direction;

		public AverageSort(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(AnswerAverageByQuestionBean a,
				AnswerAverageByQuestionBean b) {
			float a1 = a.getAnswer() != -1 ? a.getAnswer() : -101;
			float b1 = b.getAnswer() != -1 ? b.getAnswer() : -101;
		
				return "up".equals(direction) ? Float.compare(b1, a1) : Float
						.compare(a1, b1);
			
		}
	}

	public void initialiseGroups(List<DashboardResultBean> list, int subjectId) {
		for (DashboardResultBean drBean : list) {
			if (drBean.getGroup() != null) {
				continue;
			}
			int sz = drBean.getCorrectAnswer().size();
			if (sz > 0) {
				Float val = null;
				for (int i = drBean.getCorrectAnswer().size() - 1; i >= 0; i--)
					if (drBean.getCorrectAnswer().get(i) != null) {
						val = drBean.getCorrectAnswer().get(i);
						break;
					}
				if (val == null)
					continue;
				if (val >= 80f)
					setGroup(drBean, "A", subjectId); // green
				else if (val < 79f && val >= 60f)
					setGroup(drBean, "B", subjectId); // yellow
				else
					setGroup(drBean, "C", subjectId); // red
			}
		}
	}

	public Group getGroupByName(String groupName, int classId, int subjectId) {
		Session session = sessionFactory.getCurrentSession();
		Query q = session
				.createQuery("from Group where name = :name and studentClass.id = :classId and subjectId = :subjectId");
		q.setInteger("classId", classId);
		q.setString("name", groupName);
		q.setInteger("subjectId", subjectId);

		Group gr = (Group) q.uniqueResult();
		return gr;
	}

	public List<Group> getGroups(int classId, int subjectId) {
		Session session = sessionFactory.getCurrentSession();
		Query q = session
				.createQuery("from Group where studentClass.id = :classId and subjectId = :subjectId");
		q.setInteger("classId", classId);
		q.setInteger("subjectId", subjectId);
		return q.list();
	}

	@SuppressWarnings("unchecked")
	public List<Group> getGroupsByClassOrSubject(Integer classId,Integer subjectId){

		Session session = sessionFactory.getCurrentSession();
		List<Group> resList =  new ArrayList<Group>();
		if(subjectId == null) subjectId=1;
		Query q = session
				.createQuery("from Group where subjectId = :subjectId and studentClass.id=:classId");
		q.setInteger("classId", classId);
		q.setInteger("subjectId", subjectId);
		resList=q.list();
		return resList;
	}
	
	public List<Group> getGroups(int classId) {
		Session session = sessionFactory.getCurrentSession();
		Query q = session
				.createQuery("from Group where studentClass.id = :classId");
		q.setInteger("classId", classId);
		return q.list();
	}

	public Map<String, String> getMapGroups(int classId, int subjectId) {
		List<Group> list = getGroups(classId, subjectId);
		Map<String, String> groups = new LinkedHashMap<String, String>();
		for (Group gr : list) {
			groups.put(gr.getId().toString(), gr.getName());
		}
		return groups;
	}

	private void setGroup(DashboardResultBean drBean, String groupName,
			int subjectId) {
		Session session = sessionFactory.getCurrentSession();

		Group gr = getGroupByName(groupName, drBean.getClassId(), subjectId);
		if (gr == null) {
			gr = new Group();
			gr.setName(groupName);
			gr.setStudentClass((StudentClass) session.load(StudentClass.class,
					drBean.getClassId()));

			Query q = session
					.createQuery("select ss.teacher from StudentClass ss where ss.id = :id");
			q.setInteger("id", drBean.getClassId());
			User teacher = (User) q.uniqueResult();
			gr.setTeacher(teacher);

			Set<User> students = new HashSet<User>(0);
			gr.setStudents(students);

			gr.setSubjectId(subjectId);
			gr.setSubjectName(1 == subjectId ? LITERACY : MATH);
		}

		User user = (User) session.load(User.class, drBean.getStudentId());
		gr.getStudents().add(user);

		session.save(gr);

		drBean.setGroup(gr);
	}

	public void assignGroupToStudent(int groupId, int studentId) {
		Session session = sessionFactory.getCurrentSession();
		User user = (User) session.load(User.class, studentId);

		Group gr = (Group) session.load(Group.class, groupId);

		// remove the student from previous group
		List<Group> groups = getGroups(gr.getStudentClass().getId(),
				gr.getSubjectId());
		for (Group group : groups) {
			group.getStudents().remove(user);
		}

		// add the student to the new group
		gr.getStudents().add(user);
	}

	public Question getQuestion(int questionId) {
		Session session = sessionFactory.getCurrentSession();
		return (Question) session.get(Question.class, questionId);

	}

	@SuppressWarnings("unchecked")
	public Collection<QuestionAverageByAnswerBean> getAnswerAverageByStudent(
			Integer questionId, int classId, int assignmentId,
			String sortByColumn,String sortDirection) {

		Session session = sessionFactory.getCurrentSession();

		StringBuffer sbQuery = new StringBuffer(
				"from StudentAnswer sa where sa.lessonAssignment.id = :assignmentId and sa.studentId in "
						+ " (select st.id from StudentClass clasese left join clasese.students st where clasese.id = :classId) and sa.questionId=:questionId");
		Query q = session.createQuery(sbQuery.toString());
		q.setInteger("classId", classId);
		q.setInteger("assignmentId", assignmentId);
		q.setInteger("questionId", questionId);

		Map<Integer, QuestionAverageByAnswerBean> map = new HashMap<Integer, QuestionAverageByAnswerBean>();

		List<StudentAnswer> ans = q.list();

		int studentCounter = 0;
		for (StudentAnswer studentAnswer : ans) {

			if (!map.containsKey(studentAnswer.getAnswerId())) {
				map.put(studentAnswer.getAnswerId(),
						new QuestionAverageByAnswerBean());
			}

			QuestionAverageByAnswerBean bean = map.get(studentAnswer
					.getAnswerId());
			bean.setCount(bean.getCount() + 1);
			bean.setAnswerVal(bean.getAnswerVal() + 1);
			studentCounter++;
		}

		for (Integer aId : map.keySet()) {
			Answer answer = (Answer) session.get(Answer.class, aId);
			QuestionAverageByAnswerBean bean = map.get(aId);
			bean.setAnswer(answer);
			if (answer.getIsCorrect()) {
				bean.setCorrect(true);
			}
			bean.setAnswerVal((float) Math.round(100 * bean.getAnswerVal()
					/ studentCounter));
		}
		List<QuestionAverageByAnswerBean> ansBean = new ArrayList<QuestionAverageByAnswerBean>(
				map.values());
		Comparator<QuestionAverageByAnswerBean> comp;
			if ("question".equals(sortByColumn)) {
				comp = new AnswerSort(sortDirection);
			} else if ("average".equals(sortByColumn)) {
				comp = new AverageSortStudent(sortDirection);
			} else {
				comp = new AverageSortStudent(sortDirection);
			}
	
		Collections.sort(ansBean, comp);
		return ansBean;
	}
	
	class AnswerSort implements Comparator<QuestionAverageByAnswerBean> {
		private String direction;

		public AnswerSort(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(QuestionAverageByAnswerBean a,
				QuestionAverageByAnswerBean b) {

			int com = "up".equals(direction) ? b.getAnswer().getText()
					.compareToIgnoreCase(a.getAnswer().getText()) : a
					.getAnswer().getText()
					.compareToIgnoreCase(b.getAnswer().getText());
			if (com == 0) {
				return Float.compare(b.getAnswerVal(), a.getAnswerVal());
			}
			return com;
		}
	}

	class AverageSortStudent implements Comparator<QuestionAverageByAnswerBean> {
		private String direction;

		public AverageSortStudent(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(QuestionAverageByAnswerBean a,
				QuestionAverageByAnswerBean b) {
			float a1 = a.getAnswerVal() != -1 ? a.getAnswerVal() : -101;
			float b1 = b.getAnswerVal()!= -1 ? b.getAnswerVal() : -101;
		
				return "up".equals(direction) ? Float.compare(b1, a1) : Float
						.compare(a1, b1);
			
		}
	}
	
	public void resetGroup(int classId, int subjectId) {
		List<Group> groups = getGroups(classId, subjectId);
		for (Group group : groups) {
			group.getStudents().clear();
		}
	}
	
	@SuppressWarnings({ "unchecked" })
	public List<QuestionAverageByAnswerBean> getFreeAnswersToQuestionList(
			Integer questionId, int classId, int assignmentId) {

		Session session = sessionFactory.getCurrentSession();

		StringBuffer sbQuery = new StringBuffer(
				"from StudentAnswer sa where sa.lessonAssignment.id = :assignmentId and sa.studentId in "
						+ " (select st.id from StudentClass clasese left join clasese.students st where clasese.id = :classId) and sa.questionId=:questionId");
		
		Query q = session.createQuery(sbQuery.toString());
		q.setInteger("classId", classId);
		q.setInteger("assignmentId", assignmentId);
		q.setInteger("questionId", questionId);

		List<QuestionAverageByAnswerBean> resultList = new ArrayList<QuestionAverageByAnswerBean>();
		List<StudentAnswer> studentAnswer = q.list();

		for (StudentAnswer studAnswer : studentAnswer) {
			QuestionAverageByAnswerBean reBean = new QuestionAverageByAnswerBean();

			User foundUser = studentService.searchByUserId(studAnswer
					.getStudentId());

			if (studAnswer.getFreeResponse() != null) 
			{
				reBean.setFirstStudentName(foundUser.getFirstName());
				reBean.setFreeResponse(studAnswer.getFreeResponse());
				resultList.add(reBean);
			}
		}
		return resultList;
	}

	public List<AssignmentLessonBean> getQuizAndLessonAssingment(
			Integer classId, Integer subjectId, String groupId) {

		Session session = sessionFactory.getCurrentSession();

		List<LessonAssignment> las = new ArrayList<LessonAssignment>();
		if(!(groupId.equalsIgnoreCase("g1")))
		{
			if (StringUtils.isBlank(groupId))
			{
				Query q = session.createQuery("select distinct las from Quiz q "
						+ " join q.assignments las "
						+ " join las.studentAnswers sans where sans.studentId in "
						+ " (select st.id from StudentClass clasese left join clasese.students st where clasese.id = :classId) and "
						+ " lower(q.subject) =:subject");
				
				q.setInteger("classId", classId);
				q.setString("subject", subjectId == 1 ? LITERACY : MATH);
				las = q.list();
			} 
			else
			{
				Query q = session.createQuery("select distinct las from Quiz q "
						+ " join q.assignments las "
						+ " join las.studentAnswers sans  where sans.studentId in "
						+ " (select st.id from Group gr left join gr.students st where gr.id = :groupId) and "
						+ " lower(q.subject) =:subject");
			
				q.setString("groupId",groupId);
				q.setString("subject", subjectId == 1 ? LITERACY : MATH);
				las = q.list();
			}
		}
		else if(groupId.equalsIgnoreCase("g1"))
		{
			Query q = session.createQuery("select distinct las from Quiz q "
					+ " join q.assignments las "
					+ " join las.studentAnswers sans  where sans.studentId in "
					+ " (select st.id from Group gr left join gr.students st)");
		
			//q.setString("subject", subjectId == 1 ? LITERACY : MATH);
			las = q.list();
		}
		
		List<AssignmentLessonBean> assignmentLessons = new ArrayList<AssignmentLessonBean>();
		for (LessonAssignment la : las) {
			AssignmentLessonBean a = new AssignmentLessonBean();
			a.setLesonName(la.getLesson().getName());
			a.setAssignmentId(la.getId());
			a.setAssignmentStart(la.getStart());

			assignmentLessons.add(a);
		}

		return assignmentLessons;
	}

	private List<GoalAssignment> getGoalAssignmentAll(int teacherId, int classId, int subjectId, int groupId, int studentId){
		List<GoalAssignment> l = new ArrayList<GoalAssignment>();
		String subject;
		if (subjectId == 1) {
			subject = "literacy";
		} else {
			subject = "math";
		}
		
		l.addAll(getGoalAssignmentByStudent(studentId, teacherId, subject));
		if (groupId != -1) {
			l.addAll(getGoalAssignmentByGroup(groupId, subject));
		}
		l.addAll(getGoalAssignmentByClass(classId, subject));
		
		return l;
	}
	
	private List<GoalAssignment> getGoalAssignmentByGroup(int groupId, String subject){
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("select ga from GoalAssignment ga, Goal g where ga.groupId=:groupId and ga.goalId=g.id and g.subject=:subject");
		q.setInteger("groupId", groupId);
		q.setString("subject", subject);
		
		return q.list();
	}
	
	private List<GoalAssignment> getGoalAssignmentByClass(int classId, String subject){
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("select ga from GoalAssignment ga, Goal g where ga.classId=:classId and ga.studentId is null and ga.groupId is null and ga.goalId=g.id and g.subject=:subject");
		q.setInteger("classId", classId);
		q.setString("subject", subject);
		
		return q.list();
	}	
	
	private List<GoalAssignment> getGoalAssignmentByStudent(int studentId, int teacherId, String subject){
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("select ga from GoalAssignment ga, Goal g where " +
				" ga.studentId=:studentId and " +
				" ga.groupId is null and " +
				//" g.creatorId=:teacherId and " +
				" ga.goalId=g.id and " +
				" g.subject=:subject");
		q.setInteger("studentId", studentId);
		//q.setInteger("teacherId", teacherId);
		q.setString("subject", subject);
		
		return q.list();
	}
	
	private Group getGroupByClassAndStudent(int studentId, int classId, int subjectId){
		Session session = sessionFactory.getCurrentSession();
		Query q = session.createQuery("select gr from Group gr join gr.students sts where " +
				" gr.studentClass.id =:classId and sts.id =:studentId and subjectId=:subjectId");
		q.setInteger("studentId", studentId);
		q.setInteger("classId", classId);
		q.setInteger("subjectId", subjectId);
		
		return (Group) q.uniqueResult();
	}
	
	public List<DashboardGoalResultBean> getStudentGoals(Integer classId,
			Integer subjectId, String groupId, Integer teacherId) {
		Session session = sessionFactory.getCurrentSession();
		
		List<DashboardGoalResultBean> list = new ArrayList<DashboardGoalResultBean>();
		
		if("g1".equals(groupId)){
			List<User> students = studentClassService.getStudentByClass(classId);
			calcGoalResult(teacherId, session, list, students, classId, null, subjectId);
		} else {
			Group gr = (Group) session.get(Group.class, Integer.valueOf(groupId));
			calcGoalResult(teacherId, session, list, gr.getStudents(), classId, Integer.valueOf(groupId), subjectId);
		}
		
		Collections.sort(list, new NameSortGoals());
		return list;
	}

	class NameSortGoals implements Comparator<DashboardGoalResultBean> {
		public int compare(DashboardGoalResultBean a, DashboardGoalResultBean b) {
			int com = a.getName().compareToIgnoreCase(b.getName());
			return com;
		}
	}
	
	private void calcGoalResult(Integer teacherId, Session session,
			List<DashboardGoalResultBean> list, Collection<User> students, int classId, Integer groupId, int subjectId) {
		
		for (User student : students) 
		{
			DashboardGoalResultBean b = new DashboardGoalResultBean();
			b.setName(student.getFirstName() + " " + student.getLastName());
			b.setStudentId(student.getId());
			list.add(b);
			
			if(groupId == null){
				Group g = getGroupByClassAndStudent(student.getId(), classId, subjectId);
				if (g != null) {
					groupId = g.getId();
				} else {
					groupId = -1;
				}
			}
			
			List<GoalAssignment> gas = getGoalAssignmentAll(teacherId, classId, subjectId, groupId, student.getId());
			for (GoalAssignment goalAssignment : gas) 
			{
				Goal goal = (Goal) session.get(Goal.class, goalAssignment.getGoalId());
				b.getTargetGoals().add(goal);
				float finalResult = this.calculateGoalDashboardResult(student, goal);
				b.getCorrectAnswer().add(finalResult);
			}
		}
	}

	private float calculateGoalDashboardResult(User student,Goal goal) {
		
		List<LessonAssignment> lasList = getStudentAnswerByObjective(student.getId(), goal.getObjective());
		float totalScore = 0;
		for(LessonAssignment ls:lasList)
		{
			List<StudentAnswer> studAnswer = this.getStudentAnswer(student.getId(),ls.getId());
			int ans = 0;
			int correctAns = 0;
			for(StudentAnswer studentAnswer:studAnswer)
			{
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
		float finalResult = Math.round(totalScore / lasList.size());
		return finalResult;
	}
	
	public List<LessonAssignment> getStudentAnswerByObjective(int studentId, String objective, int teacherId) {
		Session session = sessionFactory.getCurrentSession();

		Query q = session.createQuery("select distinct las from Quiz q " +
						" join q.assignments las "+
						" join las.studentAnswers sans " +
						" where sans.studentId =:studentId and  " +
						" q.objective = :objective ");
						//"and " +
						//" las.creator.id=:creatorId");
		q.setInteger("studentId", studentId);
		q.setString("objective", objective);
		//q.setInteger("creatorId", teacherId);
		
		return q.list();
	}

	public List<LessonAssignment> getStudentAnswerByObjective(int studentId, String objective) {
		Session session = sessionFactory.getCurrentSession();

		Query q = session.createQuery("select distinct las from Quiz q " +
						" join q.assignments las "+
						" join las.studentAnswers sans " +
						" where sans.studentId =:studentId and  " +
						" q.objective = :objective ");
		q.setInteger("studentId", studentId);
		q.setString("objective", objective);
		
		return q.list();
	}
	
	public Set<GoalBean> getGoalHeaders(List<DashboardGoalResultBean> list) {
		Set<GoalBean> beans = new HashSet<GoalBean>();
		if(!list.isEmpty()){
			for (DashboardGoalResultBean b : list) {
				for (Goal goal : b.getTargetGoals()) {
					GoalBean z = new GoalBean();
					z.setId(goal.getId());
					z.setName(goal.getName());
					beans.add(z);
				}
			}
		}
		return beans;
	}

	@SuppressWarnings("unchecked")
	public List<AverageLessonsByGoal> getAverageLessonsByGoalObjective(Integer studentId,String goalObjective
			,String sortByColumn,String sortDirection) {


		List<AverageLessonsByGoal> resList = new ArrayList<AverageLessonsByGoal>();

		List<LessonAssignment> lasList = this.getStudentAnswerByObjective(studentId, goalObjective);
		for(LessonAssignment ls:lasList)
		{
			List<StudentAnswer> studAnswer = this.getStudentAnswer(studentId,ls.getId());
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
			AverageLessonsByGoal avGoal = new AverageLessonsByGoal();
			avGoal.setLessonName(ls.getLesson().getName());
			avGoal.setAssignmentId(ls.getId());
			avGoal.setAverageResult(average);
			resList.add(avGoal);
		}

		Comparator<AverageLessonsByGoal> comp;
		if ("lesson".equals(sortByColumn)) {
			comp = new LessonSort(sortDirection);
		} else if ("average".equals(sortByColumn)) {
			comp = new AverageSortLesson(sortDirection);
		} else {
			comp = new AverageSortLesson(sortDirection);
		}

		Collections.sort(resList, comp);
		return resList;
	}

	class LessonSort implements Comparator<AverageLessonsByGoal> {
		private String direction;

		public LessonSort(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(AverageLessonsByGoal a,
				AverageLessonsByGoal b) {

			int com = "up".equals(direction) ? b.getLessonName()
					.compareToIgnoreCase(a.getLessonName()) : a
					.getLessonName()
					.compareToIgnoreCase(b.getLessonName());
					if (com == 0) {
						return Float.compare(b.getAverageResult(), a.getAverageResult());
					}
					return com;
		}
	}

	class AverageSortLesson implements Comparator<AverageLessonsByGoal> {
		private String direction;

		public AverageSortLesson(String direction) {
			super();
			this.direction = direction;
		}

		public int compare(AverageLessonsByGoal a,
				AverageLessonsByGoal b) {
			float a1 = a.getAverageResult() != -1 ? a.getAverageResult() : -101;
			float b1 = b.getAverageResult()!= -1 ? b.getAverageResult() : -101;

			return "up".equals(direction) ? Float.compare(b1, a1) : Float
					.compare(a1, b1);

		}
	}
	
	class LessonAnswers {
		public int totalAnswers = 0;
		public int correctAnswers = 0;
	}
}