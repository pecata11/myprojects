package com.xentio.eteacher.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.xentio.eteacher.domain.StudentActivity;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.SearchLessonFormBean;
import com.xentio.eteacher.domain.bean.StudentDashboardBean;
import com.xentio.eteacher.service.StudentService;
import com.xentio.eteacher.util.TimeUtils;


/**
 * Handles and retrieves student request
 */
@Controller
@RequestMapping("/students")
public class StudentController {
	@Autowired
	private StudentService studentService;

	@RequestMapping(value = "/dashboard", method = RequestMethod.GET)
	public String getDashboard(Model model) {
		User loggedStudent = studentService.getLoggedUser();
		long completedLessonsCount = studentService.getCompletedLessonsCount(loggedStudent.getId());
		model.addAttribute("completedCount", completedLessonsCount);
		
		StudentActivity studentActivity = studentService.getActivity(loggedStudent.getId());
		long timeSpentMlls = studentActivity != null ? studentActivity.getTimeSpentMlls() : 0;
		String timeSpent = TimeUtils.millisToLongDHMS(timeSpentMlls);
		model.addAttribute("timeSpent", timeSpent);
		List<StudentDashboardBean> statList=studentService.getStudentStatistic(loggedStudent.getId());

		model.addAttribute("statList",statList);
		
		return "student/dashboard";
	}
	
}
