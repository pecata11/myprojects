package com.xentio.eteacher.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.xentio.eteacher.domain.LessonAssignment;
import com.xentio.eteacher.domain.StudentAnswer;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AnswerBean;
import com.xentio.eteacher.domain.bean.QuestionBean;
import com.xentio.eteacher.domain.bean.QuizBean;
import com.xentio.eteacher.service.QuizService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/perform")
@SessionAttributes({"loggedUser", "performQuiz"})
public class PerformLessonController {

	@Autowired
	private QuizService quizService;

	@Autowired
	private StudentService studentService;

	
	@ModelAttribute("loggedUser")
	public User createUser() {
		System.out.println("QuizController.createUser");
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());
		return user;
	}
	
    @RequestMapping(value = "/start", method = RequestMethod.GET)
    public String getStart(@RequestParam(value="id", required=true) Integer id,
    		@RequestParam(value="assignmentId", required=false) Integer assignmentId, 
    		HttpServletRequest request, ModelMap modelMap, Model model) {
    	
    	QuizBean quizBean = quizService.getQuizBean(id, false);
    	
    	LessonAssignment la = null;
    	if(assignmentId == null) { //&& request.isUserInRole("ROLE_ADMIN")){
    		User user = (User)modelMap.get("loggedUser");
    		la = quizService.createLessonAssignment(id, new Date(), user.getId(), false);
    	} else {
    		la = quizService.getLessonAssingment(assignmentId);
    	}

		if(la != null){
			quizBean.setLessonAssignmentId(la.getId());
			quizBean.setQuiz(la.getIsQuiz());
		}
    	
    	model.addAttribute("performQuiz", quizBean);
    	
    	return "quiz/next";
	}
    
    @RequestMapping(value = "/iterate", method = RequestMethod.POST,  params="leaveIntervention")
    public String leaveIntervention(@ModelAttribute("performQuiz") QuizBean quizBean,
    		ModelMap modelMap,	Model model) {
    	int questionsCount = quizBean.getQuestions().size();
    	int currQuestNumber = quizBean.getCurrentQuestionNumber();
    	
    	if(currQuestNumber < questionsCount - 1) {
    		quizBean.setCurrentQuestionNumber(currQuestNumber + 1);
        	return "quiz/next";
    	}
    	
    	calcResult(quizBean, modelMap, model);
    	return "quiz/result";   
    }
    
    @RequestMapping(value = "/iterate", method = RequestMethod.POST,  params="next")
    public String next(@ModelAttribute("performQuiz") QuizBean quizBean,
    		ModelMap modelMap,	Model model) {
    	
    	int questionsCount = quizBean.getQuestions().size();
    	int currQuestNumber = quizBean.getCurrentQuestionNumber();

	   	//check if an answer is marked
    	QuestionBean currQuestion = quizBean.getQuestions().get(currQuestNumber);
    	if(currQuestNumber < questionsCount) {
    		if(!currQuestion.hasMarkedAnswer()) {
    			model.addAttribute("error", "Please mark an answer");
    			return "quiz/next";
    		}
    	}
    	
    	if(!quizBean.isQuiz()){
	    	for(AnswerBean answerBean : currQuestion.getAnswers()) {
	    		if(answerBean.isSelected() && StringUtils.isNotBlank(answerBean.getIntervention())) {
	    			model.addAttribute("intervention", answerBean.getIntervention());
	    			//return "quiz/intervention";
	    			// if it is intervention show the same page and the intervention in a popup
	    			return "quiz/next";
	    		}
	    	}
    	}
    	
    	// if before last -> iterate to next page
    	if(currQuestNumber < questionsCount - 1) {
    		quizBean.setCurrentQuestionNumber(currQuestNumber + 1);
        	return "quiz/next";
    	}
    	
    	calcResult(quizBean, modelMap, model);
    	return "quiz/result";   
	}
    
    
    @RequestMapping(value = "/iterate", method = RequestMethod.POST,  params="prev")
    public String prev(@ModelAttribute("quiz") QuizBean quizBean, 
    		@ModelAttribute("loggedUser") User user, Model model) {

    	model.addAttribute("quiz", quizBean);

    	int currQuestNumber = quizBean.getCurrentQuestionNumber();
    	
    	if(currQuestNumber > 0) {
    		quizBean.setCurrentQuestionNumber(currQuestNumber - 1);	 
        	return "quiz/next";
    	}
    	
    	
    	return "quiz/next";    	
	}
    
    private void calcResult(QuizBean quizBean, ModelMap modelMap, Model model) {
    	User user = (User)modelMap.get("loggedUser");
    	//insert all selections to DB
    	
    	Date now = new Date();
    	List<StudentAnswer> studentAnswers = new ArrayList<StudentAnswer>();
    	for(QuestionBean questionBean : quizBean.getQuestions()) {
    		for(AnswerBean answerBean : questionBean.getAnswers()) {
    			if(answerBean.isSelected() || answerBean.isFreeResponse()) {
        			StudentAnswer studentAnswer = new StudentAnswer();
        			studentAnswer.setIsCorrect(answerBean.isCorrect());
        			studentAnswer.setAnswerId(answerBean.getId());
        			studentAnswer.setQuestionId(questionBean.getId());
        			studentAnswer.setQuizId(questionBean.getQuizId());
        			studentAnswer.setStudentId(user.getId());
        			studentAnswer.setPerformTime(now);
        			
        			if(answerBean.isFreeResponse()) {
        				studentAnswer.setFreeResponse(answerBean.getStudentFreeResponse());
        			}
        			
        			studentAnswers.add(studentAnswer);
         		} 
    			
    		}
    	}
    	quizService.insertStudentAnswers(studentAnswers, quizBean.getId(), quizBean.getLessonAssignmentId());
    	
    	//calculate result to show only
    	float allCorrect = 0;
    	float yourCorrect = 0;
    	for(QuestionBean questionBean : quizBean.getQuestions()) {
    		for(AnswerBean answerBean : questionBean.getAnswers()) {
    			
    			if(answerBean.isCorrect()) {
    				allCorrect ++;
    				if(answerBean.isSelected()) {
    					yourCorrect ++;
    				}
    			}
    			
    		}
    	}
    	
    	float percentCorrect = (float) Math.round((yourCorrect/allCorrect)*100);
    	model.addAttribute("percentCorrect", percentCorrect) ;
    	//model.addAttribute("allCorrect",allCorrect);
    	//model.addAttribute("yourCorrect", yourCourrect);
    }
    
    @RequestMapping(value = "/hintSeen", method = RequestMethod.GET)
    public @ResponseBody String resetGroup(@RequestParam(value="studentId", required=true) Integer studentId,
    		@RequestParam(value="assignmentId", required=true) Integer assignmentId,
    		@RequestParam(value="quizId", required=true) Integer quizId,
    		@RequestParam(value="questionId", required=true) Integer questionId) {
    	
    	quizService.hintSeen(studentId, assignmentId, quizId, questionId);
    	return "ok";
    }
}
