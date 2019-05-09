package com.xentio.eteacher.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
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

import com.xentio.eteacher.domain.StudentClass;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AssignClassBean;
import com.xentio.eteacher.domain.bean.AssignStudentClassBean;
import com.xentio.eteacher.domain.bean.UserBean;
import com.xentio.eteacher.service.StudentClassService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/classes")
@SessionAttributes("teacher")
public class StudentClassController {

	@Autowired
	private StudentClassService studentClassService;
	
	@Autowired
	private StudentService studentService;
	protected static Logger logger = Logger.getLogger(StudentController.class);
	@ModelAttribute("teacher")
	public User createUser() {
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());
		return user;
	}
	
    @RequestMapping(value = "/create", method = RequestMethod.GET)
    public String getAdd(ModelMap modelMap, Model model) {
    
    	User teacher = (User)modelMap.get("teacher");
    	
    	List<StudentClass> list = studentClassService.getClassesByTeacher(teacher.getId());
    	model.addAttribute("classes", list);

    	model.addAttribute("studentClassAttribute", new StudentClass());
    	
    	return "class/addClass";
	}
    
    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public String create(@ModelAttribute("studentClassAttribute") StudentClass studentClass, ModelMap modelMap, Model model) {
    
    	User teacher = (User)modelMap.get("teacher");
    	
    	studentClass.setTeacher(teacher);
    	studentClassService.save(studentClass);

    	return "redirect:/api/classes/create";
	}    
    
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String edit(@RequestParam(value="id", required=true) Integer id, ModelMap modelMap, Model model) {
    
    	model.addAttribute("studentClassAttribute", studentClassService.get(id));
    	
    	User teacher = (User)modelMap.get("teacher");
    	
    	List<StudentClass> list = studentClassService.getClassesByTeacher(teacher.getId());
    	model.addAttribute("classes", list);
    	
    	return "class/addClass";
	}  
    
    @RequestMapping(value = "/edit", method = RequestMethod.POST)
    public String saveEdit(@ModelAttribute("studentClassAttribute") StudentClass studentClass, 
    		@RequestParam(value="id", required=true) Integer id, Model model) {

    	StudentClass existingStClass = studentClassService.get(id);
    	existingStClass.setName(studentClass.getName());
    	
    	studentClassService.save(existingStClass);
    	
		return "redirect:/api/classes/create";
	}    
    
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public String delete(@RequestParam(value="id", required=true) Integer id, Model model) {
    	studentClassService.delete(id);
    	return "redirect:/api/classes/create";
	}
    
    
    @RequestMapping(value = "/assign", method = RequestMethod.GET)
    public String assign(@RequestParam(value="id_student", required=false) Integer idStudent, ModelMap modelMap, Model model) {
    
    	AssignClassBean bean = new AssignClassBean();
    	if (idStudent != null){
    		bean.getStudentsIds().add(idStudent); // the checkbox with this id will be checked
    	} 
    	model.addAttribute("assignClassAttribute", bean);
    	
    	User teacher = (User)modelMap.get("teacher");
    	Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
    	model.addAttribute("classes", classes);
    	
    	List<User> students = studentService.getAll();
    	
    	List<AssignStudentClassBean> listGrid = new ArrayList<AssignStudentClassBean>();
    	for (User user : students) {
    		List<StudentClass> stClasses = studentClassService.getClassesByStudent(user.getId(), teacher.getId());
    		
    		AssignStudentClassBean b = new AssignStudentClassBean(user, stClasses.size() > 0 ? stClasses.get(0) : null);
    		listGrid.add(b);
		}
    	model.addAttribute("students", listGrid);
    	return "class/assignStudents";
	} 
    
    @RequestMapping(value = "/assign", method = RequestMethod.POST, params="add")
    public String addToClass(@ModelAttribute("studentClassAttribute") AssignClassBean assignClassBean, ModelMap modelMap, Model model) {
    
    	User teacher = (User)modelMap.get("teacher");
    	studentClassService.addStudentToClass(assignClassBean, teacher.getId());
    	
    	return "redirect:/api/classes/assign";
	}
    
    @RequestMapping(value = "/assign", method = RequestMethod.POST, params="remove")
    public String removeFromClass(@ModelAttribute("studentClassAttribute") AssignClassBean assignClassBean, ModelMap modelMap, Model model) {
    
    	User teacher = (User)modelMap.get("teacher");
    	studentClassService.removeStudentFromClass(assignClassBean, teacher.getId());
    	
    	return "redirect:/api/classes/assign";
	}    
    
    @RequestMapping(value = "/addStudent", method = RequestMethod.GET)
    public String getAdd(Model model,@RequestParam(value="classId", required=false) Integer classId) {
    	User teacher = studentService.getLoggedUser();
    	Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
    	model.addAttribute("classes", classes);
    	// Create new student and add to model
    	// This is the formBackingOBject
    	model.addAttribute("studentAttribute", new UserBean());

    	// This will resolve to /WEB-INF/jsp/student/addStudent.jsp
    	return "student/addStudentFromRoster";
	}
    
    @RequestMapping(value = "/addStudent", method = RequestMethod.POST)
    public String add(@ModelAttribute("studentAttribute") UserBean user, ModelMap modelMap) {
		logger.warn("Received request to add new student");
		
		if (user == null || StringUtils.isBlank(user.getFirstName())
				|| StringUtils.isBlank(user.getLastName())
				|| StringUtils.isBlank(user.getUsername())
				|| StringUtils.isBlank(user.getPassword())) {
			
			modelMap.put("error", "All fields are mandatory!");
	    	User teacher = studentService.getLoggedUser();
			Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
	    	modelMap.addAttribute("classes", classes);
			return "student/addStudentFromRoster";
		}
		
		User existingStudent = studentService.searchByUsername(user.getUsername());
		if(existingStudent != null) {
			modelMap.put("error", "Someone already has that username. Try another?");
			return "student/addStudentFromRoster";
		}

    	// The "studentAttribute" model has been passed to the controller from the JSP
    	// We use the name "studentAttribute" because the JSP uses that name
		
		user.setRoleId(4); // 4 ROLE_STUDENT
		// Call studentService to do the actual adding
		studentService.add(user);

		// if there is no logged user
		if("anonymousUser".equals(SecurityContextHolder.getContext().getAuthentication().getPrincipal())){
			return "student/addedStudent";
		}
		
		return "redirect:/api/classes/assign";
	}
    
    /**
     * Retrieves the edit page
     * 
     * @return the name of the JSP page
     */
    @RequestMapping(value = "/editStudent", method = RequestMethod.GET)
    public String getEdit(
    		@RequestParam(value="id", required=true) Integer id, 
    		Model model) {
    	
    	logger.warn("Received request to show edit page");
     
    	User teacher = studentService.getLoggedUser();
    	Map<String, String> classes = studentClassService.getMapClassesByTeacher(teacher.getId());
    	model.addAttribute("classes", classes);
    	
    	// Retrieve existing student and add to model
    	// This is the formBackingObject
        
    	User student = studentService.get(id);
    	UserBean usrb = new UserBean();
    	usrb.setFirstName(student.getFirstName());
    	usrb.setLastName(student.getLastName());
    	usrb.setUsername(student.getUsername());
    	usrb.setPassword(student.getPassword());
    	usrb.setId(student.getId());
   
    	List<StudentClass> classesList = studentClassService.getClassesByStudent(id, teacher.getId());
        if(!classesList.isEmpty()){
        	usrb.setClassId(classesList.get(0).getId());
        }
    	model.addAttribute("studentAttribute", usrb);
    	
    	// This will resolve to /WEB-INF/jsp/student/editStudent.jsp
    	return "student/editStudent";
	}
    /**
     * Edits an existing student by delegating the processing to studentService.
     * Displays a confirmation JSP page
     * 
     * @return  the name of the JSP page
     */
    @RequestMapping(value = "/editStudent", method = RequestMethod.POST)
    public String saveEdit(@ModelAttribute("studentAttribute") UserBean student, 
    		@RequestParam(value="id", required=true) Integer id, Model model) {
    	logger.warn("Received request to update student");
    
    	// The "studentAttribute" model has been passed to the controller from the JSP
    	// We use the name "studentAttribute" because the JSP uses that name
    	
    	// We manually assign the id because we disabled it in the JSP page
    	// When a field is disabled it will not be included in the ModelAttribute
    	student.setId(id);
    	
    	
    	// Delegate to studentService for editing
    	studentService.edit(student);
    	
    	// Add id reference to Model
		model.addAttribute("id", id);
		
		return "redirect:/api/classes/assign";
	}
    /**
     * Deletes an existing student by delegating the processing to studentService.
     * Displays a confirmation JSP page
     * 
     * @return  the name of the JSP page
     */
    @RequestMapping(value = "/deleteStudent", method = RequestMethod.GET)
    public String deleteStudent(@RequestParam(value="id", required=true) Integer id, Model model) {
   
		logger.warn("Received request to delete existing student");
		
		// Call studentService to do the actual deleting
		studentService.delete(id);
		
		// Add id reference to Model
		model.addAttribute("id", id);
    	
		return "redirect:/api/classes/assign";
	}
}
