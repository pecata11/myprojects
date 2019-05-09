package com.xentio.eteacher.controller;

import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.UserBean;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/teachers")
public class TeacherController {

	
	@Autowired
	private StudentService studentService;
	
    @RequestMapping(value = "/add", method = RequestMethod.GET)
    public String getAdd(Model model) {
    	model.addAttribute("user", new UserBean());

    	Map<String, String> roles = studentService.getRolesMap();
    	model.addAttribute("roles", roles);
    	
    	return "teacher/addTeacher";
	}
 
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    public String add(@ModelAttribute("user") UserBean user, ModelMap model) {
		if (user == null || StringUtils.isBlank(user.getFirstName())
				|| StringUtils.isBlank(user.getLastName())
				|| StringUtils.isBlank(user.getUsername())
				|| StringUtils.isBlank(user.getPassword())) {
			model.put("error", "All fields are mandatory!");
			return "teacher/addTeacher";
		}
		
		User existingStudent = studentService.searchByUsername(user.getUsername());
		if(existingStudent != null) {
			model.put("error", "Someone already has that username. Try another?");
			return "teacher/addTeacher";
		}
		
		studentService.add(user);

		model.put("addedAdmin", "Admin " + user.getUsername() + " added!");
		
		return "teacher/addedTeacher";
	}
    
}
