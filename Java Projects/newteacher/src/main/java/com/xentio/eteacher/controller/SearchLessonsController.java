package com.xentio.eteacher.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.xentio.eteacher.cs.CoreStandardsHelper;
import com.xentio.eteacher.domain.Quiz;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.QuizBean;
import com.xentio.eteacher.domain.bean.SearchLessonFormBean;
import com.xentio.eteacher.domain.bean.SearchResultBean;
import com.xentio.eteacher.service.QuizService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/searchLessons")
public class SearchLessonsController {
	
	@Autowired
	private StudentService studentService;

	@Autowired
	private QuizService quizService;
	
	 @RequestMapping(value = "/search", method = RequestMethod.GET)
	 public String getSearch(Model model){
		 model.addAttribute("searchBean", new SearchLessonFormBean());
		 
		 QuizBean quizBean = new QuizBean();
		 CoreStandardsHelper.setObjectivePicker(model, quizBean);
		 
		return "searchLessons/searchLessons";
	 }
	 
	 @RequestMapping(value = "/search", method = RequestMethod.POST)
	 public String postSearch(@ModelAttribute("searchBean") SearchLessonFormBean searchBean,Model model){

		 List<Quiz> resultQueryList = quizService.searchQuizzes(searchBean);

		 QuizBean quizBean = new QuizBean();
		 CoreStandardsHelper.setObjectivePicker(model, quizBean);
		 boolean noSearchCriteriaSpecified = false;
		 if(resultQueryList != null)
		 {
			 boolean isEmpty = false;
			 if(resultQueryList.isEmpty()){
				 isEmpty = true;
				 model.addAttribute("isEmpty",isEmpty);
			 }
			 List<SearchResultBean> resultBeanList = fillSearchResultList(resultQueryList);
			 model.addAttribute("resultBeanList",resultBeanList);
		 }
		 else{
			 noSearchCriteriaSpecified = true;
			 model.addAttribute("noSearchCriteriaSpecified",noSearchCriteriaSpecified);
		 }
		 return "searchLessons/searchLessons";
	 }

	 private List<SearchResultBean> fillSearchResultList(
			 List<Quiz> resultQueryList) {

		 List<SearchResultBean> resultBeanList = new ArrayList<SearchResultBean>();
		 for(Quiz q : resultQueryList)
		 {
			 SearchResultBean sBean = new SearchResultBean();
			 if(q.getCreatorId() != null)
			 {
				 User user = studentService.searchByUserId(q.getCreatorId());
				 sBean.setCreatorName(user.getFirstName());
			 } 
			 else sBean.setCreatorName("");
			 sBean.setLessonId(q.getId());
			 sBean.setQuizName(q.getName());
			 resultBeanList.add(sBean);
		 }
		 return resultBeanList;
	 }
}