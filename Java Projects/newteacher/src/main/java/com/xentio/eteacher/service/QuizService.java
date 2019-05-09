package com.xentio.eteacher.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StringType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.xentio.eteacher.domain.Answer;
import com.xentio.eteacher.domain.HintLog;
import com.xentio.eteacher.domain.LessonAssignment;
import com.xentio.eteacher.domain.Question;
import com.xentio.eteacher.domain.Quiz;
import com.xentio.eteacher.domain.StudentAnswer;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AnswerBean;
import com.xentio.eteacher.domain.bean.CroppableImage;
import com.xentio.eteacher.domain.bean.LeaderboardBean;
import com.xentio.eteacher.domain.bean.QuestionBean;
import com.xentio.eteacher.domain.bean.QuizBean;
import com.xentio.eteacher.domain.bean.QuizListBean;
import com.xentio.eteacher.domain.bean.SearchLessonFormBean;

@Service("quizService")
@Transactional
public class QuizService {
	@Autowired
	private SessionFactory sessionFactory;

	@SuppressWarnings("unchecked") 
	public List<Quiz> getQuizzes() {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM  Quiz");
		return query.list();
	}
	@SuppressWarnings("unchecked") 
	public List<Quiz> getQuizzesByUserId(Integer userId) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM Quiz where creatorId =:userId");
		query.setInteger("userId", userId);
		return query.list();
	}
	@SuppressWarnings("unchecked")
	public List<Quiz> getAssignedQuizzes() {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("select q FROM Quiz q join q.assignments aa WHERE aa.start < now()");
		return query.list();
	}
	

	public void updateQuiz(QuizBean quizBean) {
		Session session = sessionFactory.getCurrentSession();
		Quiz quiz = new Quiz();
		if(quizBean.getId() > 0) {
			quiz = (Quiz) session.get(Quiz.class, quizBean.getId());
		}
		quiz.setName(quizBean.getQuizName());
		quiz.setSubject(quizBean.getSubject());
		quiz.setGrade(quizBean.getGrade());
		quiz.setStrand(quizBean.getStrand());
		quiz.setObjective(quizBean.getObjective());
		quiz.setDescription(quizBean.getDescription());
		quiz.setEntryType(quizBean.getEntryType());
		quiz.setPdfId(quizBean.getPdfId()); 
		quiz.setCreatorId(quizBean.getCreatorId() > 0 ? quizBean.getCreatorId() : null);
		quiz.setInstrImageId(quizBean.isInstructionImage() ? quizBean.getInstrImage().getCroppedImageIdIfExists() : null);
		quiz.setProofRead(quizBean.isProofRead());
		session.saveOrUpdate(quiz);
		
		cleanDeleted(quizBean.getQuestions(), quiz.getQuestions(), session);
		
		for(QuestionBean questionBean : quizBean.getQuestions()) {
			Question question = null;
			
			if(questionBean.getId() > 0) {
				for (Question existingQuestion : quiz.getQuestions()) {
					if(existingQuestion.getId().equals(questionBean.getId())){
						question = existingQuestion;
						break;
					}
				}
			} else {
				question = new Question();
				question.setQuiz(quiz);
				quiz.getQuestions().add(question);
			}

			question.setHint(questionBean.getHint());
			question.setText(questionBean.getText());
			question.setImageId(questionBean.getImage().getImageId() > 0 ? questionBean.getImage().getImageId() : questionBean.getImage().getPdfImageId());
			
			for(AnswerBean answerBean : questionBean.getAnswers()) {
				if(answerBean == null || 
						(quiz.getEntryType() == QuizBean.MANUAL_TYPE && !answerBean.isFreeResponse() && StringUtils.isBlank(answerBean.getText()))) {
					continue;
				}
				
				Answer answer = null;
				
				if(answerBean.getId() > 0) {
					for (Answer existingAnswer : question.getAnswers()) {
						if(existingAnswer.getId().equals(answerBean.getId())){
							answer = existingAnswer;
							break;
						}
					}
				} else {
					answer = new Answer();
					question.getAnswers().add(answer);
					answer.setQuestion(question);
				}

				answer.setQuizId(quiz.getId());
				answer.setIsCorrect(answerBean.isSelected());
				answer.setIsFreeResponse(answerBean.isFreeResponse());
				answer.setIntervention(answerBean.getIntervention());
				answer.setText(answerBean.getText());
			}
		}
	}
	
	private void cleanDeleted(List<QuestionBean> questionBeans, List<Question> questions, Session session) {
		Iterator<Question> qIter = questions.iterator();
		while(qIter.hasNext()) {
			Question q = qIter.next();
			if(!containsQuestion(questionBeans, q.getId())) {
				qIter.remove();
				session.delete(q);
				continue;
			} 
			
			Iterator<Answer> aIter = q.getAnswers().iterator();
			while(aIter.hasNext()) {
				Answer a = aIter.next();
				if(!containsAnswer(questionBeans, a.getId())) {
					aIter.remove();
					session.delete(a);
				}
			}
			
		}
	}
	
	private boolean containsQuestion(List<QuestionBean> questionBeans, int quizId) {
		for(QuestionBean questionBean : questionBeans) {
			if(questionBean.getId() == quizId) {
				return true;
			}
		}
		return false;
	}
	
	private boolean containsAnswer(List<QuestionBean> questionBeans, int answerId) {
		for(QuestionBean questionBean : questionBeans) {
			for(AnswerBean answerBean : questionBean.getAnswers()) {
				if(answerBean.getId() == answerId) {
					return true;
				}
			}
		}
		return false;
	}

	
	
	
	public Quiz getQuiz(Integer id) {
		Session session = sessionFactory.getCurrentSession();
		Quiz quiz = (Quiz)session.createQuery("FROM Quiz WHERE id=" + id).uniqueResult();
		return quiz;
	}
	
	public QuizBean getQuizBean(Integer id, boolean forEdit) {
		Quiz quiz = getQuiz(id);
		
		QuizBean quizBean = new QuizBean();
		quizBean.setId(quiz.getId());
		quizBean.setQuizName(quiz.getName());		
		
		if(quiz.getCreatorId()!= null){
			quizBean.setCreatorId(quiz.getCreatorId());
		}
		
		quizBean.setGrade(quiz.getGrade());
		quizBean.setSubject(quiz.getSubject());
		quizBean.setStrand(quiz.getStrand());
		quizBean.setObjective(quiz.getObjective());
		quizBean.setDescription(quiz.getDescription());
		quizBean.setEntryType(quiz.getEntryType() != null ? quiz.getEntryType() : QuizBean.MANUAL_TYPE);
		quizBean.setPdfId(quiz.getPdfId() != null ? quiz.getPdfId() : 0);
		quizBean.setProofRead(quiz.isProofRead());
		if(quiz.getInstrImageId() != null && quiz.getInstrImageId() > 0) {
			quizBean.setInstructionImage(true);
			quizBean.setInstrImage(new CroppableImage(quiz.getInstrImageId(), 0));
		}
		
		
		List<QuestionBean> questionBeans = new ArrayList<QuestionBean>();
		for (Question question : quiz.getQuestions()) {
			QuestionBean questionBean = new QuestionBean();
			questionBean.setQuizId(id);
			questionBean.setId(question.getId());
			questionBean.setText(question.getText());
			questionBean.setHint(question.getHint());
			if(question.getImageId() != null) {
				questionBean.getImage().setImageId(question.getImageId());
			}

			questionBeans.add(questionBean);

			List<AnswerBean> answerBeans = new ArrayList<AnswerBean>();
			for (Answer answer : question.getAnswers()) {
				AnswerBean answerBean = new AnswerBean();
				answerBean.setId(answer.getId());
				answerBean.setFreeResponse(answer.getIsFreeResponse() != null && answer.getIsFreeResponse());
				answerBean.setIntervention(answer.getIntervention());
				answerBean.setText(answer.getText());
				answerBean.setIntervention(answer.getIntervention());

				if(forEdit) {
					answerBean.setSelected(answer.getIsCorrect());
					if(answer.getIsFreeResponse() != null && answer.getIsFreeResponse()) {
						questionBean.setHasFreeResponse(true);
						questionBean.setFreeResponsePrompt(answer.getText());
						continue;
					}
					
				} else {
					answerBean.setCorrect(answer.getIsCorrect());
				}
				
				answerBeans.add(answerBean);
			}

			questionBean.setAnswers(answerBeans);

		}

		quizBean.setQuestions(questionBeans);
		
		return quizBean;
	}
	
	public void insertStudentAnswers(List<StudentAnswer> studentAnswers, int quizId, int assignmentId) {
		Session session = sessionFactory.getCurrentSession();
		
		LessonAssignment la = getLessonAssingment(assignmentId);
		
		for(StudentAnswer studentAnswer : studentAnswers) {
			studentAnswer.setLessonAssignment(la);
			la.getStudentAnswers().add(studentAnswer);
			session.save(studentAnswer);
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<Integer> takenQuizzes(int studentId) {
		Session session = sessionFactory.getCurrentSession();
		String queryString = "select distinct quizId  from StudentAnswer where studentId = :id";
		Query q = session.createQuery(queryString);
		q.setInteger("id", studentId);
		return q.list();
	}

	public List<LeaderboardBean> getLeaderRank(String order) {
		Session session = sessionFactory.getCurrentSession();
		
		@SuppressWarnings("unchecked")
		List<LeaderboardBean> result = session.createSQLQuery(
				"SELECT 1 as rank, u.username as name, count(q.creator_id) as createdLessons " +
				"FROM quiz q JOIN user u ON q.creator_id = u.id " +
				"WHERE q.deleted = 0 " + 
				"GROUP BY q.creator_id ORDER BY createdLessons desc limit 25")
				  .addScalar("name", StringType.INSTANCE)
				  .addScalar("createdLessons", org.hibernate.type.IntegerType.INSTANCE)
				  .setResultTransformer(Transformers.aliasToBean(LeaderboardBean.class))
				  .list();
		
		for (int i = 0; i < result.size(); i++) {
			result.get(i).setRank(i + 1);
		}
		return result;
		
		// Do not delete!
/*		"SELECT zzz.name, zzz.createdLessons, @rownum:=@rownum+1 as rank FROM " +
		"(SELECT u.username as name, count(q.id) as createdLessons FROM quiz q  " +
		"INNER JOIN user u on u.id=q.creator_id  " +
		"GROUP BY u.username " +
		"ORDER BY createdLessons desc) zzz , (SELECT @rownum:=0) r")*/
	}

	public void delete(int id) {
		Session session = sessionFactory.getCurrentSession();
		
		Quiz quiz = (Quiz) session.get(Quiz.class, id);
		if(quiz == null) 
			return;
		
		session.delete(quiz);
		
		Query query = session.createQuery("DELETE FROM  StudentAnswer WHERE quizId = :id");
		query.setParameter("id", id);
		query.executeUpdate();
		
		query = session.createQuery("DELETE FROM  LessonAssignment WHERE lesson.id = :id");
		query.setParameter("id", id);
		query.executeUpdate();
	}

	
	public LessonAssignment createLessonAssignment(int quizId, Date startDate, int userId, boolean isQuiz) {
		Session session = sessionFactory.getCurrentSession();
		
		LessonAssignment la = new LessonAssignment();
		la.setStart(startDate);
		la.setIsQuiz(isQuiz);
		
		Quiz q = (Quiz) session.load(Quiz.class, quizId);
		la.setLesson(q);
		
		User u = (User) session.load(User.class, userId);
		la.setCreator(u);
		
		session.saveOrUpdate(la);
		
		return la;
	}
	
	public LessonAssignment getLessonAssingment(int id){
		Session session = sessionFactory.getCurrentSession();
		
		return (LessonAssignment) session.get(LessonAssignment.class, id);		
	}

	@SuppressWarnings("unchecked") 
	public List<QuizListBean> getListQuizzes() {
		Session session = sessionFactory.getCurrentSession();
		SQLQuery query = session.createSQLQuery("SELECT id, name, null as assignmentId FROM  quiz where deleted = 0");
		query.addScalar("name", StringType.INSTANCE)
			.addScalar("id", org.hibernate.type.IntegerType.INSTANCE)
			.addScalar("assignmentId", org.hibernate.type.IntegerType.INSTANCE);
		
		query.setResultTransformer(Transformers.aliasToBean(QuizListBean.class));
		return query.list();
	}
	
	@SuppressWarnings("unchecked") 
	public List<QuizListBean> getListQuizzes(int userId) {
		Session session = sessionFactory.getCurrentSession();
		SQLQuery query = session.createSQLQuery("SELECT id, name, null as assignmentId FROM  quiz where deleted = 0 and creator_id =" + userId);
		query.addScalar("name", StringType.INSTANCE)
			.addScalar("id", org.hibernate.type.IntegerType.INSTANCE)
			.addScalar("assignmentId", org.hibernate.type.IntegerType.INSTANCE);
		
		query.setResultTransformer(Transformers.aliasToBean(QuizListBean.class));
		return query.list();
	}
	
	@SuppressWarnings("unchecked")
	public List<QuizListBean> getAssignedQuizzes(Integer studentId) {
		Session session = sessionFactory.getCurrentSession();		
		Query query = session.createQuery("SELECT q.id as id, q.name as name, la.id as assignmentId FROM Quiz q " +
				"JOIN q.assignments la " +
				"JOIN la.students las " + 
				"WHERE las.id=:studentId AND la.start < now() " +
				"AND q.isProofRead is false " +
				"AND la.id not in " +
				"(SELECT distinct a.lessonAssignment.id FROM StudentAnswer as a " +
				"WHERE a.studentId=:studentId)");
	
		query.setInteger("studentId", studentId);
		
		query.setResultTransformer(Transformers.aliasToBean(QuizListBean.class));
		
		return query.list();
	}
	@SuppressWarnings("unchecked")
	public Quiz getLastUserQuiz(Integer userId) {
		// TODO Auto-generated method stub
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("from Quiz where creator_id=:userId");
		query.setInteger("userId", userId);
		List<Quiz> resList = query.list();
		Quiz resBean = resList.get(resList.size()-1);
		return resBean;
	}
	
	public void hintSeen(Integer studentId, Integer assignmentId,
			Integer quizId, Integer questionId) {
		
		Session session = sessionFactory.getCurrentSession();
		HintLog hint = new HintLog();
		hint.setStudentId(studentId);
		hint.setAssignmentId(assignmentId);
		hint.setQuizId(quizId);
		hint.setQuestionId(questionId);
		session.save(hint);
	}
	@SuppressWarnings("unchecked")
	public List<Quiz> searchQuizzes(SearchLessonFormBean formBean) {

		Session session = sessionFactory.getCurrentSession();
		String grade=formBean.getGrade();
		String subject=formBean.getSubject();
		String strand=formBean.getStrand();
		String objective=formBean.getObjective();
		String searchTerm=formBean.getSearchTerm();
		
		// 1.case search by drop downs
		// 2.case search by term
		// 3.case search by drop downs and term.
		boolean dropDownsSetCondition = (
				   (!grade.equalsIgnoreCase("-1"))
				|| (subject != null)
				|| (strand != null) 
				|| (objective != null));

		boolean searchTermSetCondition = (searchTerm != null && 
										 (!searchTerm.equalsIgnoreCase("")));
		List<Quiz> resList = null;
		// 1.case search by drop downs only.
		if (dropDownsSetCondition && !searchTermSetCondition) 
		{   
			Query query = constructQueryConstraints(grade,
					subject, strand, objective,session,"");
			resList = query.list();
		}
		
		// 2.case search by term only.
		if(searchTermSetCondition && !dropDownsSetCondition)
		{
		     Query query = constructQueryConstraints(grade,
					subject, strand, objective,session,searchTerm);
					resList = query.list();
		} 
		
		 //3.case search by drop downs and term.
		 if(searchTermSetCondition && dropDownsSetCondition)
		 {
				Query query = constructQueryConstraints(grade,
						subject, strand, objective,session,searchTerm);
				resList = query.list();
		 }
		return resList;
	}
	
	private Query constructQueryConstraints(String grade,
			String subject, String strand, String objective,
			Session session,String searchTerm) 
	{
			if(grade !=null){
				if(grade.equalsIgnoreCase("-1")) grade = null;
			}
			if(subject!=null){
				if(subject.equalsIgnoreCase("-1")) subject = null;
			}
			if(strand != null){
				if(strand.equalsIgnoreCase("-1")) strand = null;
			}
			if(objective!=null){
				if(objective.equalsIgnoreCase("-1")) objective = null;
			}
			
		Query query = null;
			
		List<String> l = new ArrayList<String>();
		
		if(StringUtils.isNotBlank(grade)){

			l.add("q.grade='"+grade+"'");
		}
		if(StringUtils.isNotBlank(subject)){

			l.add("q.subject='"+subject+"'");
		}
		if(StringUtils.isNotBlank(strand)){

			l.add("q.strand='"+strand+"'");
		}
		if(StringUtils.isNotBlank(objective)){

			l.add("q.objective='"+objective+"'");
		}
		
		if(!searchTerm.equalsIgnoreCase(""))
		{
			l.add("((q.name LIKE CONCAT('%', '"+searchTerm+"', '%') OR " 
					+ "q.description LIKE CONCAT('%','"+searchTerm+"','%')))");
		}
	
		StringBuilder queryString = new StringBuilder("SELECT DISTINCT q FROM Quiz q WHERE ");
		
		for (Iterator<String> iterator = l.iterator(); iterator.hasNext();) 
		{
			String string = (String) iterator.next();
			queryString.append(string);
			if(iterator.hasNext()) queryString.append(" AND ");
		}
		query = session.createQuery(queryString.toString());
		return query;
	}
	
	@SuppressWarnings("unchecked")
	public List<QuizListBean> getQuizzeListFromSearch(String lessonIds) {
		String lessonIdsClear = lessonIds.substring(0, lessonIds.length() - 1);
		Session session = sessionFactory.getCurrentSession();	
		SQLQuery query = session.createSQLQuery("SELECT id, name, null as assignmentId FROM  quiz where deleted = 0 and id in(" + lessonIdsClear +")");
		query.addScalar("name", StringType.INSTANCE)
			.addScalar("id", org.hibernate.type.IntegerType.INSTANCE)
			.addScalar("assignmentId", org.hibernate.type.IntegerType.INSTANCE);
		
		query.setResultTransformer(Transformers.aliasToBean(QuizListBean.class));

		return query.list();
	}
}

