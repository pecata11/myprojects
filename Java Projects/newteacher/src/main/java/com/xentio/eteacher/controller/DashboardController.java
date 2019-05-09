package com.xentio.eteacher.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

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

import com.xentio.eteacher.domain.Goal;
import com.xentio.eteacher.domain.Group;
import com.xentio.eteacher.domain.Question;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AnswerAverageByQuestionBean;
import com.xentio.eteacher.domain.bean.AssignmentLessonBean;
import com.xentio.eteacher.domain.bean.DashStudentResult;
import com.xentio.eteacher.domain.bean.DashStudentResults;
import com.xentio.eteacher.domain.bean.AverageLessonsByGoal;
import com.xentio.eteacher.domain.bean.DashboardBean;
import com.xentio.eteacher.domain.bean.DashboardGoalResultBean;
import com.xentio.eteacher.domain.bean.DashboardQuestAnsBean;
import com.xentio.eteacher.domain.bean.DashboardResultBean;
import com.xentio.eteacher.domain.bean.GroupStudent;
import com.xentio.eteacher.domain.bean.QuestionAverageByAnswerBean;
import com.xentio.eteacher.service.DashboardService;
import com.xentio.eteacher.service.GoalService;
import com.xentio.eteacher.service.StudentClassService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/dashboard")
@SessionAttributes("teacher")
public class DashboardController {

	@Autowired
	private StudentClassService studentClassService;
	
	@Autowired
	private StudentService studentService;
	
	@Autowired
	private DashboardService dashboardService;	
	
	@Autowired
	private GoalService goalService;
	
	@ModelAttribute("teacher")
	public User createUser() {
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());
		return user;
	}
	
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String getDashboard(@RequestParam(value="classId", required=false) Integer classId, 
    		@RequestParam(value="subjectId", required=false) Integer subjectId,
    		ModelMap modelMap, Model model) {

    	User teacher = (User)modelMap.get("teacher");
    	
    	Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
    	
    	model.addAttribute("classes", classes);
    	
    	DashboardBean dashboardBean = new DashboardBean();
    	
    	//default dashboard class dropdown selection to first one in the list
    	if(classId == null && !classes.keySet().isEmpty()){
    		String classIdStr = (String) classes.keySet().toArray()[0];
    		classId = Integer.valueOf(classIdStr);
    	}
    	dashboardBean.setClassId(classId != null ? classId : 0);
    	dashboardBean.setSubjectId(subjectId != null ? subjectId : 1);
    	dashboardBean.setAssignmentLessons(dashboardService.getQuizAndLessonAssingment(dashboardBean.getClassId(), dashboardBean.getSubjectId()));
    	model.addAttribute("dashboardBean", dashboardBean);
    	
    	Map<String, String> subject = new LinkedHashMap<String, String>();
    	subject.put("1", DashboardService.LITERACY);
    	subject.put("2", DashboardService.MATH);
    	model.addAttribute("subject", subject);
    
    	model.addAttribute("groups", getMapGroups(classId,subjectId));
    	
    	return "dashboard/dashboard";
	}
    
    @RequestMapping(value = "/ajaxLessons", method = RequestMethod.GET)
    public String getLessons(@RequestParam(value="classId", required=true) Integer classId, 
    		@RequestParam(value="subjectId", required=true) Integer subjectId,
    		@RequestParam(value="groupId", required=false) String groupId,
    		ModelMap modelMap, Model model) {

    	DashboardBean dashboardBean = new DashboardBean();

    	dashboardBean.setAssignmentLessons(dashboardService.getQuizAndLessonAssingment(classId, subjectId, groupId));
    	model.addAttribute("dashboardBean", dashboardBean);
    	
    	return "dashboard/dashboard";
	}
    
    @RequestMapping(value = "/groups", method = RequestMethod.GET)
    public @ResponseBody List<GroupStudent> getGroupsForDashboard(
    @RequestParam(value="classId", required=false) Integer classId,
    @RequestParam(value="subjectId", required=false) Integer subjectId) {
    	return this.getGroups(classId,subjectId);
	}
    
    private List<GroupStudent> getGroups(Integer classId, Integer subjectId) {
		
    	List<Group> grs = dashboardService.getGroupsByClassOrSubject(classId,subjectId);
    	List<GroupStudent> list = new ArrayList<GroupStudent>();
    	
    	GroupStudent g = new GroupStudent();
    	g.setId("g1");
    	g.setName("All Groups");
    	list.add(g);
    	
    	for (Group group : grs) {
    		g = new GroupStudent();
    		g.setId("" + group.getId());
    		g.setName(group.getName() + " - " + group.getSubjectName());
    		list.add(g);
		}
    	return list;
	}
    
    private Map<String,String> getMapGroups(Integer classId,Integer subjectId){
		Map<String, String> elements = new LinkedHashMap<String, String>();
    	List<GroupStudent> list = getGroups(classId,subjectId);
    	for (GroupStudent groupStudent : list) {
    		elements.put(groupStudent.getId(), groupStudent.getName());
		}
    	return elements;
    }
    
    @RequestMapping(value = "/", method = RequestMethod.POST)
    public String postDashboard(@ModelAttribute("dashboardBean") DashboardBean dashboardBean, Model model) {

    	model.addAttribute("dashboardBean", dashboardBean);
    	
    	List<DashboardResultBean> list = dashboardService.getStudentGrowth(dashboardBean);
    	model.addAttribute("dashboardResult", list);
    	
    	//set color to the rows
		for (DashboardResultBean drBean : list) {
			int sz = drBean.getCorrectAnswer().size();
			if(sz > 0){
				Float val = null;
				for (int i = drBean.getCorrectAnswer().size() - 1; i >= 0; i--) 
					if(drBean.getCorrectAnswer().get(i) != null){
						val = drBean.getCorrectAnswer().get(i);
						break;
					}
				if(val == null)
					continue;
				if(val >= 80f)//#a1de28,#CCFF66
					drBean.setColor("#A2C954"); //green
				else if(val >= 60f && val< 79f)
					drBean.setColor("#FFFF99"); //yellow
				else 
					drBean.setColor("#FA8072"); //red
			}
		}
		
		//Initialise groups to students
		dashboardService.initialiseGroups(list, dashboardBean.getSubjectId());
				
		//calculate average
		dashboardService.calculateAverage(list);
		
    	//set color to the cells
		for (DashboardResultBean drBean : list) {
			if(drBean.getCorrectAnswer().isEmpty()) {
				continue;
			}
			
			for (Float correctAnswer : drBean.getCorrectAnswer()) { 
				if(correctAnswer == null) {
					drBean.getCellColors().add(null);
				} else if(correctAnswer >= 80f) {
					drBean.getCellColors().add("#A2C954");//green
				} else if(correctAnswer >= 60f && correctAnswer < 80) {
					drBean.getCellColors().add("#FFFF99");//yellow
				} else {
					drBean.getCellColors().add("#FA8072");//red
				}
			}
		}
		
		//prepare Header Names
    	List<AssignmentLessonBean> assignmentLessons =  dashboardService.getQuizAndLessonAssingment(dashboardBean.getAssignmentLessonIds());
    	model.addAttribute("headerNames", assignmentLessons);
    	
    	
    	List<Group> groups = dashboardService.getGroups(dashboardBean.getClassId(), dashboardBean.getSubjectId());
    	model.addAttribute("groups", groups);
    	
    	return "dashboard/ajaxDashboard";
	}
    
    @RequestMapping(value = "/answer", method = RequestMethod.GET)
    public String getStudentAnswers(@RequestParam(value="studentId", required=true) Integer studentId,
    		@RequestParam(value="assignmentId", required=true) Integer assignmentId, Model model) {

    	User student = studentService.get(studentId);
    	model.addAttribute("student", student);
    	
    	List<DashboardQuestAnsBean> list = dashboardService.getStudentAnswerForDashBoard(studentId, assignmentId);
    	model.addAttribute("questAnsBeans", list);
    	
    	return "dashboard/answer";
	}
    
    @RequestMapping(value = "/averageAnswer", method = RequestMethod.GET)
    public String getAverageStudentAnswers(@RequestParam(value="classId", required=true) Integer classId,
    		@RequestParam(value="assignmentId", required=true) Integer assignmentId,
    		@RequestParam(value="sortByColumn", required=false) String sortByColumn,
    		@RequestParam(value="sortDirection", required=false) String sortDirection,Model model) {
   	
    	
    	List<AnswerAverageByQuestionBean> list = dashboardService.getAnswerAverageByQuestion(classId, assignmentId,sortByColumn,sortDirection);
    	model.addAttribute("answerAverage", list);
    	
    	ArrayList<Integer> assignmentlist = new ArrayList<Integer>();
    	assignmentlist.add(assignmentId);
    	List<AssignmentLessonBean> assignmentLessons =  dashboardService.getQuizAndLessonAssingment(assignmentlist);
    	
    	model.addAttribute("headerName", assignmentLessons.get(0));
    	
    	sortByColumn = StringUtils.isBlank(sortByColumn)?"question":sortByColumn;
    	sortDirection = StringUtils.isBlank(sortDirection) ?"up":sortDirection;
    	
    	model.addAttribute("sortByColumn",sortByColumn);
    	model.addAttribute("sortDirection",sortDirection);
    	model.addAttribute("classId",classId);
    	model.addAttribute("assignmentId",assignmentId);
    	model.addAttribute("className", studentClassService.get(classId).getName());
    	
    	return "dashboard/averageAnswer";
	}
    
   
    //added by petko.
    @RequestMapping(value = "/averageAnswerByStudent", method = RequestMethod.GET)
    public String getAverageStudentAnswersByQuestion(
    		@RequestParam(value = "questionId", required = true) Integer questionId, 
    		@RequestParam(value = "classId", required = true) int classId,
    		@RequestParam(value = "assignmentId", required = true) int assignmentId,
    		@RequestParam(value="sortByColumn", required=false) String sortByColumn,
    		@RequestParam(value="sortDirection", required=false) String sortDirection,
    		Model model) {
   	
    	Collection<QuestionAverageByAnswerBean> list = 
    			dashboardService.getAnswerAverageByStudent(questionId,classId,assignmentId,
    					sortByColumn,sortDirection);
    	
    	model.addAttribute("answerAverageByStudent", list);
    	List<QuestionAverageByAnswerBean> freeResponseByStudentList =
    			dashboardService.getFreeAnswersToQuestionList(questionId, classId, assignmentId);

    	Boolean emptyList = false;
    	if(freeResponseByStudentList.isEmpty())
    	{
    	   emptyList = true;
    	   model.addAttribute("freeResponseEmpty",emptyList);
    	}
    	else
    	{
    		model.addAttribute("freeResponseList",freeResponseByStudentList);
    	}
    	Question question = dashboardService.getQuestion(questionId);
    	model.addAttribute("question",question);
    	sortByColumn = StringUtils.isBlank(sortByColumn)?"question":sortByColumn;
    	sortDirection = StringUtils.isBlank(sortDirection) ?"up":sortDirection;
    	
      	model.addAttribute("questionId",questionId);
    	model.addAttribute("classId",classId);
    	model.addAttribute("assignmentId",assignmentId);
    	model.addAttribute("sortByColumn",sortByColumn);
    	model.addAttribute("sortDirection",sortDirection);
    	return "dashboard/averageAnswerByStudent";
	}
    
    @RequestMapping(value = "/saveGroup", method = RequestMethod.POST)
    public @ResponseBody String saveGroup(int groupId, int studentId, Model model) {
    	
    	dashboardService.assignGroupToStudent(groupId, studentId);
    	return "ok";
    }
    
    @RequestMapping(value = "/resetGroup", method = RequestMethod.POST)
    public @ResponseBody String resetGroup(DashboardBean dashboardBean) {
    	
    	dashboardService.resetGroup(dashboardBean.getClassId(), dashboardBean.getSubjectId());
    	return "ok";
    }
    /* goals method(s)*/
    
    @RequestMapping(value = "/ajaxResultGoals", method = RequestMethod.GET)
    public String getResultGoals(@RequestParam(value="classId", required=true) Integer classId, 
    		@RequestParam(value="subjectId", required=true) Integer subjectId,
    		@RequestParam(value="groupId", required=false) String groupId,
    		ModelMap modelMap, Model model) {
    	
    	User teacher = (User)modelMap.get("teacher");
    	
    	List<DashboardGoalResultBean> list = dashboardService.getStudentGoals(classId, subjectId, groupId, teacher.getId());
    	
    	Set<Goal> goals = new HashSet<Goal>();
    	for (DashboardGoalResultBean dg : list) {
    		for (Goal g : dg.getTargetGoals()) {
    			goals.add(g);
    		}
    	}
    	List<DashStudentResults> allResults = new ArrayList<DashStudentResults>();
    	
//    	if (goals.isEmpty()) {
//    		return "dashboard/ajaxDashboardGoals";
//    	}
//    	
    	for (DashboardGoalResultBean r : list) {
    		DashStudentResults dashStudentResults = new DashStudentResults();
    		dashStudentResults.setName(r.getName());
    		dashStudentResults.setStudentId(r.getStudentId());
    		
    			List<DashStudentResult> studentResults = new ArrayList<DashStudentResult>();
    			if(!goals.isEmpty())
    			{ 
    				for (Goal g : goals) 
    				{
    					DashStudentResult dashStudentResult = new DashStudentResult();
    					dashStudentResult.setGoal(g);
    					boolean set = false;
    					for (int i=0; i < r.getTargetGoals().size(); i++) {
    						if (r.getTargetGoals().get(i).equals(g)) {
    							try {
    								dashStudentResult.setResult(r.getCorrectAnswer().get(i).toString());
    								float color = 100f * r.getCorrectAnswer().get(i)/ g.getTarget();
    								if(color  >= 80f) {
    									dashStudentResult.setColor("#A2C954");
    								} else if(color >= 60f && color < 80f) {
    									dashStudentResult.setColor("#FFFF99");
    								} else {
    									dashStudentResult.setColor("#FA8072");
    								}
    								set = true;
    								break;
    							} catch (NullPointerException e) {
    								System.out.println("NPE");
    							}
    						}
    					}
    					if (!set) {
    						dashStudentResult.setResult("N/A");
    					}
    					studentResults.add(dashStudentResult);
    				}
    			}
    		dashStudentResults.setResults(studentResults);
    		allResults.add(dashStudentResults);
    	}

    	/*
    	for (DashStudentResults r : allResults) {
    		//System.out.println(r.getName());
    		for (DashStudentResult rr : r.getResults()) {
    			System.out.println(rr.getGoal().getName() + "|" + rr.getResult());
    		}
    	}*/
    	
    	model.addAttribute("headerNames", goals);
    	model.addAttribute("dashboardResult", allResults);

    	return "dashboard/ajaxDashboardGoals";
	}
    
    @RequestMapping(value = "/averageLessonByGoal", method = RequestMethod.GET)
    public String getAverageLessonByGoal(
    		@RequestParam(value="goalId", required=true) Long goalId,
    		@RequestParam(value="studentId", required=true) Integer studentId,
    		@RequestParam(value="sortByColumn", required=false) String sortByColumn,
    		@RequestParam(value="sortDirection", required=false) String sortDirection,
    		Model model) {

    	Goal goal = goalService.getGoalById(goalId);
    	String goalObjective=null;
    	if(goal != null){
    		String goalName = goal.getName();
    		goalObjective = goal.getObjective();
    		model.addAttribute("goalName",goalName);
    		model.addAttribute("goalObjective",goalObjective);
    		model.addAttribute("goalTarget",goal.getTarget());
    	}

    	User user = studentService.searchByUserId(studentId);
    	String studentFirstName = user.getFirstName();
    	String studentLastName=user.getLastName();
    	if(studentFirstName != null || studentLastName!=null){
    		model.addAttribute("studentFirstName",studentFirstName);
    		model.addAttribute("studentLastName",studentLastName);
    	}

    	sortByColumn = StringUtils.isBlank(sortByColumn)?"lesson":sortByColumn;
    	sortDirection = StringUtils.isBlank(sortDirection) ?"up":sortDirection;

    	List<AverageLessonsByGoal> resultList = new ArrayList<AverageLessonsByGoal>();
    	resultList = dashboardService.getAverageLessonsByGoalObjective(studentId,
    								  goalObjective,sortByColumn,sortDirection);
    	if(resultList != null){
    		model.addAttribute("resultList",resultList);
    	}

    	float averageResultComb = 0;
    	for (AverageLessonsByGoal albg : resultList) {
    		averageResultComb = averageResultComb + albg.getAverageResult();
    	}
    	float averageResult = Math.round(averageResultComb / resultList.size());
    	
    	model.addAttribute("studentId",studentId);
    	model.addAttribute("goalId",goalId);
    	model.addAttribute("sortByColumn",sortByColumn);
    	model.addAttribute("sortDirection",sortDirection);
    	model.addAttribute("averageResult",averageResult);

    	return "dashboard/averageLessonByGoal";
    }
}
