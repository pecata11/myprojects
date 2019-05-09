package com.xentio.eteacher.controller;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/signup")
public class SignUpController {
	@Autowired
	private StudentService studentService;

	@RequestMapping(method = RequestMethod.GET)
	public String getSignup(Model model) {
		model.addAttribute("studentAttribute", new User());

		return "login/signup";
	}

	@RequestMapping(method = RequestMethod.POST)
	public String postSignup(@ModelAttribute("studentAttribute") User user, ModelMap model) {
		if (user == null || StringUtils.isBlank(user.getFirstName())
				|| StringUtils.isBlank(user.getLastName())
				|| StringUtils.isBlank(user.getUsername())
				|| StringUtils.isBlank(user.getPassword())) {
			model.put("error", "All fields are mandatory!");
			return "login/signup";
		}

		User existingStudent = studentService.searchByUsername(user.getUsername());
		if (existingStudent != null) {
			model.put("error", "Someone already has that username. Try another?");
			return "login/signup";
		}

		studentService.add(user);

		return "login/signupSuccess";
	}

}
