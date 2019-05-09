package com.xentio.eteacher.service;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;
import com.xentio.eteacher.domain.Draft;
import com.xentio.eteacher.domain.bean.QuizBean;

@Service("draftService")
@Transactional
public class DraftService {
	@Autowired
	private SessionFactory sessionFactory;

	@SuppressWarnings("unchecked") 
	public List<Draft> getDrafts() {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM  Draft");

		return query.list();
	}

	public QuizBean getDraftQuiz(long id) {
		Draft draft = getDraft(id);
		if(draft == null) {
			return null;
		}
		
		QuizBean quizBean = new Gson().fromJson(draft.getData(), QuizBean.class);
		return quizBean;
	}
	
	public void updateDraftQuiz(QuizBean quiz) {
    	Draft draft = new Draft();
    	draft.setCreateTimeMlls(quiz.getCreateTimeMlls());
    	draft.setData(new Gson().toJson(quiz));
    	draft.setUpdateTimeMlls(System.currentTimeMillis());
    	updateDraft(draft);
	}
	
	private Draft getDraft(long id) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("FROM  Draft WHERE createTimeMlls = :createTimeMlls");
		query.setParameter("createTimeMlls", id);

		return (Draft)query.uniqueResult();
	}
	
	private void updateDraft(Draft draft) {
		Session session = sessionFactory.getCurrentSession();
		
		session.saveOrUpdate(draft);
	}
	
	public void deleteDraft(long createTimeMlls) {
		Session session = sessionFactory.getCurrentSession();
		Query query = session.createQuery("DELETE FROM  Draft WHERE createTimeMlls = :createTimeMlls");
		query.setParameter("createTimeMlls", createTimeMlls);
		query.executeUpdate();
	}
}
