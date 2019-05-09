package com.xentio.eteacher.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.xentio.eteacher.cs.CoreStandardsHelper;
import com.xentio.eteacher.domain.Goal;
import com.xentio.eteacher.domain.Group;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.GoalAssignmentBean;
import com.xentio.eteacher.domain.bean.GoalBean;
import com.xentio.eteacher.domain.bean.GroupStudent;
import com.xentio.eteacher.service.DashboardService;
import com.xentio.eteacher.service.GoalService;
import com.xentio.eteacher.service.StudentClassService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/goal")
@SessionAttributes("teacher")
public class GoalController {
	
	@Autowired
	private StudentClassService studentClassService;

	@Autowired
	private StudentService studentService;

	@Autowired
	private GoalService goalService;
	
	@Autowired
	private DashboardService dashboardService;	
	
	@ModelAttribute("teacher")
	public User createUser() {
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());
		return user;
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
    public String getList(Model model, ModelMap modelMap) {
		User teacher = (User)modelMap.get("teacher");
		List<Goal> goals = goalService.getGoalsByUserId(teacher.getId());
		model.addAttribute("goals", goals);
		
    	return "goal/goals";
	}
	
	@RequestMapping(value = "/create", method = RequestMethod.GET)
    public String getCreate(Model model, ModelMap modelMap) {
		CoreStandardsHelper.setGrades(model); 

		User teacher = (User)modelMap.get("teacher");
		Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
		model.addAttribute("classes", classes);
		
    	model.addAttribute("goal", new GoalBean());
    	return "goal/editGoal";
	}
    
    @RequestMapping(value = "/create", method = RequestMethod.POST, params="done")
   	public String postCreate(@Valid @ModelAttribute("goal") GoalBean goal, BindingResult result, Model model, ModelMap modelMap) {
    	goal.cleanDeletedAssignments();
    	if(result.hasErrors() || goal.getAssignments().isEmpty() || goal.getObjective() == null || "-1".equals(goal.getObjective())) {
    		reloadForm(goal, model, modelMap);
    		
        	if(goal.getAssignments().isEmpty()) {
        		model.addAttribute("emptyAssignmentsError", "Please add at least one assginment!");	
        	}
        	
        	if(goal.getObjective()== null || "-1".equals(goal.getObjective())) {
        		model.addAttribute("emptyObjectiveError", "Please select objective!");
        	}
        	
    		return "goal/editGoal";
    	}
    	
    	
    	if (goal.getId() > 0)  {
    		goalService.update(goal); 
    	} else {
    		User teacher = (User)modelMap.get("teacher");
    		goal.setCreatorId(teacher.getId());
    		goalService.save(goal);
    	}
    	
       	return "redirect:list";
    }
    
    @RequestMapping(value = "/create", method = RequestMethod.POST, params="cancel")
   	public String postCreate() {
       	return "redirect:list";
    }
    
    @RequestMapping(value = "/create", method = RequestMethod.POST, params="addAssignment")
   	public String postAddAssignment(@ModelAttribute("goal") GoalBean goal, Model model, ModelMap modelMap) {
    	goal.cleanDeletedAssignments();
    	CoreStandardsHelper.setObjectivePicker(model, goal.getGrade(), goal.getSubject(), goal.getStrand());
		User teacher = (User)modelMap.get("teacher");
		Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
		model.addAttribute("classes", classes);
		
    	
    	if(goal.getCurrAssignment().getClassId() <= 0) {
       		model.addAttribute("emptyClassError", "Please Select Class!");	
    		return "goal/editGoal";
    	}
    	
    	GoalAssignmentBean currAssignment = goal.getCurrAssignment();
    	if(currAssignment.getGroupId() > 0 &&  //TODO fixme - remove magic strings :)
    			currAssignment.getGroupName() != null && 
    			!currAssignment.getGroupName().contains("math") && 
    			!currAssignment.getGroupName().contains("literacy")) {
    		//this is student 
    		currAssignment.setStudentId(currAssignment.getGroupId());
    		currAssignment.setStudentName(currAssignment.getGroupName());
    		currAssignment.setGroupId(0);
    		currAssignment.setGroupName(null);
    	} else if(currAssignment.getGroupId() == -1) {
    		currAssignment.setGroupId(0);
    		currAssignment.setGroupName(null);
    	}
    	
    	goal.getAssignments().add(currAssignment);
    	goal.setCurrAssignment(new GoalAssignmentBean());
    	
       	return "goal/editGoal";
    }
    
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String getEdit(@RequestParam(value="id", required=true) Integer id, Model model, ModelMap modelMap) {
    	GoalBean goal = goalService.getGoalBean(id);
    	model.addAttribute("goal", goal);
    	
    	CoreStandardsHelper.setObjectivePicker(model, goal.getGrade(), goal.getSubject(), goal.getStrand());
		User teacher = (User)modelMap.get("teacher");
		Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
		model.addAttribute("classes", classes);

    	return "goal/editGoal";
	}
    
    private void reloadForm(GoalBean goal, Model model, ModelMap modelMap) {
    	CoreStandardsHelper.setObjectivePicker(model, goal.getGrade(), goal.getSubject(), goal.getStrand());
    	
		User teacher = (User)modelMap.get("teacher");
		Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
		model.addAttribute("classes", classes);

    	
    	model.addAttribute("groups", getMapGroups((int)goal.getCurrAssignment().getClassId(), goal.getSubject()));
    	model.addAttribute("goal", goal);
    }
    
    
	@RequestMapping(value = "/ajaxGroups", method = RequestMethod.GET)
	public @ResponseBody
	List<GroupStudent> getGroupsForDashboard(
			@RequestParam(value = "classId", required = false) Integer classId,
			@RequestParam(value = "subjectId", required = false) Integer subjectId) {
		return this.getGroups(classId, subjectId);
	}

    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public String delete(@RequestParam(value="id", required=true) Long id, Model model) {
    	goalService.delete(id);
    	
    	return "redirect:list";
	}

	
    private List<GroupStudent> getGroups(Integer classId, Integer subjectId) {
    	List<Group> grs = dashboardService.getGroupsByClassOrSubject(classId,subjectId);
    	List<GroupStudent> list = new ArrayList<GroupStudent>();
    	
    	GroupStudent g = new GroupStudent();
    	g.setId("-1");
    	g.setName("All Students");
    	list.add(g);
    	
    	for (Group group : grs) {
    		g = new GroupStudent();
    		g.setId("" + group.getId());
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
    
    private Map<String,String> getMapGroups(Integer classId,String subjectIdStr){
    	int subjectId = -1;
    	if("literacy".equals(subjectIdStr)) {
    		subjectId = 1; 
    	} else if("math".equals(subjectIdStr)) {
    		subjectId = 2;
    	}
    	
		Map<String, String> elements = new LinkedHashMap<String, String>();
    	List<GroupStudent> list = getGroups(classId,subjectId);
    	for (GroupStudent groupStudent : list) {
    		elements.put(groupStudent.getId(), groupStudent.getName());
		}
    	return elements;
    }   
}
