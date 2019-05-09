package com.xentio.eteacher.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.google.gson.Gson;
import com.xentio.eteacher.domain.Draft;
import com.xentio.eteacher.domain.Quiz;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.QuizBean;
import com.xentio.eteacher.domain.bean.QuizListBean;
import com.xentio.eteacher.service.DraftService;
import com.xentio.eteacher.service.GoalService;
import com.xentio.eteacher.service.QuizService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/quizzes")
@SessionAttributes("student")
public class QuizController {
	private static int MAX_LESSONS_TO_SHOW_FOR_STUDENTS = 10;
	
	@Autowired
	private QuizService quizService;

	@Autowired
	private StudentService studentService;
	
	@Autowired
	private DraftService draftService;
	
	@Autowired
	private GoalService goalService;
	
	@ModelAttribute("student")
	public User createUser() {
		System.out.println("QuizController.createUser");
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());
		return user;
	}
	
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String getHomePage(Model model, @ModelAttribute("student") User user, 
    		@RequestParam(value = "hideDrafts", required = false) String hideDrafts) {
    	
    	if(user.getAccess() == User.STUDENT_ACCESS) {
    		List<QuizListBean> assignedLessons = quizService.getAssignedQuizzes(user.getId());
    		int limit = MAX_LESSONS_TO_SHOW_FOR_STUDENTS - assignedLessons.size(); 
			List<QuizListBean> autoAssignedLessons = limit > 0 ? 
					goalService.getAutoAssignedLessons(user.getId(), limit)
					: new ArrayList<QuizListBean>();
    		
    		//remove repeating lessons
    		Iterator<QuizListBean> iter = autoAssignedLessons.iterator();
    		while(iter.hasNext()) {
    			QuizListBean autoQuiz = iter.next();
    			for(QuizListBean assignQuiz : assignedLessons) {
    				if(autoQuiz.getId() == assignQuiz.getId()) {
    					iter.remove();
    					break;
    				}
    			}
    		}
    		
    		
        	model.addAttribute("quizzes", assignedLessons);
        	model.addAttribute("autoQuizzes", autoAssignedLessons);
        	return "quiz/studentQuizzes";
    	}
    	
    	List<QuizListBean> quizzes = "root".equals(user.getUsername()) ? 
    			quizService.getListQuizzes() :
    			quizService.getListQuizzes(user.getId());
    	
    	model.addAttribute("quizzes", quizzes);
    	if(hideDrafts != null && "true".equals(hideDrafts)) {
    		model.addAttribute("hideEdit", true);
        	return "quiz/quizzes";
    	}
    	
    	//show drafts if any
    	List<Draft> drafts = draftService.getDrafts();
    	
    	if(drafts != null && drafts.size() > 0 && user.getAccess() != User.STUDENT_ACCESS) {
    		Gson gson = new Gson();
    		List<QuizBean> draftQuizBeans = new ArrayList<QuizBean>();
    		for(Draft  draft : drafts)
    		{
    			QuizBean quizBean = gson.fromJson(draft.getData(), QuizBean.class);
    			//Get only this user drafts.
    			if(quizBean.getCreatorId() == user.getId()){
    			  draftQuizBeans.add(quizBean);
    			}
    		}
    		
    		model.addAttribute("drafts", draftQuizBeans);
    	}
    	
    	return "quiz/quizzes";
	}
    
    @RequestMapping(value = "/listLessons", method = RequestMethod.GET)
    public String getListLessons(@RequestParam(value = "lessonIds", required = false) String lessonsIds, Model model) {
    	List<QuizListBean> quizzes = quizService.getQuizzeListFromSearch(lessonsIds);
    	
    	model.addAttribute("quizzes", quizzes);
    	
    	return "quiz/lessonsList";
	}
    
    @RequestMapping(value = "/assign", method = RequestMethod.GET)
    public String getAssign(@RequestParam(value="id", required=true) Integer id, Model model) {
    	Quiz quiz = quizService.getQuiz(id);
    	
    	model.addAttribute("quiz", quiz);
    	
    	return "quiz/assignQuiz";
	}
  
    
    @RequestMapping(value = "/assign", method = RequestMethod.POST)
	public String assignQuiz(
			@RequestParam(value = "id", required = true) Integer id,
			@RequestParam(value = "startDate", required = true) String startDate,
			ModelMap modelMap, Model model) {
    	
    	try {
			Date date = new SimpleDateFormat("MM/dd/yyyy").parse(startDate);
			
			User user = (User)modelMap.get("student");
			quizService.createLessonAssignment(id, date, user.getId(), false);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	
    	return "redirect:list";
	}
    
    
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public String delete(@RequestParam(value="id", required=true) Integer id, Model model) {
    	quizService.delete(id);
    	
    	return "redirect:list";
	}
}
