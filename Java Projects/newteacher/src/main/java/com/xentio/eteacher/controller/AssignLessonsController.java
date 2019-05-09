package com.xentio.eteacher.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xentio.eteacher.domain.Group;
import com.xentio.eteacher.domain.Quiz;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AssignmentLessonToStudentBean;
import com.xentio.eteacher.domain.bean.GroupStudent;
import com.xentio.eteacher.service.AssignmentService;
import com.xentio.eteacher.service.DashboardService;
import com.xentio.eteacher.service.QuizService;
import com.xentio.eteacher.service.StudentClassService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/assignLessons")
public class AssignLessonsController {

	@Autowired
	private StudentClassService studentClassService;
	
	@Autowired
	private StudentService studentService;
	
	@Autowired
	private DashboardService dashboardService;	
	
	@Autowired
	private AssignmentService assignmentService;

	@Autowired
	private QuizService quizService;
	
	
    @RequestMapping(value = "/student", method = RequestMethod.GET)
    public String getDashboard(@RequestParam(value="studentId", required=false) Integer studentId,
    		@RequestParam(value="classId", required=false) Integer classId,
    		@RequestParam(value="lessonId", required=false) Integer lessonId, Model model) {
    	
    	User teacher = studentService.getLoggedUser();
    	Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
    	model.addAttribute("classes", classes);
    	if(classId == null && !classes.isEmpty()){
    		classId = Integer.valueOf((String)classes.keySet().toArray()[0]);
    	}
    	AssignmentLessonToStudentBean assignmentBean = new AssignmentLessonToStudentBean();
    	assignmentBean.setClassId(classId);
    	assignmentBean.setLessonId(lessonId);
    	assignmentBean.setStudentId(String.valueOf(studentId));
    	model.addAttribute("assignBean", assignmentBean);
    	
    	List<Quiz> lessons;
    	if(lessonId == null){
    		lessons = quizService.getQuizzes();
    	} else {
    		lessons = assignmentService.getQuizzes(lessonId);
    	}
    	
    	model.addAttribute("lessons", lessons);
    	
    	model.addAttribute("students", getMapGroupsStudents(classId));
    	
    	return "assignLessons/assignLessons";
	}
    
    @RequestMapping(value = "/student", method = RequestMethod.POST)
    public String assign(@ModelAttribute("assignBean") AssignmentLessonToStudentBean assignmentBean, Model model) {
    	
    	assignmentService.createAssignmentAndAddStudents(assignmentBean);
    	return "redirect:/api/dashboard/";
	}
    
    @RequestMapping(value = "/clear", method = RequestMethod.GET)
    public @ResponseBody String clearPlayList(@RequestParam(value="classId", required=true) Integer classId,
    		@RequestParam(value="studentId", required=true) String studentId) {
    	
    	return assignmentService.clearAssignment(classId, studentId);
	}
    
    @RequestMapping(value = "/groups", method = RequestMethod.GET)
    public @ResponseBody List<GroupStudent> getGroup(@RequestParam(value="classId", required=true) Integer classId) {
    	return getGroupsStudents(classId);
	}

    private Map<String,String> getMapGroupsStudents(Integer classId){
		Map<String, String> elements = new LinkedHashMap<String, String>();
    	List<GroupStudent> list = getGroupsStudents(classId);
    	for (GroupStudent groupStudent : list) {
    		elements.put(groupStudent.getId(), groupStudent.getName());
		}
    	return elements;
    }
    
	private List<GroupStudent> getGroupsStudents(Integer classId) {
		List<Group> grs = dashboardService.getGroups(classId);
    	
    	List<GroupStudent> list = new ArrayList<GroupStudent>();
    	
    	GroupStudent g = new GroupStudent();
    	g.setId("c1");
    	g.setName("All Students");
    	list.add(g);
    	
    	for (Group group : grs) {
    		g = new GroupStudent();
    		g.setId("g" + group.getId());
    		g.setName(group.getName() + " - " + group.getSubjectName());
    		list.add(g);
		}
    	
    	List<User> students = studentClassService.getStudentByClass(classId);
    	for (User user : students) {
    		g = new GroupStudent();
    		g.setId("" + user.getId());
    		g.setName(user.getFirstName() + " " + user.getLastName());
    		list.add(g);
		}
    	
    	return list;
	}
	
    @RequestMapping(value = "/currLesons", method = RequestMethod.GET)
    public String getCurrentLesons(@RequestParam(value="classId", required=true) Integer classId,
    		@RequestParam(value="studentId", required=true) String studentId, 
    		@RequestParam(value="lessonId", required=false) Integer lessonId, Model model) {
    	
    	List<Quiz> lessons = null;
    	if(studentId != null){
    		lessons = assignmentService.getAssignedQuizzes(classId, studentId);
    	} 
    	
    	model.addAttribute("lessons", lessons);
    	
    	AssignmentLessonToStudentBean assignmentBean = new AssignmentLessonToStudentBean();
    	assignmentBean.setClassId(classId);
    	assignmentBean.setLessonId(lessonId);
    	assignmentBean.setStudentId(String.valueOf(studentId));
    	model.addAttribute("assignBean", assignmentBean);
    	
    	
    	return "assignLessons/ajaxAssignLessons";
	}
    
    @RequestMapping(value = "/recommendLesons", method = RequestMethod.GET)
    public String getRecommendLesons(@RequestParam(value="classId", required=true) Integer classId,
    		@RequestParam(value="studentId", required=true) String studentId, 
    		@RequestParam(value="lessonId", required=false) Integer lessonId, Model model) {
    	
    	List<Quiz> lessons = null;
    	if(lessonId == null){
    		lessons = quizService.getQuizzes();
    	} else {
    		lessons = assignmentService.getQuizzes(lessonId);
    	}
    	
    	model.addAttribute("lessons", lessons);
    	
    	AssignmentLessonToStudentBean assignmentBean = new AssignmentLessonToStudentBean();
    	assignmentBean.setClassId(classId);
    	assignmentBean.setLessonId(lessonId);
    	assignmentBean.setStudentId(String.valueOf(studentId));
    	model.addAttribute("assignBean", assignmentBean);
    	
    	
    	return "assignLessons/ajaxAssignLessons";
	}
    
    @RequestMapping(value = "/getSearchLessons", method = RequestMethod.GET)
    public String getSearchLesons(@RequestParam(value="lessonIds", required=false) String lessonIds, 
    		Model model) {
    	
    	List<Quiz> lessons = assignmentService.getQuizzesFromSearch(lessonIds);
    	
    	AssignmentLessonToStudentBean assignmentBean = new AssignmentLessonToStudentBean();

    	model.addAttribute("lessons", lessons);
    	model.addAttribute("assignBean", assignmentBean);
    	
    	return "assignLessons/ajaxAssignLessons";
	}
}